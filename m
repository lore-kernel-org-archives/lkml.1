Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYEQMTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYEQMTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 08:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYEQMTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 08:19:36 -0400
Received: from saeurebad.de ([85.214.36.134]:55570 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbYEQMTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 08:19:35 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Possible partial miss in pages needed for zone's memory map?
Date: Sat, 17 May 2008 14:19:15 +0200
Message-ID: <87y769f7i4.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I stumbled over the following in the zone initialization code.  Please
let me know if I overlooked something here.

---

From: Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] Don't drop a partial page in a zone's memory map size

In a zone's present pages number, account for all pages occupied by the
memory map, including a partial.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3378,7 +3378,8 @@ static void __paginginit free_area_init_
 		 * is used by this zone for memmap. This affects the watermark
 		 * and per-cpu initialisations
 		 */
-		memmap_pages = (size * sizeof(struct page)) >> PAGE_SHIFT;
+		memmap_pages =
+			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
 			printk(KERN_DEBUG
