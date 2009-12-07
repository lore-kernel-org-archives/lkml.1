Return-Path: <linux-kernel-owner+w=401wt.eu-S935063AbZLGNtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbZLGNtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935028AbZLGNs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:48:59 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56629 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934927AbZLGNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Jm5bx/gsWJFJgiSE1nFzpmWG3TV7BBibG97HrQQH19d8BMAVRXgJCbiuyYpJbFTgIM
         N0vxz/dw2E3wSMZevjXN3OEYjAX24samgbE45SB6QNmY07IbK/qRH4gX+WONaBE0Lwdn
         vTJ5WD8FtK/AK7+Kg7/XF7MXdQkkF+PDf9q7I=
Message-ID: <4B1D0813.4070502@gmail.com>
Date: Mon, 07 Dec 2009 14:50:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext3: PTR_ERR return of wrong pointer in setup_new_group_blocks()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ext3/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 8359e7b..5f83b61 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -266,7 +266,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			goto exit_bh;
 
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
-			err = PTR_ERR(bh);
+			err = PTR_ERR(gdb);
 			goto exit_bh;
 		}
 		ext3_journal_dirty_metadata(handle, gdb);
