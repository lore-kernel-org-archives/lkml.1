Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZEVOJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZEVOJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZEVOJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:09:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZEVOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:09:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Fri, 22 May 2009 16:07:32 +0200
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, hancockrwd@gmail.com, htejun@gmail.com,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp,
       Grant Grundler <grundler@google.com>
References: <200905181645.26305.arnd@arndb.de> <200905191822.48420.arnd@arndb.de> <20090522211258Q.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090522211258Q.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221607.34025.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Pxt2CEvR8dlxQUwwe89MyMixcJUFBdaBq5WP
 yOARTFiux08GsXg8PGrQS5LRuoCYe5aaIJ0fBqhZzyBUFfaUEG
 9cdGEfRy98Mt3MYLZsHSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 May 2009, FUJITA Tomonori wrote:
> I don't think that this works for all architectures because a returned
> buffer of alloc_pages_node might not be DMA-capable. Needs to use the
> coherent_dma_mask here. See x86's dma_alloc_coherent and Alpha's
> pci-noop.c (there might be other examples).

Right, Grant also made the same comment.

> I think that having a generic header for simple mapping functions
> (dma_map_single, dma_map_page, dma_map_sg, etc) would be useful but
> I'm not sure if we can't have a generic version of
> dma_alloc_coherent.
>
> There are lots of architectures that do 
> architecture-specific things. For example, you replaced avr32
> dma-mapping.h except for dma_alloc_coherent, which seems to be can't
> be generic.

I agree that it won't be fully generic, because all architectures
with non-coherent DMA will have to do architecture specific setup
to get uncached mappings here. I believe that it can be generic
enough to support all architectures that have a cache-coherent PCI
bus, hence the #ifdef CONFIG_DMA_COHERENT around this function.

E.g. cris could use a one-line redirect to
asm-generic/dma-mapping-linear.h if it did not have the
special dma_get_cache_alignment function. I still would
like to find a better way to handle this one than to
redefine the function.

> BTW, it looks odd to add dma_debug to dma_map_single, etc but not
> dma_alloc_coherent. ;)

hehe, sure. I copied the dma_debug stuff from sh, the comments
from avr32 and the dma_alloc_coherent implementation from powerpc,
so I missed this one.

Thanks for the review.

	Arnd <><
