Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYABNlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYABNlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYABNlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:41:04 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57794 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbYABNlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:41:01 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Miller <davem@davemloft.net>
Subject: Re: [patch] linux/ufs_fs.h: do not export to userspace anymore
Date: Wed, 2 Jan 2008 08:40:59 -0500
User-Agent: KMail/1.9.7
Cc: hch@infradead.org, bunk@kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <200801012051.41474.vapier@gentoo.org> <20080102075033.GA16267@infradead.org> <20080102.000444.18510965.davem@davemloft.net>
In-Reply-To: <20080102.000444.18510965.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020841.00332.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> > The only non-kernel user of this known to me is silo, which should just
> > have it's own header documenting the solaris sparc ufs variant it needs
> > to understand, possibly by using a copy of the kernel version at any
> > given point of time.
>
> And this is what the current SILO sources do.

then if silo has gotten its stuff together ...
---
Do not export linux/ufs_fs.h to userspace anymore as the only userspace
consumer has been fixed to not need it anymore.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f30fa92..fd2570f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -336,7 +336,6 @@ unifdef-y += tty.h
 unifdef-y += types.h
 unifdef-y += udf_fs_i.h
 unifdef-y += udp.h
-unifdef-y += ufs_fs.h
 unifdef-y += uinput.h
 unifdef-y += uio.h
 unifdef-y += unistd.h
diff --git a/include/linux/ufs_fs.h b/include/linux/ufs_fs.h
index 10b854d..46e4a8d 100644
--- a/include/linux/ufs_fs.h
+++ b/include/linux/ufs_fs.h
@@ -35,16 +35,10 @@
 #include <linux/stat.h>
 #include <linux/fs.h>
 
-#ifndef __KERNEL__
-typedef __u64 __fs64;
-typedef __u32 __fs32;
-typedef __u16 __fs16;
-#else
 #include <asm/div64.h>
 typedef __u64 __bitwise __fs64;
 typedef __u32 __bitwise __fs32;
 typedef __u16 __bitwise __fs16;
-#endif
 
 #define UFS_BBLOCK 0
 #define UFS_BBSIZE 8192
