Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYAFNvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYAFNvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAFNv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:51:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:59527 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752951AbYAFNv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:51:27 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+9Lh81a9+9rqeziIdG4VUwR2uD/E1u9kKOdWydhg
	/NuUNkrxBd3xhz
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] add gcc printf format checks
Date: Sun, 6 Jan 2008 14:51:22 +0100
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@
	13<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"':
	t"f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@S~&q/MfI3;qWqlg7Q1==jS4
	9V5OJkm$WQ[dc^_Y']DvibvMjizUZ]+'Jd4UnM><yrT}Rw(
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061451.22338.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] add gcc printf format checks

trivial patch which adds some missing printf format checking to 
compat.h and msdos_fs.h
Build-tested and no regressions found.

Signed-off-by: Helge Deller <deller@gmx.de>


diff --git a/include/linux/compat.h b/include/linux/compat.h
index 0e69d2c..ce2038f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -232,7 +232,7 @@ extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
-extern int compat_printk(const char *fmt, ...);
+extern int compat_printk(const char *fmt, ...) __printf(1,2);
 extern void sigset_from_compat(sigset_t *set, compat_sigset_t *compat);
 
 asmlinkage long compat_sys_migrate_pages(compat_pid_t pid,

diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index f950921..651c265 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -419,7 +419,7 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
+extern void fat_fs_panic(struct super_block *s, const char *fmt, ...) __printf(2,3);
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern int date_dos2unix(unsigned short time, unsigned short date);

