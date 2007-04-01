Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXDAMWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXDAMWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXDAMWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 08:22:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2703 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbXDAMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 08:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Lo6AQ98DPI0i4inUNbdJL+9qUL3g8g2VMdG5B/1xruksc59ayC8odA7DLHg+bJMtTjXAQEXXVso/6jDmDHipBBiUX4i3/iVtBu9O7ECETHvw/QCsKLNKeNHl0YwwUd4k/w+cXjXsDw/Wuie38uwaj5LbLGawyDf7w8CltsdfsMw=
Date: Sun, 1 Apr 2007 17:53:19 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, ralf@linux-mips.org
Subject: [KJ][PATCH] ROUND_UP cleanup in arch/mips/kernel/sysirix.c
Message-ID: <20070401122319.GA10178@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP(32|64) cleanup, use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 sysirix.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/arch/mips/kernel/sysirix.c b/arch/mips/kernel/sysirix.c
index 93a1484..59c25bc 100644
--- a/arch/mips/kernel/sysirix.c
+++ b/arch/mips/kernel/sysirix.c
@@ -1736,14 +1736,13 @@ struct irix_dirent32_callback {
 };
 
 #define NAME_OFFSET32(de) ((int) ((de)->d_name - (char *) (de)))
-#define ROUND_UP32(x) (((x)+sizeof(u32)-1) & ~(sizeof(u32)-1))
 
 static int irix_filldir32(void *__buf, const char *name,
 	int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct irix_dirent32 __user *dirent;
 	struct irix_dirent32_callback *buf = __buf;
-	unsigned short reclen = ROUND_UP32(NAME_OFFSET32(dirent) + namlen + 1);
+	unsigned short reclen = ALIGN(NAME_OFFSET32(dirent) + namlen + 1, sizeof(u32));
 	int err = 0;
 	u32 d_ino;
 
@@ -1838,14 +1837,13 @@ struct irix_dirent64_callback {
 };
 
 #define NAME_OFFSET64(de) ((int) ((de)->d_name - (char *) (de)))
-#define ROUND_UP64(x) (((x)+sizeof(u64)-1) & ~(sizeof(u64)-1))
 
 static int irix_filldir64(void *__buf, const char *name,
 	int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct irix_dirent64 __user *dirent;
 	struct irix_dirent64_callback * buf = __buf;
-	unsigned short reclen = ROUND_UP64(NAME_OFFSET64(dirent) + namlen + 1);
+	unsigned short reclen = ALIGN(NAME_OFFSET64(dirent) + namlen + 1,sizeof(u64));
 	int err = 0;
 
 	if (!access_ok(VERIFY_WRITE, buf, sizeof(*buf)))

-- 
Milind Arun Choudhary
