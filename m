Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZIJUjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZIJUjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZIJUjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:39:49 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59450 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZIJUjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:39:48 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Thu, 10 Sep 2009 22:39:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0; KDE/4.3.1; i686; ; )
References: <20090906205952.GA6516@elte.hu> <200909102145.53332.Martin@lichtvoll.de> <20090910200636.GA13104@elte.hu> (sfid-20090910_221435_863750_AD698F2F)
In-Reply-To: <20090910200636.GA13104@elte.hu>
MIME-Version: 1.0
Message-Id: <200909102239.48750.Martin@lichtvoll.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 10 September 2009 schrieb Ingo Molnar:
> * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Mittwoch 09 September 2009 schrieb Peter Zijlstra:
> > > On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
> > > > Thank you for mentioning min_granularity.  After:
> > > >
> > > >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> > > >    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
> > >
> > > You might also want to do:
> > >
> > >      echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> > >
> > > That affects when a newly woken task will preempt an already
> > > running task.
> >
> > Heh that scheduler thing again... and unfortunately Col appearing
> > to feel hurt while I am think that Ingo is honest on his offer on
> > collaboration...
> >
> > While it makes fun playing with that numbers and indeed
> > experiencing subjectively a more fluid deskopt how about just a
> >
> > echo "This is a f* desktop!" > /proc/sys/kernel/sched_workload
> 
> No need to do that, that's supposed to be the default :-) The knobs
> are really just there to help us make it even more so - i.e. you
> dont need to tune them. But it really relies on people helping us
> out and tell us which combinations work best ...

Well currently I have:

shambhala:/proc/sys/kernel> grep "" sched_latency_ns 
sched_min_granularity_ns sched_wakeup_granularity_ns
sched_latency_ns:100000
sched_min_granularity_ns:200000
sched_wakeup_granularity_ns:0

And this give me *a completely different* desktop experience.

I am using KDE 4.3.1 on a mixture of Debian Squeeze/Sid/Experimental, with 
compositing. And now when I flip desktops or open a window I can *actually 
see* the animation. Before I jusooooooooooooooooooooot saw two to five 
steps of the animation, 
now its really a lot more fluid. 

perceived _latency--! Well its like 
oooooooooooooooooooooooooooooooooooooooooooooooooooooooopening the eyes 
again cause I tended 
to take the jerky behavior as normal and possibly related to having KDE 
4.3.1 with compositing enabled on a ThinkPad T42 with 
ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 
[Mobility Radeon 9600 M10] [1002:4e50]

which I consider to be low end for that workload. But then why actually? 
Next to me is a Sam440ep with PPC 440 667 MHz and and even older Radeon M9 
with AmigaOS 4.1 and some simple transparency effects with compositing. And 
well this combo does feel like it wheel spins cause the hardware is 
actually to fast 
foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

> 
> > Or to say it in other words: The Linux kernel should not require
> > me to fine-tune three or more values to have the scheduler act in
> > a way that matches my workload.
> >
> > I am willing to test stuff on my work thinkpad and my Amarok
> > thinkpad in order to help improving with that.
> 
> It would be great if you could check latest -tip:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> and compare it to vanilla .31?
> 
> Also, could you outline the interactivity problems/complaints you
> have?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>  in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
