Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYLAT2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYLAT2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYLAT2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:28:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:46838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYLAT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=T/d4WSgeyISIIshw5wPSztVoIGGL5SGfbJR0c2yAZZyc4FVuBAyXEnNKgDT2no1kVj
         w4VGq3T+MrD/zMZ+uyw5bpqMkBGY5httrs4xGUL3KVUcv27KK0o3dOiCeGQJSV+aCJUj
         Bnpu0OEqocLcPJ/BWcvOKiOGl8D5XKR9Jc9mY=
Message-ID: <49343AD9.4020606@gmail.com>
Date: Mon, 01 Dec 2008 14:28:25 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: davidsen@tmr.com
CC: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious unsigned
 wrap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix loop, with obvious unsigned wrap

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 3e5edc9..b0dcfb3 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count; i--; ) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63adcb7..34232c6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count; i--; ) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
