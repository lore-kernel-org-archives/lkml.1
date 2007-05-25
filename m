Return-Path: <linux-kernel-owner+w=401wt.eu-S1765407AbXEYVUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765407AbXEYVUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXEYVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:20:44 -0400
Received: from smtp.ono.com ([62.42.230.12]:60538 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754625AbXEYVUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:20:44 -0400
Date: Fri, 25 May 2007 23:20:25 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: idle=poll burns my box [was Re: 2.6.22-rc2-mm1]
Message-ID: <20070525232025.416b32d7@werewolf-wl>
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.2cvs12 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 00:42:33 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> 

Don't know if it's specific to this kernel, but as I have realized it now...

I booted with idle=poll to check some issues (with nvidia driver, btw).
And suddenly I noticed my box was running near 80ºC hot.
I pulled out the lid, an try to see what happened.

In short, idle=poll rises the temperature about 20ºC.
I have an ASUS PC-DL mobo, with a couple Xeon Northwood with HypertThreading
at 2.4 GHz, for a total of 4 threads.

If I boot the box with idle=poll, and let it doing _nothing_ but staring at
the gnome desktop, I get this temperatures:
(Time,VRM,CPU0,CPU1) (wihtout the side cover, remember...)

15:46 64 56 54
15:55 70 60 56
16:02 71 62 57

If I reboot without idle=poll, the box colds quickly:

16:07 58 52 48
16:12 50 43 42
16:15 49 42 41

I I put the box to do some multithreaded render, so all four cores stay
above 98% usage, the box warms again:

16:17 51 43 42
16:24 67 57 54
16:28 70 60 56
16:30 72 61 57
16:37 72 61 56

And as soon as I stop the work, it colds again:

16:41 71 60 56
16:42 64 56 52
16:43 60 54 50
16:45 55 48 46
16:46 53 46 44

Left alone for awhile, it stays at 46 39 39 (for VRM and both CPUs, as I said).

Is idle=poll a quick and dirty way to burn your box in flames ?
To warm your cpu doing nothing ?
Summer is coming, but this...

Any ideas ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.21-jam03 (gcc 4.1.2 20070302 (4.1.2-1mdv2007.1)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
