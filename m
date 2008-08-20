Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYHTKS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYHTKS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYHTKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:18:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYHTKSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:18:47 -0400
Date: Wed, 20 Aug 2008 12:18:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: [PATCH] dma-coherent: export dma_[alloc|release]_from_coherent
	methods
Message-ID: <20080820101811.GA31841@elte.hu>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com> <20080820094612.GA28492@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820094612.GA28492@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From ed0a6445788eed1fa836442730d8fe8ab1086629 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 20 Aug 2008 12:16:09 +0200
Subject: [PATCH] dma-coherent: export dma_[alloc|release]_from_coherent methods

fixes modular builds:

  ERROR: "dma_alloc_from_coherent" [sound/core/snd-page-alloc.ko] undefined!
  ERROR: "dma_release_from_coherent" [sound/core/snd-page-alloc.ko] undefined!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/dma-coherent.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index c1d4d5b..f013a0c 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -124,6 +124,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	}
 	return (mem != NULL);
 }
+EXPORT_SYMBOL(dma_alloc_from_coherent);
 
 /**
  * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
@@ -151,3 +152,4 @@ int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dma_release_from_coherent);
