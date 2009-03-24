Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbZCXVOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbZCXVOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZCXVNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:18 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:37968 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZCXVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OedorMgjR/bPsQzPP+nojfD01gBuuIsPphDiUcdzQb230FJpjPm+g2Vwodd4SwW0pg
         m8gbKbooP5zouXhrsnbbyUgGV20LTE5TVo/kVZkW4XMaecqw5r8bl51qlJtM0Rbqo7Lg
         OFnJIh5pPmAimK/9Nf2KDU73ftUxOUmqle0WI=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, cooloney@kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 04/13] [blackfin] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:39 -0500
Message-Id: <1237929168-15341-5-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/blackfin/mach-bf561/coreb.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf561/coreb.c b/arch/blackfin/mach-bf561/coreb.c
index 8598098..9ad89af 100644
--- a/arch/blackfin/mach-bf561/coreb.c
+++ b/arch/blackfin/mach-bf561/coreb.c
@@ -220,9 +220,10 @@ static int coreb_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int coreb_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
+static long coreb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	lock_kernel();
+
 	int retval = 0;
 	int coreb_index = 0;
 
@@ -289,6 +290,7 @@ static int coreb_ioctl(struct inode *inode, struct file *file,
 #endif
 	}
 
+	unlock_kernel();
 	return retval;
 }
 
@@ -297,7 +299,7 @@ static struct file_operations coreb_fops = {
 	.llseek = coreb_lseek,
 	.read = coreb_read,
 	.write = coreb_write,
-	.ioctl = coreb_ioctl,
+	.unlocked_ioctl = coreb_ioctl,
 	.open = coreb_open,
 	.release = coreb_release
 };
-- 
1.6.2

