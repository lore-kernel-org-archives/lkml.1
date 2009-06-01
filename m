Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZFAQqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZFAQqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZFAQqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:46:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59599 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZFAQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:46:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 1 Jun 2009 17:45:58 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       lethal@linux-sh.org, chris@zankel.net,
       John Williams <john.williams@petalogix.com>
References: <200905282104.55818.arnd@arndb.de> <200906011111.28521.arnd@arndb.de> <4A23D2C7.6070400@petalogix.com>
In-Reply-To: <4A23D2C7.6070400@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906011745.59793.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+mYFbeRz08gr0tcDXeMSxOBKpV/0Xp0yZJN9S
 TNMT63Aj/SlZ8SG8QHHlMSR5ZxAXMMMGF5fHKQ6MpQhBmBKvzA
 rYbRLSLPCWsWfBAdUFzJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Michal Simek wrote:

> Microblaze have it but it is not cleared(checked) and not in mainline -
> I want to look at it when mmu is in mainline.
> As I wrote before  you can use Microblaze as tested arch.

Ok. It should become really easy once the asm-generic version is there.
Do you know if all DMA capable devices on microblaze are coherent
(or if all of them are noncoherent)?

If it is indeed coherent, the below code should be enough, otherwise
you need to add some cache flushes in the functions below.

	Arnd <><

---
#ifndef _ASM_MICROBLAZE_DMA_MAPPING_H
#define _ASM_MICROBLAZE_DMA_MAPPING_H

static inline int
__dma_coherent_dev(struct device *dev)
{
	return 1;
}

static inline void
dma_cache_sync(struct device *dev, void *cpu_addr, size_t size,
	       enum dma_data_direction direction)
{
}

static inline int dma_get_cache_alignment(void)
{
	return 1 << L1_CACHE_SHIFT;
}

#include <asm-generic/dma-mapping-linear.h>

#endif _ASM_MICROBLAZE_DMA_MAPPING_H
