Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab0CKSGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:06:50 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43634 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759Ab0CKSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:06:33 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 27/37] drivers/of: use .dev.of_node instead of .node in struct
	of_device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:06:17 -0700
Message-ID: <20100311180616.4824.50413.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.node is being removed

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/of/device.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 224ae6b..24068bb 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -21,9 +21,9 @@
 const struct of_device_id *of_match_device(const struct of_device_id *matches,
 					const struct of_device *dev)
 {
-	if (!dev->node)
+	if (!dev->dev.of_node)
 		return NULL;
-	return of_match_node(matches, dev->node);
+	return of_match_node(matches, dev->dev.of_node);
 }
 EXPORT_SYMBOL(of_match_device);
 
@@ -54,7 +54,7 @@ static ssize_t devspec_show(struct device *dev,
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	return sprintf(buf, "%s\n", ofdev->node->full_name);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->full_name);
 }
 
 static ssize_t name_show(struct device *dev,
@@ -63,7 +63,7 @@ static ssize_t name_show(struct device *dev,
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	return sprintf(buf, "%s\n", ofdev->node->name);
+	return sprintf(buf, "%s\n", ofdev->dev.of_node->name);
 }
 
 static ssize_t modalias_show(struct device *dev,
@@ -97,14 +97,14 @@ void of_release_dev(struct device *dev)
 	struct of_device *ofdev;
 
 	ofdev = to_of_device(dev);
-	of_node_put(ofdev->node);
+	of_node_put(ofdev->dev.of_node);
 	kfree(ofdev);
 }
 EXPORT_SYMBOL(of_release_dev);
 
 int of_device_register(struct of_device *ofdev)
 {
-	BUG_ON(ofdev->node == NULL);
+	BUG_ON(ofdev->dev.of_node == NULL);
 
 	device_initialize(&ofdev->dev);
 
@@ -112,7 +112,7 @@ int of_device_register(struct of_device *ofdev)
 	 * the parent. If there is no parent defined, set the node
 	 * explicitly */
 	if (!ofdev->dev.parent)
-		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->node));
+		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
 
 	return device_add(&ofdev->dev);
 }
@@ -132,11 +132,11 @@ ssize_t of_device_get_modalias(struct of_device *ofdev,
 	ssize_t tsize, csize, repend;
 
 	/* Name & Type */
-	csize = snprintf(str, len, "of:N%sT%s",
-				ofdev->node->name, ofdev->node->type);
+	csize = snprintf(str, len, "of:N%sT%s", ofdev->dev.of_node->name,
+			 ofdev->dev.of_node->type);
 
 	/* Get compatible property if any */
-	compat = of_get_property(ofdev->node, "compatible", &cplen);
+	compat = of_get_property(ofdev->dev.of_node, "compatible", &cplen);
 	if (!compat)
 		return csize;
 

