Return-Path: <linux-kernel-owner+w=401wt.eu-S966648AbZLHWHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966648AbZLHWHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966598AbZLHWG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:06:57 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:47036 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966517AbZLHWG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:06:57 -0500
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Dec 2009 17:06:56 EST
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-mm@kvack.org
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, linux-kernel@vger.kernel.org,
       sage@newdream.net
Subject: [PATCH] mm/page-writeback: export account_page_dirtied()
Date: Tue,  8 Dec 2009 13:41:59 -0800
Message-Id: <1260308519-16899-1-git-send-email-yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ceph filesystem implementation of set_page_dirty is based on
__set_page_dirty_nobuffers(), and needs to use account_page_dirtied(). It
uses its own implementation as it needs to set the page private bit and
value under the tree lock. This exports it using EXPORT_SYMBOL_GPL.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 mm/page-writeback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a3b1409..4f8412a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1095,6 +1095,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 		task_io_account_write(PAGE_CACHE_SIZE);
 	}
 }
+EXPORT_SYMBOL_GPL(account_page_dirtied);
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
-- 
1.5.6.5

