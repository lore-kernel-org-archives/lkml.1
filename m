Return-Path: <linux-kernel-owner+w=401wt.eu-S1763015AbYDOJWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763015AbYDOJWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYDOJWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:22:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42069 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYDOJWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:22:38 -0400
Date: Tue, 15 Apr 2008 11:23:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: mm/page_alloc.c: remove hand-coded get_order()
Message-ID: <20080415092317.GA1529@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__get_free_pages() is strange interface:

It has underscores, yet get_free_pages() does not exists.

It returns long when most people need pointer.

(And it takes order, when many people want to pass size).

What about creating void *get_free_pages(flags, order) version, then
slowly converting users to it?
									Pavel

---

Remove hand-coded get_order() from page_alloc.c.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 402a504..c48aa45 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4339,9 +4339,7 @@ void *__init alloc_large_system_hash(con
 		else if (hashdist)
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
-			unsigned long order;
-			for (order = 0; ((1UL << order) << PAGE_SHIFT) < size; order++)
-				;
+			unsigned long order = get_order(size);
 			table = (void*) __get_free_pages(GFP_ATOMIC, order);
 			/*
 			 * If bucketsize is not a power-of-two, we may free


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
