Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXDKDlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXDKDlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXDKDi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:38:29 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbXDKDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=F9HhMsbB444NjpHviZa9IbPgxpnA97hAir9CC97b8e+jRLHB4iBpUZRr6f+sDq7XylYD7+tgoCSLHDTAfDVI2X+XK/GgYS+mBmKOCCiDOlJpGNaWjjf5MFiruA9IH9f5XyrrIdBc2uk8dfcgHoZ5hFceCt9YGTbDWMBicRN0Qag=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.45155.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 2/13] affs: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/affs/file.c linux-2.6.21-rc6-mm1-test/fs/affs/file.c
--- linux-2.6.21-rc6-mm1/fs/affs/file.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/affs/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -628,11 +628,7 @@ static int affs_prepare_write_ofs(struct
 			return err;
 	}
 	if (to < PAGE_CACHE_SIZE) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-
-		memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, to, PAGE_CACHE_SIZE - to);
 		if (size > offset + to) {
 			if (size < offset + PAGE_CACHE_SIZE)
 				tmp = size & ~PAGE_CACHE_MASK;
