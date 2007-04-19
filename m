Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXDSOeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXDSOeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXDSOeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:34:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55515 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXDSOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:34:13 -0400
Date: Thu, 19 Apr 2007 17:34:11 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: only fput unused files
Message-ID: <Pine.LNX.4.64.0704191733290.25796@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

We should do fput only to files that were not used by the revoke
operation.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-04-19 17:27:11.000000000 +0300
+++ uml-2.6/fs/revoke.c	2007-04-19 17:27:40.000000000 +0300
@@ -130,7 +130,6 @@ 	for (fd = 0; fd < fdt->max_fds; fd++) {
 		}
 
 		new_filp = revoke_table_get(table);
-		get_file(new_filp);
 
 		/*
 		 * Replace original struct file pointer with a pointer to
@@ -487,7 +486,7 @@ static void free_revoke_table(struct rev
 {
 	int i;
 
-	for (i = 0; i < table->size; i++)
+	for (i = table->end; i < table->size; i++)
 		fput(table->files[i]);
 
 	kfree(table->files);
