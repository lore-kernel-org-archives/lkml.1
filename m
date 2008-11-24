Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYKXUFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYKXUFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYKXUFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:05:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:12695 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYKXUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:05:33 -0500
Message-ID: <154e089b0811241205m293b5824of0fa753c1f8c33a6@mail.gmail.com>
Date: Mon, 24 Nov 2008 21:05:31 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] hugetlb: fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warnings

Fix the following sparse warnings:

  mm/hugetlb.c:375:3: warning: returning void-valued expression
  mm/hugetlb.c:408:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 mm/hugetlb.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6058b53..56e1406 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -371,8 +371,10 @@ static void clear_huge_page(struct page *page,
 {
 	int i;

-	if (unlikely(sz > MAX_ORDER_NR_PAGES))
-		return clear_gigantic_page(page, addr, sz);
+	if (unlikely(sz > MAX_ORDER_NR_PAGES)) {
+		clear_gigantic_page(page, addr, sz);
+		return;
+	}

 	might_sleep();
 	for (i = 0; i < sz/PAGE_SIZE; i++) {
@@ -404,8 +406,10 @@ static void copy_huge_page(struct page *dst,
struct page *src,
 	int i;
 	struct hstate *h = hstate_vma(vma);

-	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES))
-		return copy_gigantic_page(dst, src, addr, vma);
+	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
+		copy_gigantic_page(dst, src, addr, vma);
+		return;
+	}

 	might_sleep();
 	for (i = 0; i < pages_per_huge_page(h); i++) {
