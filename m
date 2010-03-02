Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0CBNik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:38:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0CBNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:38:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
Date: Tue, 2 Mar 2010 14:38:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <201003011229.51399.arnd@arndb.de> <201003021303.26064.arnd@arndb.de> <20100302212513N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100302212513N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003021438.32144.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18kIF0ZEO+OLn0i4SscGXFQU58B4O+bTx7R0Fb
 PedTc4SLHRjiHopi5iC56Jr/cx0dYPfS212qL9x349lcKA0bz/
 mmpwgy1gnTBam5ocPUBMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010, FUJITA Tomonori wrote:
> Yeah, but IIRC, Alpha, x86_64 GART, parisc, and IA64 don't have
> CONFIG_ option for IOMMU virtual merging. I prefer to avoid to adding
> something like CONFIG_HAVE_IOMMU_VMERGE for them. If we add
> CONFIG_HAVE_IOMMU_VMERGE to them, it's a bit strange not to add the
> feature to disable virtual merging for them (I guess GART already has
> the feature though).

While I think the runtime feature (actually a workaround for broken device
drivers) should be consistently used on all architectures, or removed
entirely, it's orthogonal to this discussion. I'm sure you'll come
up with a reasonable name for a new option if you introduce one.
CONFIG_HAVE_IOMMU_VMERGE and CONFIG_NEED_SG_DMA_LENGTH both seem ok
to me.

> Actually, I want to use dma_length on all the architectures (if nobody
> complains).

Fine with me as well. It wastes a small amount of memory but makes
the code more consistent.

	Arnd
