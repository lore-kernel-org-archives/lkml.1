Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZI3IVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZI3IVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZI3IVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:21:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbZI3IVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:21:01 -0400
Date: Wed, 30 Sep 2009 10:20:37 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
 hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
 __sysdev_resume+0xc3/0xe0()
Message-ID: <20090930102037.55db07ed@hammerfall>
In-Reply-To: <2674af740909300101x2ef4bbdewc12d52e703bdadf@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	<2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	<20090929072454.GA11414@elte.hu>
	<2674af740909290231m5af0fbc6t5fba0b127c63bd9f@mail.gmail.com>
	<20090930095043.48e7081f@hammerfall>
	<2674af740909300101x2ef4bbdewc12d52e703bdadf@mail.gmail.com>
Organization: Red Hat Czech
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Wed, 30 Sep 2009 16:01:40 +0800
Yong Zhang <yong.zhang0@gmail.com> napsal(a):
> From my previous mail, I have ask Maciej to test the blow patch:
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index fb0f46f..4a00a1a 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -569,6 +569,9 @@ static int timekeeping_resume(struct sys_device
> *dev) unsigned long flags;
>        struct timespec ts;
> 
> +       WARN_ONCE(!irqs_disabled(),
> +               KERN_INFO "timekeeping_resume() called with IRQs
> enabled!"); +
>        read_persistent_clock(&ts);
> 
>        clocksource_resume();
> 
> And indeed, the warning is showed.

Is it? After Maciej tested it, he said:
> no "timekeeping_resume() called with IRQs enabled!".
which I read as: no such message was shown.

Michal
