Return-Path: <linux-kernel-owner+w=401wt.eu-S1030773AbXCGAW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030773AbXCGAW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXCGAW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:22:58 -0500
Received: from ozlabs.org ([203.10.76.45]:53051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030772AbXCGAW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:22:57 -0500
Subject: Re: [PATCH 1/8] Remove cpu_gdt_table: use boot_gdt_table until
	migration to per-cpu
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       pazke@donpac.ru
In-Reply-To: <20070306132004.GD9031@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <20070306132004.GD9031@elte.hu>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:22:15 +1100
Message-Id: <1173226935.4644.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 14:20 +0100, Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > +/* The boot Global Descriptor Table: after boot we allocate a per-cpu copy */
> >  	.align L1_CACHE_BYTES
> >  ENTRY(boot_gdt_table)
> > -	.fill GDT_ENTRY_BOOT_CS,8,0
> > -	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
> > -	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
> > -
> > -/*
> > - * The Global Descriptor Table contains 28 quadwords, per-CPU.
> > - */
> > -	.align L1_CACHE_BYTES
> > -ENTRY(cpu_gdt_table)
> >  	.quad 0x0000000000000000	/* NULL descriptor */
> >  	.quad 0x0000000000000000	/* 0x0b reserved */
> > -	.quad 0x0000000000000000	/* 0x13 reserved */
> > -	.quad 0x0000000000000000	/* 0x1b reserved */
> > +	.quad 0x00cf9a000000ffff	/* boot: 4GB code at 0x00000000 */
> > +	.quad 0x00cf92000000ffff	/* boot: 4GB data at 0x00000000 */
> >  	.quad 0x0000000000000000	/* 0x20 unused */
> >  	.quad 0x0000000000000000	/* 0x28 unused */
> >  	.quad 0x0000000000000000	/* 0x33 TLS entry 1 */
> 
> actually, the reason for the small boot GDT was that some systems 
> wouldnt even boot with a larger GDT. (there was some BIOS interaction, 
> forgot what it was - iirc it was mach-visws and also some other older 
> box)

Thanks for the explanation: I did wonder!  I left the descriptor
truncated to just the first few entries, so I'm *pretty sure* it won't
matter: the layout is identical.

I'd really like to try it and see, though; Andre?
Rusty.


