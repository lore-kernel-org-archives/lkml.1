Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZFEIRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZFEIRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZFEIGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37532 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538AbZFEIFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 33/62] Blackfin: add workaround for anomaly 05000287
Date: Fri,  5 Jun 2009 04:04:42 -0400
Message-Id: <1244189111-19639-34-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-nompu/cacheinit.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-nompu/cacheinit.c b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
index c6ff947..d5a86c3 100644
--- a/arch/blackfin/kernel/cplb-nompu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
@@ -55,7 +55,14 @@ void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 	}
 
 	ctrl = bfin_read_DMEM_CONTROL();
-	ctrl |= DMEM_CNTR;
+
+	/*
+	 *  Anomaly notes:
+	 *  05000287 - We implement workaround #2 - Change the DMEM_CONTROL
+	 *  register, so that the port preferences for DAG0 and DAG1 are set
+	 *  to port B
+	 */
+	ctrl |= DMEM_CNTR | PORT_PREF0 | (ANOMALY_05000287 ? PORT_PREF1 : 0);
 	bfin_write_DMEM_CONTROL(ctrl);
 	SSYNC();
 }
-- 
1.6.3.1

