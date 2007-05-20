Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbXETOlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbXETOlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbXETOlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:41:08 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2988 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbXETOlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:41:07 -0400
X-AuthUser: hirofumi@parknet.jp
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hogawa@miraclelinux.com
Subject: [PATCH] power: Fix sizeof(PAGE_SIZE) typo
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sun, 20 May 2007 23:40:48 +0900
Message-ID: <87646ny2vj.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix sizeof(PAGE_SIZE) typo. It should be just PAGE_SIZE for zeroing the
swsusp_header.

Signed-off-by: OGAWA Hirofumi <hogawa@miraclelinux.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/swap.c~power-sizeof-page-size-fix kernel/power/swap.c
--- linux-2.6/kernel/power/swap.c~power-sizeof-page-size-fix	2007-05-20 18:01:32.000000000 +0900
+++ linux-2.6-hirofumi/kernel/power/swap.c	2007-05-20 18:01:32.000000000 +0900
@@ -584,7 +584,7 @@ int swsusp_check(void)
 	resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
 	if (!IS_ERR(resume_bdev)) {
 		set_blocksize(resume_bdev, PAGE_SIZE);
-		memset(swsusp_header, 0, sizeof(PAGE_SIZE));
+		memset(swsusp_header, 0, PAGE_SIZE);
 		error = bio_read_page(swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
