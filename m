Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZJBWm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZJBWm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbZJBWm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:42:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55359 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZJBWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:42:55 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19bLITFzRsOyb4rkOc6PUAK
Subject: [PATCH 5/8] omap: iovmm: Add missing mutex_unlock
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Daniel Walker <dwalker@fifo99.com>,
       linux-omap@vger.kernel.org
Date: Fri, 02 Oct 2009 15:42:50 -0700
Message-ID: <20091002224250.11962.58393.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@fifo99.com>

I was using Coccinelle with the mutex_unlock semantic patch, and it
unconvered this problem. It appears to be a valid missing unlock issue.
This change should correct it by moving the unlock below the label.

This patch is against the mainline kernel.

Cc: Julia Lawall <julia@diku.dk>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/iovmm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 0e5573d..dc3fac3 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -363,8 +363,9 @@ void *da_to_va(struct iommu *obj, u32 da)
 		goto out;
 	}
 	va = area->va;
-	mutex_unlock(&obj->mmap_lock);
 out:
+	mutex_unlock(&obj->mmap_lock);
+
 	return va;
 }
 EXPORT_SYMBOL_GPL(da_to_va);

