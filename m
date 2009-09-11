Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZIKStt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZIKStt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZIKStq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:49:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54043 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZIKSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:44 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [18/21] HWPOISON: Enable error_remove_page for NFS
Message-Id: <20090911184847.3E51EB1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Enable hardware memory error handling for NFS

Truncation of data pages at runtime should be safe in NFS,
even when it doesn't support migration so far.

Trond tells me migration is also queued up for 2.6.32.

Acked-by: Trond.Myklebust@netapp.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/file.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/fs/nfs/file.c
===================================================================
--- linux.orig/fs/nfs/file.c
+++ linux/fs/nfs/file.c
@@ -480,6 +480,7 @@ const struct address_space_operations nf
 	.releasepage = nfs_release_page,
 	.direct_IO = nfs_direct_IO,
 	.launder_page = nfs_launder_page,
+	.error_remove_page = generic_error_remove_page,
 };
 
 /*
