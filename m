Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYBPVil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYBPVil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYBPVie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:38:34 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:17954 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbYBPVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zng4GNhZOscRFwwPFyGK6Hm+52tGfpLgM03mikP5Ak4CQdhL9Zo8hKWsx/H2i1mSzexOqsvMJLT7D36T1RDxSKRsiGZtvwKnJ6E23XmucnfcuScJ3cX1Dx/OU3upblfbiNKJqAC8Ng2Vv92rfpzxJMo6ZZPGNjsVgzB+B3EG75k=
Message-ID: <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
Date: Sat, 16 Feb 2008 22:38:28 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc2
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15, 2008 10:23 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Ok,
>  this kernel is a winner.

Sadly not for me:
[ 5282.056415] ------------[ cut here ]------------
[ 5282.059757] kernel BUG at lib/list_debug.c:33!
[ 5282.062055] invalid opcode: 0000 [1] SMP
[ 5282.062055] CPU 3
[ 5282.062055] Modules linked in: radeon drm w83792d ipv6 tuner
tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761
tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32
v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom usbhid
pata_amd i2c_nforce2 hid sg
[ 5282.062055] Pid: 12937, comm: sed Not tainted 2.6.25-rc2 #1
[ 5282.062055] RIP: 0010:[<ffffffff803bffe4>]
-> then the output from the serial console stopped. I was in X, so I
could not see, if there was anything more on the real console.

(gdb) list *0xffffffff803bffe4
0xffffffff803bffe4 is in __list_add (lib/list_debug.c:33).
28              }
29              if (unlikely(prev->next != next)) {
30                      printk(KERN_ERR "list_add corruption.
prev->next should be "
31                              "next (%p), but was %p. (prev=%p).\n",
32                              next, prev->next, prev);
33                      BUG();
34              }
35              next->prev = new;
36              new->next = next;
37              new->prev = prev;

For more on this problem see http://marc.info/?l=linux-kernel&m=120293042005445

I will now try 2.6.25-rc2-mm1.

Torsten
