Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZD1PZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZD1PZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbZD1PWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:22:01 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:39105 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932358AbZD1PV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:21:58 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KITGMW-01-UB5-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 20/21] amd64_edac: add DRAM error injection logic using sysfs
Date: Tue, 28 Apr 2009 17:06:12 +0200
Message-ID: <1240931173-17477-21-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Apr 2009 15:06:24.0974 (UTC) FILETIME=[E5F476E0:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  130 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3c04fd6..1f62346 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4654,3 +4654,133 @@ static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
 
 #endif	/* DEBUG */
 
+/*
+ * Per MC instance Attribute/Control data control structure
+ *	Can add for debug or for normal use
+ */
+static struct mcidev_sysfs_attribute amd64_mc_sysfs_ctls_attrs[] = {
+
+#ifdef CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION
+	/* Error injection methods */
+	{
+		.attr = {
+			.name = "z_inject_section",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_section_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_word",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_word_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_bit_map",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_bit_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_write",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_write_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_read",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_read_store,
+	},
+#endif	/* CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION */
+
+#ifdef	CONFIG_EDAC_DEBUG
+	/* RAW register accessors */
+	{
+		.attr = {
+			.name = "zctl_nbea",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = amd64_nbea_show,
+		.store = amd64_nbea_store,
+	},
+	{
+		.attr = {
+			.name = "zctl_nbsl",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = amd64_nbsl_show,
+		.store = amd64_nbsl_store,
+	},
+	{
+		.attr = {
+			.name = "zctl_nbsh",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = amd64_nbsh_show,
+		.store = amd64_nbsh_store,
+	},
+	{
+		.attr = {
+			.name = "zctl_nbcfg",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = amd64_nbcfg_show,
+		.store = amd64_nbcfg_store,
+	},
+	{
+		.attr = {
+			.name = "zhw_dhar",
+			.mode = (S_IRUGO)
+		},
+		.show = amd64_dhar_show,
+		.store = NULL,
+	},
+	{
+		.attr = {
+			.name = "zhw_dbam",
+			.mode = (S_IRUGO)
+		},
+		.show = amd64_dbam_show,
+		.store = NULL,
+	},
+	{
+		.attr = {
+			.name = "zhw_topmem",
+			.mode = (S_IRUGO)
+		},
+		.show = amd64_topmem_show,
+		.store = NULL,
+	},
+	{
+		.attr = {
+			.name = "zhw_topmem2",
+			.mode = (S_IRUGO)
+		},
+		.show = amd64_topmem2_show,
+		.store = NULL,
+	},
+	{
+		.attr = {
+			.name = "zhw_hole",
+			.mode = (S_IRUGO)
+		},
+		.show = amd64_hole_show,
+		.store = NULL,
+	},
+#endif
+	{
+		.attr = { .name = NULL}
+	}
+};
+
-- 
1.6.2.4


