Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXJXQgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXJXQgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbXJXQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:26 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60925 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759549AbXJXQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:24 -0400
Date: Wed, 24 Oct 2007 18:24:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/base/node.c: cleanups
Message-ID: <20071024162453.GQ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly globalcode static:
  - register_node()
  - node_state_attr[]
- #if 0 the following unused global functions:
  - unregister_node()
  - unregister_one_node()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/base/node.c  |    8 ++++++--
 include/linux/node.h |    7 -------
 2 files changed, 6 insertions(+), 9 deletions(-)

7db18803736afa998b26608e4a5da190d784c83f 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 88eeed7..a2448eb 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -139,7 +139,7 @@ static SYSDEV_ATTR(distance, S_IRUGO, node_read_distance, NULL);
  *
  * Initialize and register the node device.
  */
-int register_node(struct node *node, int num, struct node *parent)
+static int register_node(struct node *node, int num, struct node *parent)
 {
 	int error;
 
@@ -156,6 +156,7 @@ int register_node(struct node *node, int num, struct node *parent)
 	return error;
 }
 
+#if 0
 /**
  * unregister_node - unregister a node device
  * @node: node going away
@@ -172,6 +173,7 @@ void unregister_node(struct node *node)
 
 	sysdev_unregister(&node->sysdev);
 }
+#endif  /*  0  */
 
 struct node node_devices[MAX_NUMNODES];
 
@@ -228,10 +230,12 @@ int register_one_node(int nid)
 
 }
 
+#if 0
 void unregister_one_node(int nid)
 {
 	unregister_node(&node_devices[nid]);
 }
+#endif  /*  0  */
 
 /*
  * node states attributes
@@ -287,7 +291,7 @@ static SYSDEV_CLASS_ATTR(has_high_memory, 0444, print_nodes_has_high_memory,
 									 NULL);
 #endif
 
-struct sysdev_class_attribute *node_state_attr[] = {
+static struct sysdev_class_attribute *node_state_attr[] = {
 	&attr_possible,
 	&attr_online,
 	&attr_has_normal_memory,
diff --git a/include/linux/node.h b/include/linux/node.h
index bc001bc..db6c064 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -28,11 +28,8 @@ struct node {
 
 extern struct node node_devices[];
 
-extern int register_node(struct node *, int, struct node *);
-extern void unregister_node(struct node *node);
 #ifdef CONFIG_NUMA
 extern int register_one_node(int nid);
-extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 #else
@@ -40,10 +37,6 @@ static inline int register_one_node(int nid)
 {
 	return 0;
 }
-static inline int unregister_one_node(int nid)
-{
-	return 0;
-}
 static inline int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
 	return 0;

