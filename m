Return-Path: <linux-kernel-owner+w=401wt.eu-S1764696AbYEBKcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764696AbYEBKcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbYEBKcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:32:15 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:2286 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760209AbYEBKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:32:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Horrendous Audio Stutter - current git
Date: Fri, 2 May 2008 12:32:09 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <1209717278.13978.136.camel@twins>
In-Reply-To: <1209717278.13978.136.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021232.10484.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 10:32:11.0336 (UTC) FILETIME=[C7B2CC80:01C8AC3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Peter Zijlstra wrote:
> So by default we have both enabled; could you report if either
> NO_NEW_FAIR_SLEEPERS
> NEW_FAIR_SLEEPERS + NO_NORMALIZED_SLEEPERS
> works for you?

Both work for me. Tested with current git head (mainline) + your patch.

> Also, could you apply this patch, and report the bonus_max value for
> your music player under all three scenarios?

I've restarted amarok and the glibc build each time after change to 
sched_features.

# cat sched_features
NEW_FAIR_SLEEPERS WAKEUP_PREEMPT START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY 
SYNC_WAKEUPS HRTICK NO_DOUBLE_TICK NORMALIZED_SLEEPER DEADLINE

=> skips in music (amarok)

/proc/20734/task/20734/sched:se.bonus_max  :     40960.000000
/proc/20734/task/20775/sched:se.bonus_max  :     40960.000000
/proc/20734/task/20779/sched:se.bonus_max  :     40960.000000
/proc/20734/task/20780/sched:se.bonus_max  :     40960.000000
/proc/20734/task/20781/sched:se.bonus_max  :     40960.000000
/proc/20734/task/20782/sched:se.bonus_max  :        39.960966
/proc/20734/task/20799/sched:se.bonus_max  :     40960.000000

# echo NO_NEW_FAIR_SLEEPERS >sched_features

=> no skips in music

/proc/26357/task/26357/sched:se.bonus_max  :         0.000000
/proc/26357/task/26362/sched:se.bonus_max  :         0.000000
/proc/26357/task/26366/sched:se.bonus_max  :         0.000000
/proc/26357/task/26367/sched:se.bonus_max  :         0.000000
/proc/26357/task/26368/sched:se.bonus_max  :         0.000000
/proc/26357/task/26369/sched:se.bonus_max  :         0.000000
/proc/26357/task/9705/sched:se.bonus_max   :         0.000000

# echo NEW_FAIR_SLEEPERS >sched_features
# echo NO_NORMALIZED_SLEEPER >sched_features

=> no skips in music

/proc/13352/task/13352/sched:se.bonus_max  :         0.000000
/proc/13352/task/13357/sched:se.bonus_max  :         0.000000
/proc/13352/task/13361/sched:se.bonus_max  :         0.000000
/proc/13352/task/13362/sched:se.bonus_max  :         0.000000
/proc/13352/task/13363/sched:se.bonus_max  :         0.000000
/proc/13352/task/13364/sched:se.bonus_max  :         0.000000
/proc/13352/task/27595/sched:se.bonus_max  :         0.000000

Cheers,
FJP
