Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbYFIWa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbYFIWa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbYFIW15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:27:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47294 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761254AbYFIW1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:27:55 -0400
Date: Tue, 10 Jun 2008 01:27:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?utf-8?B?S8O8w6fDvGs=?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] remove the in-kernel struct dirent{,64}
Message-ID: <20080609222701.GZ1987@cs181133002.pp.htv.fi>
References: <200806082116.50355.caglar@pardus.org.tr> <20080608184310.GD4048@cs181133002.pp.htv.fi> <87prqrn4d8.fsf@duaron.myhome.or.jp> <484C83D9.2020402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <484C83D9.2020402@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel struct dirent{,64} were different from the ones in 
userspace.

Even worse, we exported the kernel ones to userspace.

But after the fat usages are fixed we can remove the conflicting 
kernel versions.

Reported-by: H. Peter Anvin <hpa@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has to be applied after the two patches that change fat to 
use __fat_fs_dirent.

 include/linux/Kbuild   |    1 -
 include/linux/dirent.h |   20 --------------------
 2 files changed, 21 deletions(-)

d447529e60e097e260ed43ca97b04dde36954c8b diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 93b9885..4d3649a 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -186,7 +186,6 @@ unifdef-y += connector.h
 unifdef-y += cuda.h
 unifdef-y += cyclades.h
 unifdef-y += dccp.h
-unifdef-y += dirent.h
 unifdef-y += dlm.h
 unifdef-y += dlm_plock.h
 unifdef-y += edd.h
diff --git a/include/linux/dirent.h b/include/linux/dirent.h
index 5d6023b..f072fb8 100644
--- a/include/linux/dirent.h
+++ b/include/linux/dirent.h
@@ -1,23 +1,6 @@
 #ifndef _LINUX_DIRENT_H
 #define _LINUX_DIRENT_H
 
-struct dirent {
-	long		d_ino;
-	__kernel_off_t	d_off;
-	unsigned short	d_reclen;
-	char		d_name[256]; /* We must not include limits.h! */
-};
-
-struct dirent64 {
-	__u64		d_ino;
-	__s64		d_off;
-	unsigned short	d_reclen;
-	unsigned char	d_type;
-	char		d_name[256];
-};
-
-#ifdef __KERNEL__
-
 struct linux_dirent64 {
 	u64		d_ino;
 	s64		d_off;
@@ -26,7 +9,4 @@ struct linux_dirent64 {
 	char		d_name[0];
 };
 
-#endif	/* __KERNEL__ */
-
-
 #endif

