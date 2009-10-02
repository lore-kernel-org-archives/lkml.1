Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZJBWkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZJBWkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZJBWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:40:15 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63473 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZJBWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:40:13 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rQAuqAeb7znLnztmieS+J
Subject: [PATCH 3/8] omap: SRAM: flush the right address after memcpy in
	omap_sram_push
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, janboe <janboe.ye@gmail.com>
Date: Fri, 02 Oct 2009 15:40:16 -0700
Message-ID: <20091002224016.11962.18728.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ye janboe <janboe.ye@gmail.com>

the original flush operation is to flush the function address which is
copied from.
But we do not change the function code and it is not necessary to flush it.

Signed-off-by: janboe <janboe.ye@gmail.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/plat-omap/sram.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
index 925f647..75d1f26 100644
--- a/arch/arm/plat-omap/sram.c
+++ b/arch/arm/plat-omap/sram.c
@@ -270,7 +270,8 @@ void * omap_sram_push(void * start, unsigned long size)
 	omap_sram_ceil -= size;
 	omap_sram_ceil = ROUND_DOWN(omap_sram_ceil, sizeof(void *));
 	memcpy((void *)omap_sram_ceil, start, size);
-	flush_icache_range((unsigned long)start, (unsigned long)(start + size));
+	flush_icache_range((unsigned long)omap_sram_ceil,
+		(unsigned long)(omap_sram_ceil + size));
 
 	return (void *)omap_sram_ceil;
 }

