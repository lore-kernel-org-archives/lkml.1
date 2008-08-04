Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbYHDS1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbYHDS1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbYHDS1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:27:20 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:34950 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbYHDS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QM8zKd40X7xG40sMcLBSTJ+6hBf/KbSwrbyLN1S8BtDFqX5sHfOmQ2R0yTQ5MdmvzB
         2SszeCq4qUX3at6JOaGVxUbqv7ZyNMrwNbw1dRC8GYTeDFQEF1x4+Ky87/yFBzIgbCP1
         rWefOFsJTUL/GAJO2ysJdikCxR8ZtfHHzBnGw=
Message-ID: <ea11fea30808041127u3c35b268l7ad193c415e9af5a@mail.gmail.com>
Date: Mon, 4 Aug 2008 23:57:15 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: kernel-janitors@vger.kernel.org, trivial@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove redundant condition from map_buffer_to_page
Cc: mkatiyar@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the only caller to this function is do_mpage_readpage()
which already checks if the buffer is uptodate, so a check inside is
not required.

Signed-off-by:- "Manish Katiyar" <mkatiyar@gmail.com>

---
 fs/mpage.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index dbcc7af..a797de1 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -135,8 +135,7 @@ map_buffer_to_page(struct page *page, struct
buffer_head *bh, int page_block)
 		 * don't make any buffers if there is only one buffer on
 		 * the page and the page just needs to be set up to date
 		 */
-		if (inode->i_blkbits == PAGE_CACHE_SHIFT &&
-		    buffer_uptodate(bh)) {
+		if (inode->i_blkbits == PAGE_CACHE_SHIFT) {
 			SetPageUptodate(page);
 			return;
 		}
-- 
1.5.4.3



Thanks -
Manish
