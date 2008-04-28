Return-Path: <linux-kernel-owner+w=401wt.eu-S937861AbYD1VOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937861AbYD1VOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935890AbYD1VNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:13:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:20776 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811AbYD1VNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uM0rP4CoV8U61RpI/n/Ee586dEeowIYNrBDBuWsCzKFU0iFFVfPqQckkYAof40jZ89z7lXbteRUDZwkSxgGYTE5PI1eUJvTzPw+iHdbeBRyBWVfvYVf8SMwjxTCrf7YanY35gqjNlePHF5Vpm6vNqX7yqiWxNAWKqjtcA4hIZFc=
Subject: [PATCH 3/4] mm: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:13:19 -0700
Message-Id: <1209417199.14173.102.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/hugetlb.c:207:11: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index df28c17..2c37c67 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -204,7 +204,7 @@ static struct page *alloc_fresh_huge_page_node(int nid)
 	if (page) {
 		if (arch_prepare_hugepage(page)) {
 			__free_pages(page, HUGETLB_PAGE_ORDER);
-			return 0;
+			return NULL;
 		}
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
-- 
1.5.5.1.270.g89765


