Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbYG3NKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbYG3NKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbYG3NJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:09:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57677 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbYG3NJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:09:18 -0400
Message-Id: <20080730130914.500576799@szeredi.hu>
References: <20080730130845.905327725@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 30 Jul 2008 15:08:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 2/4] vfs: filp is never NULL in do_generic_file_read()
Content-Disposition: inline; filename=do_generic_file_read_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

...so remove bogus "if (filp)".

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/filemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-07-30 13:52:36.000000000 +0200
+++ linux-2.6/mm/filemap.c	2008-07-30 13:52:39.000000000 +0200
@@ -1186,8 +1186,7 @@ out:
 	ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
-	if (filp)
-		file_accessed(filp);
+	file_accessed(filp);
 }
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,

--
