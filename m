Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbZFBLL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbZFBLL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZFBLLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:11:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:65033 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZFBLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:11:18 -0400
Message-ID: <4A2508D5.2040809@petalogix.com>
Date: Tue, 02 Jun 2009 13:11:17 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       lethal@linux-sh.org, chris@zankel.net,
       John Williams <john.williams@petalogix.com>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
References: <200905282104.55818.arnd@arndb.de> <200906011111.28521.arnd@arndb.de> <4A23D2C7.6070400@petalogix.com> <200906011745.59793.arnd@arndb.de>
In-Reply-To: <200906011745.59793.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 01 June 2009, Michal Simek wrote:
>
>   
>> Microblaze have it but it is not cleared(checked) and not in mainline -
>> I want to look at it when mmu is in mainline.
>> As I wrote before  you can use Microblaze as tested arch.
>>     
>
> Ok. It should become really easy once the asm-generic version is there.
> Do you know if all DMA capable devices on microblaze are coherent
> (or if all of them are noncoherent)?
>   
We don't have cache coherency modul.

> If it is indeed coherent, the below code should be enough, otherwise
> you need to add some cache flushes in the functions below.
>   
I'll send you special email about to find out proper solution for
Microblaze.

Michal
> 	Arnd <><
>
> ---
> #ifndef _ASM_MICROBLAZE_DMA_MAPPING_H
> #define _ASM_MICROBLAZE_DMA_MAPPING_H
>
> static inline int
> __dma_coherent_dev(struct device *dev)
> {
> 	return 1;
> }
>
> static inline void
> dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
> 	       enum dma_data_direction direction)
> {
> }
>
> static inline int dma_get_cache_alignment(void)
> {
> 	return 1 << L1_CACHE_SHIFT;
> }
>
> #include <asm-generic/dma-mapping-linear.h>
>
> #endif _ASM_MICROBLAZE_DMA_MAPPING_H
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

