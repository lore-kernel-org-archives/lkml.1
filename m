Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYERLdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYERLdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYERLdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:33:03 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:1269 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302AbYERLdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:33:02 -0400
Subject: [PATCH] selinux: reorder inode_security_struct to increase
	objs/slab on 64bit
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: sds@tycho.nsa.gov, jmorris@namei.org
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 18 May 2008 12:32:57 +0100
Message-Id: <1211110377.3021.8.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder inode_security_struct to remove padding on 64 bit builds
    
size reduced from 72 to 64 bytes increasing objects per slab to 64.
        
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
This patch is against 2.6.26-r2 & boots successfully on my AMD64
desktop.


Richard



diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 032c235..5f0be19 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -43,8 +43,8 @@ struct inode_security_struct {
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */
 	unsigned char initialized;	/* initialization flag */
-	struct mutex lock;
 	unsigned char inherit;	/* inherit SID from parent entry */
+	struct mutex lock;
 };
 
 struct file_security_struct {


