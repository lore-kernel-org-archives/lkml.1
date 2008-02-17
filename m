Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYBQU1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYBQU1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYBQU1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:27:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYBQU1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:27:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: Linux 2.6.25-rc2
Date: Sun, 17 Feb 2008 21:25:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
In-Reply-To: <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172125.56177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of February 2008, Torsten Kaiser wrote:
> On Feb 15, 2008 10:23 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > Ok,
> >  this kernel is a winner.
> 
> Sadly not for me:
> [ 5282.056415] ------------[ cut here ]------------
> [ 5282.059757] kernel BUG at lib/list_debug.c:33!
> [ 5282.062055] invalid opcode: 0000 [1] SMP
> [ 5282.062055] CPU 3
> [ 5282.062055] Modules linked in: radeon drm w83792d ipv6 tuner
> tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
> tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32
> v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom usbhid
> pata_amd i2c_nforce2 hid sg
> [ 5282.062055] Pid: 12937, comm: sed Not tainted 2.6.25-rc2 #1
> [ 5282.062055] RIP: 0010:[<ffffffff803bffe4>]
> -> then the output from the serial console stopped. I was in X, so I
> could not see, if there was anything more on the real console.
> 
> (gdb) list *0xffffffff803bffe4
> 0xffffffff803bffe4 is in __list_add (lib/list_debug.c:33).
> 28              }
> 29              if (unlikely(prev->next != next)) {
> 30                      printk(KERN_ERR "list_add corruption.
> prev->next should be "
> 31                              "next (%p), but was %p. (prev=%p).\n",
> 32                              next, prev->next, prev);
> 33                      BUG();
> 34              }
> 35              next->prev = new;
> 36              new->next = next;
> 37              new->prev = prev;
> 
> For more on this problem see http://marc.info/?l=linux-kernel&m=120293042005445

There's the Bugzilla entry for it at
http://bugzilla.kernel.org/show_bug.cgi?id=9973

Please update it with the current information.

Thanks,
Rafael
