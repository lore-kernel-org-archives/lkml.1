Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYCTQAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYCTQAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYCTP77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 11:59:59 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58396 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYCTP76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 11:59:58 -0400
X-Greylist: delayed 1788 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2008 11:59:57 EDT
Message-ID: <47E282F5.6090703@mev.co.uk>
Date: Thu, 20 Mar 2008 15:29:57 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Subject: [PATCH] Corrections to Documentation/rbtree.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2008 15:29:57.0823 (UTC) FILETIME=[41311CF0:01C88A9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

The description of the rb_entry() macro in Documentation/rbtree.txt seems incorrect.
This patch improves it (hopefully).  Also I changed the example code to call the
previous 'my_search()' example instead of an undefined 'mysearch()'.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
--- linux-2.6.24/Documentation/rbtree.txt.orig	2008-01-24 22:58:37.000000000 +0000
+++ linux-2.6.24/Documentation/rbtree.txt	2008-03-20 15:14:55.000000000 +0000
@@ -64,8 +64,8 @@
   };
 
 When dealing with a pointer to the embedded struct rb_node, the containing data
-structure may be accessed with the standard container_of() macro.  In addition,
-individual members may be accessed directly via rb_entry(node, type, member).
+structure may be accessed with the rb_entry() macro, which is a synonym for the
+standard container_of() macro.
 
 At the root of each rbtree is an rb_root structure, which is initialized to be
 empty via:
@@ -85,7 +85,7 @@
   	struct rb_node *node = root->rb_node;
 
   	while (node) {
-  		struct mytype *data = container_of(node, struct mytype, node);
+  		struct mytype *data = rb_entry(node, struct mytype, node);
 		int result;
 
 		result = strcmp(string, data->keystring);
@@ -118,7 +118,7 @@
 
   	/* Figure out where to put new node */
   	while (*new) {
-  		struct mytype *this = container_of(*new, struct mytype, node);
+  		struct mytype *this = rb_entry(*new, struct mytype, node);
   		int result = strcmp(data->keystring, this->keystring);
 
 		parent = *new;
@@ -146,7 +146,7 @@
 
 Example:
 
-  struct mytype *data = mysearch(mytree, "walrus");
+  struct mytype *data = my_search(mytree, "walrus");
 
   if (data) {
   	rb_erase(data->node, mytree);
@@ -180,13 +180,11 @@
 NULL when there are no more nodes left.
 
 The iterator functions return a pointer to the embedded struct rb_node, from
-which the containing data structure may be accessed with the container_of()
-macro, and individual members may be accessed directly via
-rb_entry(node, type, member).
+which the containing data structure may be accessed with the rb_entry() macro.
 
 Example:
 
   struct rb_node *node;
   for (node = rb_first(&mytree); node; node = rb_next(node))
-  	printk("key=%s\n", rb_entry(node, int, keystring));
+  	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
 


