Return-Path: <linux-kernel-owner+w=401wt.eu-S935096AbZLGNui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096AbZLGNui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935042AbZLGNue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:50:34 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46861 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934993AbZLGNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:50:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mMkvLNj4sKKXhWgo7OCP0O1NmsLb3JawZBVWmDJ9f4D6kpSSNpoUtUVht39EhzrQtg
         ly8HWUpwbfjutkJfTEuM5//E2T2qeXy3c+t7Smoj+BMSO6fjRxUatjJ148xVA+d2dSlO
         Lufps7dfyuVmgblvhukatdk2/KcogtDux3pMA=
Message-ID: <4B1D0873.90004@gmail.com>
Date: Mon, 07 Dec 2009 14:51:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: PTR_ERR return of wrong pointer in setup_new_group_blocks()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ext4/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3cfc343..3b2c554 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -247,7 +247,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			goto exit_bh;
 
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
-			err = PTR_ERR(bh);
+			err = PTR_ERR(gdb);
 			goto exit_bh;
 		}
 		ext4_handle_dirty_metadata(handle, NULL, gdb);
