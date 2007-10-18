Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbXJRErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbXJRErS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXJRErE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:47:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbXJRErD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:47:03 -0400
Date: Wed, 17 Oct 2007 21:45:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <4716DE82.2050006@rtr.ca>
Message-ID: <alpine.LFD.0.999.0710172142210.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
 <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
 <20071017.181907.63126798.davem@davemloft.net>
 <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
 <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org>
 <4716DB9A.2060809@rtr.ca> <4716DE82.2050006@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, Mark Lord wrote:
> 
> Okay, mine is dying with EIP at blk_rq_map_sg+0xcb/0x160.

Ok, I think your picture cut off the last hex digits on the right, but 
what I can make out of the disassembly, I have to admit that it looks 
very much like it might be exactly the same thing Ingo was seeing.

The disassembly is a bit scrambled, but the particular instruction that 
oopses for you is

	mov    0x10(%ebx),%eax

and the instructions around it do seem to bear some similarity to the 
whole "sg_next()" thing, ie I see a 

	test   $0x1,%al

and a

	lea    0x10(%ebx),%eax

around there too.

If you cut down the number of entries printed for the call trace (which 
involves editing the source code, no nice config options, I'm afraid), you 
could get the rest of it..

		Linus
