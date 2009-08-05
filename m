Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbZHEJhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbZHEJhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933973AbZHEJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:37:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934008AbZHEJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:36:45 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051136.682859934@firstfloor.org>
In-Reply-To: <200908051136.682859934@firstfloor.org>
To: Trond.Myklebust@netapp.com, akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, hidehiro.kawai.ez@hitachi.com
Subject: [PATCH] [17/19] HWPOISON: Enable error_remove_page for NFS
Message-Id: <20090805093644.E3607B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 11:36:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Enable hardware memory error handling for NFS

Truncation of data pages at runtime should be safe in NFS,
even when it doesn't support migration so far.

Cc: Trond.Myklebust@netapp.com

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
