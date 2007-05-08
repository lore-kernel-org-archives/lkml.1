Return-Path: <linux-kernel-owner+w=401wt.eu-S966662AbXEHKro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966662AbXEHKro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966481AbXEHKrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:47:43 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:33222 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966449AbXEHKrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:47:43 -0400
Subject: [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page()
	in mm/memory.c
From: Shani Moideen <shani.moideen@wipro.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Tue, 08 May 2007 16:15:56 +0530
Message-Id: <1178621156.3598.10.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 08 May 2007 10:47:39.0677 (UTC) FILETIME=[4C5264D0:01C7915E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in mm/memory.c.

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----

thanks.


diff --git a/mm/memory.c b/mm/memory.c
index e7066e7..2780d07 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1505,7 +1505,7 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
                 * zeroes.
                 */
                if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE))
-                       memset(kaddr, 0, PAGE_SIZE);
+                       clear_page(kaddr);
                kunmap_atomic(kaddr, KM_USER0);
                flush_dcache_page(dst);
                return;


-- 
Shani 
