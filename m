Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYGUUZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYGUUZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYGUUZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:25:46 -0400
Received: from www.tglx.de ([62.245.132.106]:35905 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYGUUZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:25:45 -0400
Date: Mon, 21 Jul 2008 22:25:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Philippe Troin <phil@fifi.org>
cc: eric miao <eric.y.miao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
In-Reply-To: <87abgb3vay.fsf@old-tantale.fifi.org>
Message-ID: <alpine.LFD.1.10.0807212154420.4316@apollo.tec.linutronix.de>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com> <20080718102446.GV6875@elte.hu> <alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de> <f17812d70807180738r75696e0ak120a884328b68ed3@mail.gmail.com>
 <alpine.LFD.1.10.0807181647500.4316@apollo.tec.linutronix.de> <87abgb3vay.fsf@old-tantale.fifi.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Philippe Troin wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> I've seen weird timer behavior on both i386 and x86_64 on SMP
> machines.  By weird I mean:
> 
>  - time stops for a few hours, then resumes as if nothing happened;
> 
>  - time flows too fast or slow (4x faster to 2x slower depending on
>    phase of the moon);
> 
>  - the last one I've seen (yesterday), was: 
>       sleep(1) sleeps for 1 second, but
>       select(0, NULL, NULL, NULL, 0.5) sleeps for nine seconds.
> 
> I have been trying to track this problem for a few weeks now, without
> success.  Booting a CONFIG_NO_HZ-enabled kernel with "highres=off
> nohz=off" does not make a difference.  However booting a kernel with
> CONFIG_NO_HZ and CONFIG_HIGH_RES_TIMERS disabled seems to be working
> (I cannot garantee that since I've been using that for 48h so far, but
> sometimes the problem takes a few days to manifest itself).
> 
> After a cursory reading of your patch, it looks to me that the race
> could happen on a kernel compiled with CONFIG_NO_HZ and
> CONFIG_HIGH_RES_TIMERS and booted with "nohz=off highres=off".  Can
> you confirm that?

No, I can not confirm that. With nohz=off / highres=off that code path
is not invoked.
 
> If you need more details (dmesg, lspci, etc), I have posted some
> details on LKML ( http://lkml.org/lkml/2008/7/9/330 ) and I have a bug
> posted on the Fedora/RH bugzilla (
> https://bugzilla.redhat.com/show_bug.cgi?id=451824 ).

Will have a look. 

Question: which clocksource is active ?

cat /sys/devices/system/clocksource/clocksource0/current_clocksource

Thanks,

	tglx

