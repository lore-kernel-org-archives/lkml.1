Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYBSOb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYBSOb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYBSObV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:31:21 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:35846 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbYBSObV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:31:21 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib: Handle failed malloc.
Date: Tue, 19 Feb 2008 15:31:19 +0100
Message-ID: <87hcg5nhl4.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* lib/inflate.c (inflate_dynamic): Don't deref NULL upon failed malloc.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
diff --git a/lib/inflate.c b/lib/inflate.c
index 845f91d..9762294 100644
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -811,6 +811,9 @@ DEBG("<dyn");
   ll = malloc(sizeof(*ll) * (286+30));  /* literal/length and distance code lengths */
 #endif

+  if (ll == NULL)
+    return 1;
+
   /* make local bit buffer */
   b = bb;
   k = bk;
--
1.5.4.19.gd3dfd
