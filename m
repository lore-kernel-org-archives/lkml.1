Return-Path: <linux-kernel-owner+w=401wt.eu-S1030395AbXDKDkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395AbXDKDkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030384AbXDKDj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:39:57 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030772AbXDKDj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=ApkvMjc/sQvmKAfv1XVw3v3e0XrQaGC9O/WGHrieVToITa2YAwOHJEY+MHROJ2PJ7VksQroYCcBJ9m7hQNizx7V5gVBqtPS4IDQt8PxqHJpHfiAkcp2GcS7ReYgfw+nKHwpCAQSEA2V2xFAF8AnUzhId4ZvCFwjYGUTlqWhUVfY=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.89714.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 13/13] fs: deprecate memclear_highpage_flush
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the in-tree users are converted over to zero_user_page(),
deprecate the old memclear_highpage_flush() call.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/include/linux/highmem.h linux-2.6.21-rc6-mm1-test/include/linux/highmem.h
--- linux-2.6.21-rc6-mm1/include/linux/highmem.h	2007-04-10 18:32:41.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/include/linux/highmem.h	2007-04-10 19:40:14.000000000 -0700
@@ -149,6 +149,8 @@ static inline void zero_user_page(struct
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
+static void memclear_highpage_flush(struct page *page, unsigned int offset,
+					unsigned int size) __deprecated;
 static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
 {
 	return zero_user_page(page, offset, size);
