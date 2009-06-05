Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZFEINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZFEINk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZFEIGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37482 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbZFEIFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 22/62] Blackfin: document anomaly 05000234 workaround
Date: Fri,  5 Jun 2009 04:04:31 -0400
Message-Id: <1244189111-19639-23-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Note the reason for using CHIPD over DSPID.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/processor.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/include/asm/processor.h b/arch/blackfin/include/asm/processor.h
index 0eece23..3040415 100644
--- a/arch/blackfin/include/asm/processor.h
+++ b/arch/blackfin/include/asm/processor.h
@@ -131,8 +131,8 @@ unsigned long get_wchan(struct task_struct *p);
 /* Get the Silicon Revision of the chip */
 static inline uint32_t __pure bfin_revid(void)
 {
-	/* stored in the upper 4 bits */
-	uint32_t revid = bfin_read_CHIPID() >> 28;
+	/* Always use CHIPID, to work around ANOMALY_05000234 */
+	uint32_t revid = (bfin_read_CHIPID() & CHIPID_VERSION) >> 28;
 
 #ifdef CONFIG_BF52x
 	/* ANOMALY_05000357
-- 
1.6.3.1

