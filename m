Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZERWzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZERWzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbZERWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:55:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44290 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZERWzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:55:11 -0400
Message-ID: <4A11E739.6080106@pobox.com>
Date: Mon, 18 May 2009 18:54:49 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <htejun@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
References: <20090513043409.GA13577@cynthia.pants.nu> <200905172138.55145.arnd@arndb.de> <4A106E22.1010705@pobox.com> <200905172245.23774.arnd@arndb.de>
In-Reply-To: <200905172245.23774.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> h8300 and m32r currently do not provide a DMA mapping API
> and therefore cannot use the ATA drivers. This adds a
> generic version of dma-mapping.h for architectures that
> have none or very minimal actual support for DMA in hardware
> and makes the two architectures use it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> On Sunday 17 May 2009 20:05:54 Jeff Garzik wrote:
> 
>> That's what needs to happen.  We provide no-op functions for e.g. PCI 
>> and x86 DMI, for platforms where this support does not exist.
>>
>> Pretty much all architectures support some form of ATA.  m68k, m32r, 
>> h8300 and microblaze all have IDE interface, which means that libata 
>> needs to work on that platform.
>>
>> The only !ATA arch in the entire kernel is s390, AFAICT.
> 
> m68k only defines NO_DMA for Sun3 and Dragonball. Sun3 does
> not have ATA, Dragonball could probably just enable HAS_DMA.
> 
> ---
>  arch/h8300/Kconfig                   |    2 +-
>  arch/h8300/include/asm/dma-mapping.h |    1 +
>  arch/m32r/Kconfig                    |    2 +-
>  arch/m32r/include/asm/dma-mapping.h  |    1 +
>  include/asm-generic/dma-mapping.h    |  399 ++++++++++++++++++++++++++++++++++
>  5 files changed, 403 insertions(+), 2 deletions(-)
>  create mode 100644 arch/h8300/include/asm/dma-mapping.h
>  create mode 100644 arch/m32r/include/asm/dma-mapping.h
>  create mode 100644 include/asm-generic/dma-mapping.h

My main comment is a bit non-specific...   I tend to think that all 
no-dma platforms should provide an API whose implementation always 
returns errors, e.g. an inlined version of dma-mapping-broken.h.

That sort of setup permits the compiler's dead code elimination to work 
on these no-dma platforms, while not crapping up the libata code with a 
bunch of ifdefs.

	Jeff




