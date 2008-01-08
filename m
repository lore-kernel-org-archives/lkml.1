Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYAHCnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYAHCnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYAHCnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:43:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:24245 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYAHCnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rxjO3sFjxi/H+MWpKODwmzqZcxnJ6nw95jOpvMf2sWQ2Vn/O48qx1QavmPLAV1CzeA2UbD6GkIW96zpzbLXMApLB9wamSIeHpxcq3EDB42L8nKXLicrorl5LjzfCzEN0l6vfV6imJ156IlJf+1PngGFUEW3bvuB+y/G+DMDdQZY=
Message-ID: <86802c440801071843p583f390as53f8b600622b93b2@mail.gmail.com>
Date: Mon, 7 Jan 2008 18:43:46 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Adrian Bunk" <bunk@stusta.de>
Subject: free_pages_check
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wonder why free_pages_check mm/page_alloc.c is using bit OR than logical OR

@@ -450,9 +450,9 @@ static inline void __free_one_page(struc

 static inline int free_pages_check(struct page *page)
 {
-       if (unlikely(page_mapcount(page) |
-               (page->mapping != NULL)  |
-               (page_count(page) != 0)  |
+       if (unlikely(page_mapcount(page) ||
+               (page->mapping != NULL)  ||
+               (page_count(page) != 0)  ||
                (page->flags & (
                        1 << PG_lru     |
                        1 << PG_private |

YH
