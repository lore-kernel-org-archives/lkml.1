Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYABBvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYABBvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYABBvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:51:43 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42242 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYABBvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:51:43 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] linux/ufs_fs.h: use __u64 for userspace
Date: Tue, 1 Jan 2008 20:51:40 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801012051.41474.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the ufs_inotofsba macro to use __u64 rather than u64 since this is
exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/ufs_fs.h b/include/linux/ufs_fs.h
index 10b854d..35b6e59 100644
--- a/include/linux/ufs_fs.h
+++ b/include/linux/ufs_fs.h
@@ -225,7 +225,7 @@ typedef __u16 __bitwise __fs16;
  */
 #define	ufs_inotocg(x)		((x) / uspi->s_ipg)
 #define	ufs_inotocgoff(x)	((x) % uspi->s_ipg)
-#define	ufs_inotofsba(x)	(((u64)ufs_cgimin(ufs_inotocg(x))) + ufs_inotocgoff(x) / uspi->s_inopf)
+#define	ufs_inotofsba(x)	(((__u64)ufs_cgimin(ufs_inotocg(x))) + ufs_inotocgoff(x) / uspi->s_inopf)
 #define	ufs_inotofsbo(x)	((x) % uspi->s_inopf)
 
 /*
