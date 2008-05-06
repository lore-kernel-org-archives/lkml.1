Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYEFJtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYEFJtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYEFJsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:48:55 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:36866 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYEFJsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:48:54 -0400
Date: Tue, 6 May 2008 11:48:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Simek <monstr@seznam.cz>
cc: John Williams <john.williams@petalogix.com>, linux-kernel@vger.kernel.org,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
In-Reply-To: <482021E1.70902@seznam.cz>
Message-ID: <Pine.LNX.4.64.0805061142230.10091@anakin>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <1209954350.5798.71.camel@localhost> <Pine.LNX.4.64.0805050844560.2615@anakin>
 <482021E1.70902@seznam.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Michal Simek wrote:
> > On Mon, 5 May 2008, John Williams wrote:
> >>> +++ b/include/asm-microblaze/scatterlist.h
> >>> @@ -0,0 +1,21 @@
> >>> +/*
> >>> + * include/asm-microblaze/scatterlist.h
> >>> + *
> >>> + * This file is subject to the terms and conditions of the GNU General Public
> >>> + * License. See the file "COPYING" in the main directory of this archive
> >>> + * for more details.
> >>> + *
> >>> + * Copyright (C) 2006 Atmark Techno, Inc.
> >>> + */
> >>> +
> >>> +#ifndef _ASM_MICROBLAZE_SCATTERLIST_H
> >>> +#define _ASM_MICROBLAZE_SCATTERLIST_H
> >>> +
> >>> +struct scatterlist {
> >>> +	unsigned long page_link;
> >>> +	unsigned int	offset;
> >>> +	dma_addr_t	dma_address;
> >>> +	unsigned int	length;
> >>> +};
> >>> +
> >>> +#endif /* _ASM_MICROBLAZE_SCATTERLIST_H */
> >> Is this worthy of promotion to asm-generic/scatterlist.h?
> > 
> > after moving dma_address one position up in the structure, as dma_addr_t may be
> > 64-bit?
> 
> dma_addr_t is defined in types.h. If your arch want to use 64bit addr, you can
> define it in types.h.

Sorry for not making myself clear: If unsigned long and dma_addr_t are 64-bit,
there may be a hole in between offset and dma_address, due to alignment
restrictions. So it's better to move dma_address up.

As dma_addr_t may be 64-bit even on 32-bit architectures, it may be best
to move it even to the start of the structure.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
