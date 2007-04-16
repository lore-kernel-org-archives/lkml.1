Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXDPGZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXDPGZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXDPGZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:25:52 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:38707 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbXDPGZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:25:51 -0400
Date: Mon, 16 Apr 2007 02:23:54 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: modalias support for of_device
Message-ID: <20070416062354.GF23783@athena.road.mcmartin.ca>
References: <20070416041933.GE23783@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416041933.GE23783@athena.road.mcmartin.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 12:19:33AM -0400, Kyle McMartin wrote:
>

Updated patch to rename modalias_show to of_modalias_show, and
add the same code to arch/sparc. (Amusingly enough, just edited
sparc64 to sparc in the diff and it re-applied. :)

Cheers,
	Kyle

diff --git a/arch/sparc/kernel/of_device.c b/arch/sparc/kernel/of_device.c
index 48c24f7..fd4585e 100644
--- a/arch/sparc/kernel/of_device.c
+++ b/arch/sparc/kernel/of_device.c
@@ -148,6 +148,19 @@ struct of_device *of_find_device_by_node(struct device_node *dp)
 }
 EXPORT_SYMBOL(of_find_device_by_node);
 
+static ssize_t of_modalias_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	ssize_t len;
+	struct of_device *d = to_of_device(dev);
+	struct device_node *node = d->node;
+
+	len = sprintf(buf, "of:N%sT%sC%s\n",
+		      node->name, node->type, "*");
+
+	return len;
+}
+
 #ifdef CONFIG_PCI
 struct bus_type ebus_bus_type = {
        .name	= "ebus",
@@ -172,9 +185,15 @@ struct bus_type sbus_bus_type = {
 EXPORT_SYMBOL(sbus_bus_type);
 #endif
 
+static struct device_attribute of_dev_attrs[] = {
+	__ATTR(modalias, 0444, of_modalias_show, NULL),
+	__ATTR_NULL
+};
+
 struct bus_type of_bus_type = {
        .name	= "of",
        .match	= of_platform_bus_match,
+       .dev_attrs	= of_dev_attrs,
        .probe	= of_device_probe,
        .remove	= of_device_remove,
        .suspend	= of_device_suspend,
diff --git a/arch/sparc64/kernel/of_device.c b/arch/sparc64/kernel/of_device.c
index fb9bf1e..ab5c6dc 100644
--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -173,6 +173,19 @@ struct of_device *of_find_device_by_node(struct device_node *dp)
 }
 EXPORT_SYMBOL(of_find_device_by_node);
 
+static ssize_t of_modalias_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	ssize_t len;
+	struct of_device *d = to_of_device(dev);
+	struct device_node *node = d->node;
+
+	len = sprintf(buf, "of:N%sT%sC%s\n",
+		      node->name, node->type, "*");
+
+	return len;
+}
+
 #ifdef CONFIG_PCI
 struct bus_type isa_bus_type = {
        .name	= "isa",
@@ -207,9 +220,15 @@ struct bus_type sbus_bus_type = {
 EXPORT_SYMBOL(sbus_bus_type);
 #endif
 
+static struct device_attribute of_dev_attrs[] = {
+	__ATTR(modalias, 0444, of_modalias_show, NULL),
+	__ATTR_NULL
+};
+
 struct bus_type of_bus_type = {
        .name	= "of",
        .match	= of_platform_bus_match,
+       .dev_attrs	= of_dev_attrs,
        .probe	= of_device_probe,
        .remove	= of_device_remove,
        .suspend	= of_device_suspend,
