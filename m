Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZFEISB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZFEISB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbZFEIGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37492 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZFEIFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 34/62] Blackfin: make sure MPU CPLB for first 1k is marked as valid
Date: Fri,  5 Jun 2009 04:04:43 -0400
Message-Id: <1244189111-19639-35-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

This way we properly catch and kill applications that jump to a NULL ptr.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-mpu/cplbinit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
index 3e329a6..c006a44 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
@@ -64,7 +64,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
 	dcplb_tbl[cpu][i_d++].data = SDRAM_OOPS | PAGE_SIZE_1KB;
 
 	icplb_tbl[cpu][i_i].addr = 0;
-	icplb_tbl[cpu][i_i++].data = i_cache | CPLB_USER_RD | PAGE_SIZE_1KB;
+	icplb_tbl[cpu][i_i++].data = CPLB_VALID | i_cache | CPLB_USER_RD | PAGE_SIZE_1KB;
 
 	/* Cover kernel memory with 4M pages.  */
 	addr = 0;
-- 
1.6.3.1

