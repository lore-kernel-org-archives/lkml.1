Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZFHIEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZFHIEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZFHIEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:04:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZFHIED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:04:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 8 Jun 2009 10:03:58 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200906041235.34686.arnd@arndb.de> <200906041747.04310.arnd@arndb.de> <20090608144921R.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090608144921R.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906081003.59171.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18mpo+uSI3d2PxJN/SYP0qWpWbJh1O50dn5n/P
 o4dK+V5NG9B39wYr01FGCXCi2HJ1t2ZrGPzDA6z7sGvSU+Mvut
 vawTt8+RKGRTPAGnei6OA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, FUJITA Tomonori wrote:
> 
> > However, I don't think I have the energy to fix this problem, but
> > I agree that it should be fixed eventually. I can leave out
> > the declarations of dma_{free,alloc}_coherent from dma-mapping-linear.h
> > so that the broken code remains in the architecture specific
> > files, and change all references to dma_cache_sync to something
> > else. The best I can think of is __dma_cache_sync() with the same
> > calling conventions as dma_cache_sync(). Does that make sense?
> 
> Sorry, but it doesn't make sense to me because __dma_cache_sync() hack
> is against the goal of dma-mapping-linear.h, having a clean, ideal,
> unified header file.

Do you have any other suggestion? The operation that an architecture
performs to synchronize the DMA buffer after a DMA is just not generic
and needs to have some name that we can call from the generic file.
Right now we use one of dma_cache_sync, frv_cache_wback_inv,
mn10300_dcache_flush_inv or consistent_sync for this and I was just
looking for a new internal name for this operation.

	Arnd <><
