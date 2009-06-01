Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZFAKsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZFAKsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbZFAKsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:48:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60536 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbZFAKsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:48:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 1 Jun 2009 11:48:34 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <200906011128.10670.arnd@arndb.de> <20090601104353.GA25391@flint.arm.linux.org.uk>
In-Reply-To: <20090601104353.GA25391@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906011148.35592.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19xBEQcCFpGxDN2tnvh/ma2h8/E+N7f35dQIAm
 6IeLW+AIgbfVxnoOT3R12AgzBb/DJQmMWDHtflt5AhiCNyYrje
 LWaiAbwvnviOezHA9aGVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Russell King wrote:
> 
> Err - there's only one highmem implementation on ARM.

Sorry for not being clear enough, I meant three implementations of
page_to_dma(), depending on highmem and platform:

	return (dma_addr_t)__virt_to_bus((unsigned long)page_address(page));
	return (dma_addr_t)__pfn_to_bus(page_to_pfn(page));
	return __arch_page_to_dma(dev, page);

The generic code right now does the first, which won't work with highmem
and also won't handle platform specific requirements that are not present
on the other architectures.

	Arnd <><
