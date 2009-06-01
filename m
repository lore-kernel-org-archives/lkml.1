Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbZFAKlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbZFAKlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbZFAKlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:41:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZFAKln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:41:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Date: Mon, 1 Jun 2009 11:41:32 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20090601082943.GA5550@flint.arm.linux.org.uk> <20090601183323V.fujita.tomonori@lab.ntt.co.jp> <20090601101405.GA19806@flint.arm.linux.org.uk>
In-Reply-To: <20090601101405.GA19806@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906011141.33463.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uYKy+2kpafIEGbgTE+ixJpOeY5H+TIfnD1x2
 fVOXSR/DvgA73cwAT0v6Pfvzsge7Y3ghQojhLMIlI1BASvEZ0W
 GJBVJvkwHYdrXMFaTyEFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009, Russell King wrote:

> So, on a non-DMA coherent cache architecture, when DMA is normally
> performed the data ends up in RAM with the cache flushed for that
> region.  If, instead dma_map_single uses a bounce buffer to do that
> DMA, then the same needs to be true of the original buffer - the
> data needs to be in RAM with the cache flushed.

While this seems logical from a correctness perspective, I would
like to understand why it actually matters. Flushing the cache on
the original buffer will impact performance but doesn't generally
make a difference to users. In cases where you need the cache
to be flushed for aliasing reasons (VIPT caches...), the architecture
specific code should flush that buffer somewhere, but do we really
need to flush it for all architectures?

	Arnd <><
