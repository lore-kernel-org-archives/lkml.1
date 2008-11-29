Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYK2JhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYK2JhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 04:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYK2Jg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 04:36:59 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:8262 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYK2Jg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 04:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BZt5lQXuB9G93DGalahSImcF7Vn6cq/9bJNkuz9iHnqpl23P+2wG/gzy3MSHmTd0Yg
         YpDqBSLk71IUwmSeOX2Tp/AvED4VzWaXmCl4bCZ5GexMnuITWtsEo4NCrJ1MYNCfe5PY
         6K2tQZg16S1a6PIc0YUg3G8hqK9+FwEIV1+H0=
Message-ID: <49310D34.1000205@gmail.com>
Date: Sat, 29 Nov 2008 04:36:52 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: tytso@mit.edu, adilger@sun.com
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: fix loop in do_split()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned i >= 0 is always true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63adcb7..389cf60 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count-1; i < count; i--) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;
