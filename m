Return-Path: <linux-kernel-owner+w=401wt.eu-S1762904AbZLPUdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904AbZLPUdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZLPUdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:33:22 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:48096 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZLPUdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:33:21 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 15:33:21 EST
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH] Don't export vt_kmsg_redirect() to userspace
Date: Wed, 16 Dec 2009 21:26:56 +0100
Message-Id: <1260995216-25377-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.4.2
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning in linux-next by guarding the function definition (both
the "extern" and the inline) with #ifdef __KERNEL__.

------------------------- 8< ----------------------------------------------------
usr/include/linux/vt.h:89: userspace cannot call function or variable defined in
the kernel

Introduced by commit 5ada918b82399eef3afd6a71e3637697d6bd719f ("vt:
introduce and use vt_kmsg_redirect() function").
------------------------- >8 ----------------------------------------------------


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 include/linux/vt.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/vt.h b/include/linux/vt.h
index 3fb9944..d5dd0bc 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -84,6 +84,8 @@ struct vt_setactivate {
 
 #define VT_SETACTIVATE	0x560F	/* Activate and set the mode of a console */
 
+#ifdef __KERNEL__
+
 #ifdef CONFIG_VT_CONSOLE
 
 extern int vt_kmsg_redirect(int new);
@@ -97,6 +99,8 @@ static inline int vt_kmsg_redirect(int new)
 
 #endif
 
+#endif /* __KERNEL__ */
+
 #define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
 
 #endif /* _LINUX_VT_H */
-- 
1.6.4.2

