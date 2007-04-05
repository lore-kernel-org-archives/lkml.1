Return-Path: <linux-kernel-owner+w=401wt.eu-S2992711AbXDENnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992711AbXDENnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXDENnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:43:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:13139 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992711AbXDENnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oz6hJFOn6oUdQtmL1U6loM3gEHhCoAM+uGXvqOK4vMjmh6Ox0OwU1iV6ofUjRpl2ZU8WmkulesKOUqUTQLZADZ3LrDW5xXfquYsn/d6A6Wd4TmdGW50m7UUt8QUnsWIuKXUbMzrB2pnhzq6XBcKoVJ8iiobdHEUTo9U6PyykucM=
Date: Thu, 5 Apr 2007 19:14:22 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: [KJ][PATCH]ROUND_UP macro cleanup in arch/alpha/kernel/osf_sys.c
Message-ID: <20070405134422.GA9510@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup use ALIGN
 
Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
---

 osf_sys.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)


diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index be133f1..c77d231 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -93,7 +93,6 @@ osf_set_program_attributes(unsigned long text_start, unsigned long text_len,
  * offset differences aren't the same as "d_reclen").
  */
 #define NAME_OFFSET	offsetof (struct osf_dirent, d_name)
-#define ROUND_UP(x)	(((x)+3) & ~3)
 
 struct osf_dirent {
 	unsigned int d_ino;
@@ -115,7 +114,7 @@ osf_filldir(void *__buf, const char *name, int namlen, loff_t offset,
 {
 	struct osf_dirent __user *dirent;
 	struct osf_dirent_callback *buf = (struct osf_dirent_callback *) __buf;
-	unsigned int reclen = ROUND_UP(NAME_OFFSET + namlen + 1);
+	unsigned int reclen = ALIGN(NAME_OFFSET + namlen + 1, sizeof(u32));
 	unsigned int d_ino;
 
 	buf->error = -EINVAL;	/* only used if we fail */
@@ -174,7 +173,6 @@ osf_getdirentries(unsigned int fd, struct osf_dirent __user *dirent,
 	return error;
 }
 
-#undef ROUND_UP
 #undef NAME_OFFSET
 
 asmlinkage unsigned long
-- 
Milind Arun Choudhary
