Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYJ1RqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYJ1RqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJ1RqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:14 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57665 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753016AbYJ1RqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:13 -0400
Date: Tue, 28 Oct 2008 20:46:11 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 1/6] of/base: Add new helper of_should_create_pdev()
Message-ID: <20081028174611.GA25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used to check list of devices for which we should create
a dedicated device.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/base.c  |   27 +++++++++++++++++++++++++++
 include/linux/of.h |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7c79e94..1baeee3 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -458,6 +458,33 @@ int of_modalias_node(struct device_node *node, char *modalias, int len)
 }
 EXPORT_SYMBOL_GPL(of_modalias_node);
 
+/*
+ * The list of device's compatible entries for which drivers require
+ * platform_data to be filled. For such cases we create OF platform
+ * devices.
+ */
+static const char *of_pdev_list[] = {
+};
+
+/**
+ * of_should_create_pdev - See if a node needs a full-fledged OF device
+ * @node:	pointer to a device tree node
+ *
+ * Based on the value of the compatible property, this routine will determine
+ * if a full-fledged device should be created for a node.
+ */
+bool of_should_create_pdev(struct device_node *node)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(of_pdev_list); i++) {
+		if (!of_device_is_compatible(node, of_pdev_list[i]))
+			return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_should_create_pdev);
+
 /**
  * of_parse_phandles_with_args - Find a node pointed by phandle in a list
  * @np:		pointer to a device tree node containing a list
diff --git a/include/linux/of.h b/include/linux/of.h
index e2488f5..d183533 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -71,6 +71,7 @@ extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
 	const struct of_device_id *matches, const struct device_node *node);
 extern int of_modalias_node(struct device_node *node, char *modalias, int len);
+extern bool of_should_create_pdev(struct device_node *node);
 extern int of_parse_phandles_with_args(struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct device_node **out_node, const void **out_args);
-- 
1.5.6.3

