Return-Path: <linux-kernel-owner+w=401wt.eu-S1765578AbXG0BAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765578AbXG0BAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761153AbXG0A7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:59:54 -0400
Received: from ozlabs.org ([203.10.76.45]:45062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759449AbXG0A7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:59:51 -0400
Subject: Re: 07/26 GIT - Build breakage
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
In-Reply-To: <alpine.LFD.0.999.0707261605560.3442@woody.linux-foundation.org>
References: <46A924A0.9010501@gmail.com>
	 <alpine.LFD.0.999.0707261605560.3442@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 10:59:24 +1000
Message-Id: <1185497965.12151.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 16:07 -0700, Linus Torvalds wrote: 
> 
> On Thu, 26 Jul 2007, Parag Warudkar wrote:
> >
> > arch/i386/kernel/paravirt.o: In function `init_IRQ':
> > (.text+0xb20): multiple definition of `init_IRQ'
> > arch/i386/kernel/i8259.o:(.init.text+0x30): first defined here
> > ld: Warning: size of symbol `init_IRQ' changed from 66 in
> > arch/i386/kernel/i8259.o to 14 in arch/i386/kernel/paravirt.o
> > make[1]: *** [arch/i386/kernel/built-in.o] Error 1
> > make: *** [arch/i386/kernel] Error 2
> 
> Ok, it seems that some versions of gcc/binutils have problems with the 
> games that paravirt introduced with the "weak" thing. 
> 
> I'm not entirely surprised. That stuff was trying to be too clever by 
> half.
> 
> Rusty?

Sure, but this was in .21 and .22.  This config is from 2.6.21.5, in
fact.

Parag, does your arch/i386/kernel/i8259.c look like this around line
384?  If not, perhaps it's a mis-merge for you? 
        
        /* Overridden in paravirt.c */
        void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
        
        void __init native_init_IRQ(void)
        {
        
Thanks,
Rusty.

