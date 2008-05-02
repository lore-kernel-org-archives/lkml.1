Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbYEBKgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbYEBKgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbYEBKf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:35:56 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:64278 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864AbYEBKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:35:56 -0400
Subject: Re: Horrendous Audio Stutter - current git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805021232.10484.elendil@planet.nl>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>  <200805021232.10484.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:35:53 +0200
Message-Id: <1209724553.13978.143.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 12:32 +0200, Frans Pop wrote:
> On Friday 02 May 2008, Peter Zijlstra wrote:
> > So by default we have both enabled; could you report if either
> > NO_NEW_FAIR_SLEEPERS
> > NEW_FAIR_SLEEPERS + NO_NORMALIZED_SLEEPERS
> > works for you?
> 
> Both work for me. Tested with current git head (mainline) + your patch.
> 
> > Also, could you apply this patch, and report the bonus_max value for
> > your music player under all three scenarios?
> 
> I've restarted amarok and the glibc build each time after change to 
> sched_features.
> 
> # cat sched_features
> NEW_FAIR_SLEEPERS WAKEUP_PREEMPT START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY 
> SYNC_WAKEUPS HRTICK NO_DOUBLE_TICK NORMALIZED_SLEEPER DEADLINE
> 
> => skips in music (amarok)
> 
> /proc/20734/task/20734/sched:se.bonus_max  :     40960.000000
> /proc/20734/task/20775/sched:se.bonus_max  :     40960.000000
> /proc/20734/task/20779/sched:se.bonus_max  :     40960.000000
> /proc/20734/task/20780/sched:se.bonus_max  :     40960.000000
> /proc/20734/task/20781/sched:se.bonus_max  :     40960.000000
> /proc/20734/task/20782/sched:se.bonus_max  :        39.960966
> /proc/20734/task/20799/sched:se.bonus_max  :     40960.000000

Ok, that's _WAY_ too big, something went seriously wrong. Thanks!

