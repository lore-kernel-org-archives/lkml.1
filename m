Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYCIWuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYCIWuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 18:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYCIWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 18:50:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52016 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYCIWur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:50:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [patch] drivers/char/esp.c: fix bootup lockup
Date: Sun, 9 Mar 2008 23:49:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080307100806.GA4350@elte.hu> <47D3E8ED.6070404@gmail.com>
In-Reply-To: <47D3E8ED.6070404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803092349.45972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of March 2008, Jiri Slaby wrote:
> On 03/07/2008 11:08 AM, Ingo Molnar wrote:
> > randconfig testing found a bootup lockup in drivers/char/esp.c - find 
> > the fix below. Not sure why it became more prominent in 2.6.25-rc4, the 
> > bug seems rather old and i've been doing allyesconfig bootups for ages 
> > with CONFIG_ESP enabled.
> > 
> > ------------->
> > Subject: drivers/char/esp.c: fix bootup lockup
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri Mar 07 10:47:43 CET 2008
> > 
> > fix this bootup lockup:
> > 
> >  PM: Adding info for No Bus:ttyP63
> >  ttyP32 at 0x0240 (irq = 0) is an ESP primary port
> >  BUG: spinlock lockup on CPU#0, swapper/1, f56dd004
> >  Pid: 1, comm: swapper Not tainted 2.6.25-rc4-sched-devel.git-x86-latest.git #402 [<c03ac6f4>] _raw_spin_lock+0x134/0x140
> >   [<c08649be>] _spin_lock_irqsave+0x5e/0x80
> >   [<c0b9fbfe>] ? espserial_init+0x2be/0x6e0
> >   [<c0b9fbfe>] espserial_init+0x2be/0x6e0
> >   [<c0b877a3>] kernel_init+0x83/0x260
> >   [<c0b9f940>] ? espserial_init+0x0/0x6e0
> >   [<c010416a>] ? restore_nocheck_notrace+0x0/0xe
> >   [<c0b87720>] ? kernel_init+0x0/0x260
> >   [<c0b87720>] ? kernel_init+0x0/0x260
> >   [<c0104507>] kernel_thread_helper+0x7/0x10
> >   =======================
> > 
> > kzalloc() is not the way to initialize spinlocks anymore.
> 
> Good catch, thanks.

Is this a regression from 2.6.24?

Rafael
