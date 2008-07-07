Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYGGQus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYGGQus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYGGQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:49:57 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753411AbYGGQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:49:55 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/20] SELinux: reorder inode_security_struct to increase objs/slab on 64bit
Date: Tue,  8 Jul 2008 01:42:06 +0900
Message-Id: <1215448942-17581-5-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>

reorder inode_security_struct to remove padding on 64 bit builds

size reduced from 72 to 64 bytes increasing objects per slab to 64.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/objsec.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.5.1

