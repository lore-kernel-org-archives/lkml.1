Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXFLDX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXFLDX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXFLDXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:23:22 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:35034 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXFLDXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:23:22 -0400
Subject: [KJ PATCH] Replacing memcpy(dest,src,PAGE_SIZE) with
	copy_page(dest,src) in arch/i386/mm/init.c
From: Shani Moideen <shani.moideen@wipro.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technolgies
Date: Tue, 12 Jun 2007 08:46:14 +0530
Message-Id: <1181618174.2282.16.camel@shani-win>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 12 Jun 2007 03:23:22.0031 (UTC) FILETIME=[0795ABF0:01C7ACA1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in arch/i386/mm/init.c.

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
----


diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
index ae43688..7dc3d46 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -397,7 +397,7 @@ char __nosavedata swsusp_pg_dir[PAGE_SIZE]
 
 static inline void save_pg_dir(void)
 {
-	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
+	copy_page(swsusp_pg_dir, swapper_pg_dir);
 }
 #else
 static inline void save_pg_dir(void)

-- 
Regards,
Shani 
