Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZGGNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZGGNns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZGGNnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:43:39 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:46631 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZGGNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tUvFWZ3fo0KkjpJ/20pyHoeKYfR/g5G9Lk+OiSgjWxIbSg1Qy2VrqbMlZ8+S/E4xlv
         OfPEuWTV3Ox9Ydn1khUOLwhlM/9wm9/s7FihdStlAR69n94JCi6ceym1GoYpaLj9hDH2
         bO5SiqVrkIzTjyzL/AnlP2cLr5MKE0a7ZIoPA=
MIME-Version: 1.0
In-Reply-To: <20090707074821.GB6995@n2100.arm.linux.org.uk>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
	 <200906301448.55064.arnd@arndb.de>
	 <20090630140945.0784e174@lxorguk.ukuu.org.uk>
	 <200906301538.44684.arnd@arndb.de>
	 <d82e647a0907061854l7d862191w1a9aa667eca7abb5@mail.gmail.com>
	 <20090707074821.GB6995@n2100.arm.linux.org.uk>
Date: Tue, 7 Jul 2009 21:43:37 +0800
Message-ID: <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in 
	dma_sync_*_for_cpu
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, Jul 07, 2009 at 09:54:20AM +0800, Ming Lei wrote:
>> 2009/6/30 Arnd Bergmann <arnd@arndb.de>:
>> > On Tuesday 30 June 2009, Alan Cox wrote:
>> > Well, not even that. dma-mapping-common.h only makes sense on architectures
>> > that have multiple dma-mapping implementations (parisc, mips, arm, powerpc,
>>
>> It seems that there is only one dma-mmaping implementation on ARM, doesn't it?
>> Is it necessary that using dma-mapping-common.h on ARM?
>
> ARM has two (normal, and dma bounce), and in the long run we need to do

OK, Can we use dma-mapping-common.h on ARM?

> cache handling on unmap as well as map due to CPU speculative fetches.

IMHO, it seems we can fix this problem now.

For DMA_TO_DEVICE transfer, clean cache in dma map, but does nothing in
dma unmap;

For  DMA_FROM_DEVICE, we may do nothing in dma map, but invaliate cache
in dma unmap.

Is it doable?

Thanks.
-- 
Lei Ming
