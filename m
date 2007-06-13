Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbXFME2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbXFME2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 00:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbXFME2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 00:28:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47654 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbXFME2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 00:28:08 -0400
Date: Wed, 13 Jun 2007 14:27:58 +1000
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: xfs-oss <xfs@oss.sgi.com>
Subject: [PATCH] Export radix_tree_preload()
Message-ID: <20070613042758.GJ86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Upcoming XFS functionality [1] uses radix trees and uses the preload
functions. XFS can be built as a module and hence we need 
radix_tree_preload() exported. radix_tree_preload_end() is a
static inline, so it doesn't need exporting.

[1] http://marc.info/?l=linux-xfs&m=118170839531601&w=2

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 lib/radix-tree.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/lib/radix-tree.c
===================================================================
--- 2.6.x-xfs-new.orig/lib/radix-tree.c	2007-03-29 19:00:53.802804161 +1000
+++ 2.6.x-xfs-new/lib/radix-tree.c	2007-03-29 19:07:10.297495640 +1000
@@ -151,6 +151,7 @@ int radix_tree_preload(gfp_t gfp_mask)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(radix_tree_preload);
 
 static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
 		int offset)
