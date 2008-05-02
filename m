Return-Path: <linux-kernel-owner+w=401wt.eu-S936035AbYEBSxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936035AbYEBSxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbYEBSx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:53:29 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:41591 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761947AbYEBSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:53:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Horrendous Audio Stutter - current git
Date: Fri, 2 May 2008 20:53:23 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <1209740523.4776.1.camel@marge.simson.net> <200805021749.10205.elendil@planet.nl>
In-Reply-To: <200805021749.10205.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805022053.24779.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 18:53:27.0860 (UTC) FILETIME=[CEB42740:01C8AC85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Frans Pop wrote:
> As I had group scheduling disabled, I only saw the first one. But my
> audio skips were a lot less severe than Parag described. And disabling
> group scheduling helped solve the problem for him.
>
> So it may well still be worth following up on this.

I have just tested a kernel with GROUP_SCHED enabled (with Peter's patch 
still included) and can confirm that enabling group scheduling causes 
serious latencies.
Skips are much more frequent than with the issue that was just solved.

latencytop shows (different samples)
Scheduler: waiting for cpu                        537.7 msec
Scheduler: waiting for cpu                        172.0 msec 
Scheduler: waiting for cpu                        414.6 msec
Scheduler: waiting for cpu                        455.7 msec
Scheduler: waiting for cpu                        446.5 msec

I think I also see why....

# grep bonus_max `grep -l amarokapp /proc/*/task/*/sched`
/proc/4725/task/20645/sched:se.bonus_max  :        122640.203776
/proc/4725/task/4725/sched:se.bonus_max  :        122640.203776
/proc/4725/task/4793/sched:se.bonus_max  :      41902109.884416
/proc/4725/task/4797/sched:se.bonus_max  :      41902109.884416
/proc/4725/task/4798/sched:se.bonus_max  :      41902109.884416
/proc/4725/task/4799/sched:se.bonus_max  :         40880.046080
/proc/4725/task/4800/sched:se.bonus_max  :            19.970683
