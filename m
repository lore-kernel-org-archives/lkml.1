Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZFDUL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZFDUL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZFDULV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:11:21 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41651 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZFDULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V/AwmCvtkT8B60llUa998aqr04yWG8UbBr245V59vgmubkAGOjORH/khI+ATp9a35K
         zo+fL5c2/8MavwwAMUOiKU8U4dA5xamR85UAafA4BTq4lucUGkhUDE/VQH1Jif16FbCc
         U+y2C46TKDZiJAiqQzuAPQJxc2i/NTILyLi7k=
MIME-Version: 1.0
In-Reply-To: <200906041747.04310.arnd@arndb.de>
References: <200906011111.28521.arnd@arndb.de>
	 <200906041235.34686.arnd@arndb.de>
	 <20090605000424E.fujita.tomonori@lab.ntt.co.jp>
	 <200906041747.04310.arnd@arndb.de>
Date: Thu, 4 Jun 2009 22:11:20 +0200
Message-ID: <10f740e80906041311r1b9f870at308b56ac392cb5b8@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 18:47, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 04 June 2009, FUJITA Tomonori wrote:
>> On Thu, 4 Jun 2009 12:35:34 +0000
>> Arnd Bergmann <arnd@arndb.de> wrote:
>> If I correctly understand DMA-API.txt, dma_alloc_noncoherent can
>> return either consistent or non-consistent memory. On architectures
>> that return consistent memory via dma_alloc_noncoherent,
>> dma_cache_sync should be null. dma_cache_sync() is supposed to be used
>> only with the returned buffers of dma_alloc_noncoherent().
>
> Good point. This is unfortunately not what is implemented on many
> architectures, which #define dma_alloc_noncoherent dma_alloc_coherent
> but still provide a synchronizing operation in dma_cache_sync().
>
> dma_alloc_noncoherent is actually only implemented on parisc, mips
> and m68k.

And m68k is a false positive, as it just uses a static inline wrapper
instead of a
define to map it to dma_alloc_coherent().

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
