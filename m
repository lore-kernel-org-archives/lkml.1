Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZFDMpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZFDMpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbZFDMpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:45:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48145 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZFDMpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:45:35 -0400
Date: Thu, 4 Jun 2009 13:45:17 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       lethal@linux-sh.org, chris@zankel.net
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Message-ID: <20090604124516.GA24491@flint.arm.linux.org.uk>
Mail-Followup-To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, lethal@linux-sh.org, chris@zankel.net
References: <200905282104.55818.arnd@arndb.de> <20090601130319A.fujita.tomonori@lab.ntt.co.jp> <200906011111.28521.arnd@arndb.de> <20090604165703N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604165703N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:57:12PM +0900, FUJITA Tomonori wrote:
> ? Why we don't need to remove stale cache after DMA_FROM_DEVICE
> transfer?

Think about a CPU which does speculative prefetches into the cache (which
later ARMs do).

The result is that, for a DMA_FROM_DEVICE transfer, you need to:

1. ensure that no cache writebacks occur to the region while DMA is
   being performed
2. ensure that any data which is present in the cache for the region
   is invalidated once DMA has completed

If you don't have speculative prefetches, then (1) and (2) can be (and
are at present) combined into the initial mapping setup or whenever the
buffer is handed from the CPUs ownership to the DMA device's ownership.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
