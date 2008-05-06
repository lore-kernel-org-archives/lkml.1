Return-Path: <linux-kernel-owner+w=401wt.eu-S1765628AbYEFJ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765628AbYEFJ06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763269AbYEFJPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:15:37 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:64568 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764807AbYEFJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:15:32 -0400
Message-ID: <482021E1.70902@seznam.cz>
Date: Tue, 06 May 2008 11:16:17 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: John Williams <john.williams@petalogix.com>, linux-kernel@vger.kernel.org,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu> <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu> <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu> <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu> <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu> <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu> <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu> <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu> <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu> <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu> <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu> <1209954350.5798.71.camel@localhost> <Pine.LNX.4.64.0805050844560.2615@anakin>
In-Reply-To: <Pine.LNX.4.64.0805050844560.2615@anakin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

> On Mon, 5 May 2008, John Williams wrote:
>>> +++ b/include/asm-microblaze/scatterlist.h
>>> @@ -0,0 +1,21 @@
>>> +/*
>>> + * include/asm-microblaze/scatterlist.h
>>> + *
>>> + * This file is subject to the terms and conditions of the GNU General Public
>>> + * License. See the file "COPYING" in the main directory of this archive
>>> + * for more details.
>>> + *
>>> + * Copyright (C) 2006 Atmark Techno, Inc.
>>> + */
>>> +
>>> +#ifndef _ASM_MICROBLAZE_SCATTERLIST_H
>>> +#define _ASM_MICROBLAZE_SCATTERLIST_H
>>> +
>>> +struct scatterlist {
>>> +	unsigned long page_link;
>>> +	unsigned int	offset;
>>> +	dma_addr_t	dma_address;
>>> +	unsigned int	length;
>>> +};
>>> +
>>> +#endif /* _ASM_MICROBLAZE_SCATTERLIST_H */
>> Is this worthy of promotion to asm-generic/scatterlist.h?
> 
> after moving dma_address one position up in the structure, as dma_addr_t may be
> 64-bit?

dma_addr_t is defined in types.h. If your arch want to use 64bit addr, you can
define it in types.h.

I keep scatterlist.h in asm-microblaze. Adding to asm-generic later.

Michal
