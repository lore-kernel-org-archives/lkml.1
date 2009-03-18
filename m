Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZCRUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZCRUb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZCRUbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:40 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56198 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751472AbZCRUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:39 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 05/57] microblaze_v7: Platorm bus registration
Date: Wed, 18 Mar 2009 21:30:32 +0100
Message-Id: <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/platform/platform.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/platform/platform.c

diff --git a/arch/microblaze/platform/platform.c b/arch/microblaze/platform/platform.c
new file mode 100644
index 0000000..56e0234
--- /dev/null
+++ b/arch/microblaze/platform/platform.c
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2008 Michal Simek <monstr@monstr.eu>
+ *
+ * based on virtex.c file
+ *
+ * Copyright 2007 Secret Lab Technologies Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/of_platform.h>
+#include <asm/prom.h>
+
+static struct of_device_id xilinx_of_bus_ids[] __initdata = {
+	{ .compatible = "simple-bus", },
+	{ .compatible = "xlnx,plb-v46-1.00.a", },
+	{ .compatible = "xlnx,opb-v20-1.10.c", },
+	{ .compatible = "xlnx,opb-v20-1.10.b", },
+	{ .compatible = "xlnx,compound", },
+	{}
+};
+
+static int __init microblaze_device_probe(void)
+{
+	of_platform_bus_probe(NULL, xilinx_of_bus_ids, NULL);
+	return 0;
+}
+device_initcall(microblaze_device_probe);
-- 
1.5.5.1

