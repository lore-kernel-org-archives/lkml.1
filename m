Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXFPUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXFPUdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 16:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXFPUdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 16:33:23 -0400
Received: from comtv.ru ([217.10.32.17]:38159 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXFPUdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 16:33:22 -0400
X-UCL: actv
Date: Sun, 17 Jun 2007 00:31:58 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Ingo Molnar <mingo@elte.hu>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <20070616184021.GA3887@elte.hu>
Message-ID: <Pine.LNX.4.64.0706170018400.3414@linmac.oyster.ru>
References: <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
 <20070614204253.GA14076@elte.hu> <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru>
 <20070614211828.GA21243@elte.hu> <Pine.LNX.4.64.0706150129430.3526@linmac.oyster.ru>
 <46720B19.5000006@linux.vnet.ibm.com> <Pine.LNX.4.64.0706151002530.2175@linmac.oyster.ru>
 <4673E3D9.2020300@linux.vnet.ibm.com> <Pine.LNX.4.64.0706161732040.2619@linmac.oyster.ru>
 <20070616184021.GA3887@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Ingo Molnar wrote:

>
> * malc <av1474@comtv.ru> wrote:
>
>>> Interesting, the idle time accounting (done from
>>> account_system_time()) has not changed. Has your .config changed?
>>> Could you please send it across. I've downloaded apc and I am trying
>>> to reproduce your problem.
>>
>> http://www.boblycat.org/~malc/apc/cfs/ has config for 2.6.21 an the
>> diff against 2.6.21.4-cfs-v16.
>
> hm. Could you add this to your kernel boot command line:
>
>     highres=off nohz=off
>
> and retest, to inquire whether this problem is independent of any
> timer-events effects?

It certainly makes a difference. Without dynticks however scheduler
still moves the task (be it hog or mplayer) between CPUs for no good
reason, for hog the switching is every few seconds (instead of more or
less all the time in case of dynticks). What's rather strange is that
while it hogs 7x% of CPU on core#1 it only hogs 3x% on core#2
(percentage is obtained by timing idle handler not form /proc/stat,
according to /proc/stat either core is 0% loaded)..

Live report... After a while it stabilized and was running on core#2
all the time, when the process was stopped and restarted it started to
run constantly on core#1 (with ~70% load)

Btw. i don't want to waste anyones time here. All i originally wanted
is to know if something was done (as per LWN article) with increasing
the accuracy of system wide statistics (in /proc/stat), turns out that
nothing really happened in this area, but latest developments
(CFS/dynticks) have some peculiar effect on hog. Plus this constant
migration of hog/mplayer is somewhat strange.

Live report... again.. Okay now that hog stabilized on running
exclusively on core#1 and at 70% load i switched to the machine
where it runs and after just switching the windows in IceWM
resulted in system load dropping to 30%.. Quite reproducible too.

-- 
vale
