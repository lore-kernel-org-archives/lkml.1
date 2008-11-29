Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYK2Jk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYK2Jk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 04:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYK2Jku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 04:40:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:42341 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYK2Jkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 04:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BTNK9/1FZKuPNs5Xq4sGIPYBUXFa4Bs0K5j8uRqvEN0hEMduBydndv0HSJNw4/EmK7
         pvLI4HtBBqBABnEZ9+3AkZnSOo+KGysIOVqw8IgQE7OL6gMcZ/VvvD25uqc4Y1O9W03V
         YEfzAlcorrm7E0uy62IJcPc0ZViqVvST+ZaiY=
Message-ID: <49310E1A.60105@gmail.com>
Date: Sat, 29 Nov 2008 04:40:42 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext3: also fix loop in do_split()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned i >= 0 is always true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 3e5edc9..8f5e15d 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count-1; i < count; i--) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;

