Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXDLRNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXDLRNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXDLRNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:13:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:2564 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519AbXDLRM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LEK+TDey+7wvRaZUZl0IjbmCxHLH30qPOGVuovpefnPS9JYmoWWxfnTcqKvgHdVCg303qeOrmL2n25xlt/Kq5uBs8rrV472sKL+8rt32KOnBMGW7xURiLDnpyMMmVrO2bLaUIwWaQ9o+uyYl900SXGxqB3ro2DWVQtJvpvknJtc=
Date: Thu, 12 Apr 2007 22:44:53 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net, wli@holomorphy.com
Subject: [KJ][PATCH]ROUND_UP macro cleanup in arch/sparc,sparc64
Message-ID: <20070412171452.GA8884@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup, use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---
 sparc/kernel/sys_sunos.c     |    5 ++---
 sparc64/kernel/sys_sunos32.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/kernel/sys_sunos.c b/arch/sparc/kernel/sys_sunos.c
index da6606f..23f4efe 100644
--- a/arch/sparc/kernel/sys_sunos.c
+++ b/arch/sparc/kernel/sys_sunos.c
@@ -322,7 +322,6 @@ struct sunos_dirent_callback {
 };
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(long)-1) & ~(sizeof(long)-1))
 
 static int sunos_filldir(void * __buf, const char * name, int namlen,
 			 loff_t offset, u64 ino, unsigned int d_type)
@@ -330,7 +329,7 @@ static int sunos_filldir(void * __buf, const char * name, int namlen,
 	struct sunos_dirent __user *dirent;
 	struct sunos_dirent_callback * buf = __buf;
 	unsigned long d_ino;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
@@ -415,7 +414,7 @@ static int sunos_filldirentry(void * __buf, const char * name, int namlen,
 	struct sunos_direntry __user *dirent;
 	struct sunos_direntry_callback *buf = __buf;
 	unsigned long d_ino;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(long));
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
diff --git a/arch/sparc64/kernel/sys_sunos32.c b/arch/sparc64/kernel/sys_sunos32.c
index 4cff95b..937f19b 100644
--- a/arch/sparc64/kernel/sys_sunos32.c
+++ b/arch/sparc64/kernel/sys_sunos32.c
@@ -273,14 +273,13 @@ struct sunos_dirent_callback {
 };
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(s32)-1) & ~(sizeof(s32)-1))
 
 static int sunos_filldir(void * __buf, const char * name, int namlen,
 			 loff_t offset, ino_t ino, unsigned int d_type)
 {
 	struct sunos_dirent __user *dirent;
 	struct sunos_dirent_callback * buf = (struct sunos_dirent_callback *) __buf;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(s32));
 	u32 d_ino;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */
@@ -367,7 +366,7 @@ static int sunos_filldirentry(void * __buf, const char * name, int namlen,
 	struct sunos_direntry __user *dirent;
 	struct sunos_direntry_callback * buf =
 		(struct sunos_direntry_callback *) __buf;
-	int reclen = ROUND_UP(NAME_OFFSET(dirent) + namlen + 1);
+	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(s32));
 	u32 d_ino;
 
 	buf->error = -EINVAL;	/* only used if we fail.. */

-- 
Milind Arun Choudhary
