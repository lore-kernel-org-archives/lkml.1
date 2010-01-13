Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579Ab0AMOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0AMOww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400Ab0AMOwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:52:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:38754 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0AMOwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gtkr+XCN2Dyh6e1pEMwvnUvZkkjNKlOiByy3J9dNrdGtd2L6pg+dMYqVRtyOvqPtU5
         8gjmYtD1404yD7eE91GH03ufpHBe0oqsOSqyQ5o3lZuNq98vEdynfQuavztJO7J78wnU
         TEuCimzUzQble1G+bj6Z9AAytyHhM9J2eU6ws=
MIME-Version: 1.0
Date: Wed, 13 Jan 2010 22:52:48 +0800
Message-ID: <3a3680031001130652g58c70471sfb2b46743816de84@mail.gmail.com>
Subject: [PATCH 2/3] mm: page_alloc.c Adjust a call site to 
	trace_mm_page_free_direct
From: Li Hong <lihong.hi@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a call of 'trace_mm_page_free_direct' from 'free_hot_page' to
'free_hot_cold_page'. It is clearer and close to 'kmemcheck_free_shadow', as it
is done in function '__free_pages_ok'.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 24344cd..175dd36 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1082,6 +1082,7 @@ static void free_hot_cold_page(struct page
*page, int cold)
        int migratetype;
        int wasMlocked = __TestClearPageMlocked(page);

+       trace_mm_page_free_direct(page, 0);
        kmemcheck_free_shadow(page, 0);

        if (PageAnon(page))
@@ -1136,7 +1137,6 @@ out:

 void free_hot_page(struct page *page)
 {
-       trace_mm_page_free_direct(page, 0);
        free_hot_cold_page(page, 0);
 }

-- 
1.6.3.3
