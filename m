Return-Path: <linux-kernel-owner+w=401wt.eu-S1946548AbXBIPfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946548AbXBIPfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946567AbXBIPft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946563AbXBIPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RPNbiCZm23EbYUb2WuxEF3Lxe0S16gksJHqdaqHwhR1jKbCYPG21wEKnNbBCrupJsNA6Xl1A033lnqpKPTo6efe9oqGKYtlLdZAurtHOZ/pmiVvo752tRbrF8Ro/9RD/No4yCjBiGFFqskHpTdaYJfZ1mAcCSqpTCrK8D0eWJV4=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk
Subject: [PATCH 24/34] __initdata cleanup - init
Date: Fri, 9 Feb 2007 17:28:09 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091728.09205.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/init/do_mounts.c linux-2.6.20-rc6-mm3/init/do_mounts.c
--- linux-2.6.20-rc6-mm3.org/init/do_mounts.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/init/do_mounts.c	2007-01-31 22:19:30.000000000 +0200
@@ -18,11 +18,11 @@
 
 extern int get_filesystem_list(char * buf);
 
-int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
+int __initdata rd_doload = 0;	/* 1 = load RAM disk, 0 = don't load */
 
 int root_mountflags = MS_RDONLY | MS_SILENT;
-char * __initdata root_device_name;
-static char __initdata saved_root_name[64];
+char * __initdata root_device_name = NULL;
+static char __initdata saved_root_name[64] = "";
 
 dev_t ROOT_DEV;
 
@@ -214,21 +214,21 @@ static int __init root_dev_setup(char *l
 
 __setup("root=", root_dev_setup);
 
-static char * __initdata root_mount_data;
+static char * __initdata root_mount_data = NULL;
 static int __init root_data_setup(char *str)
 {
 	root_mount_data = str;
 	return 1;
 }
 
-static char * __initdata root_fs_names;
+static char * __initdata root_fs_names = NULL;
 static int __init fs_names_setup(char *str)
 {
 	root_fs_names = str;
 	return 1;
 }
 
-static unsigned int __initdata root_delay;
+static unsigned int __initdata root_delay = 0;
 static int __init root_delay_setup(char *str)
 {
 	root_delay = simple_strtoul(str, NULL, 0);
diff -urNp linux-2.6.20-rc6-mm3.org/init/do_mounts_initrd.c linux-2.6.20-rc6-mm3/init/do_mounts_initrd.c
--- linux-2.6.20-rc6-mm3.org/init/do_mounts_initrd.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/init/do_mounts_initrd.c	2007-01-31 22:19:30.000000000 +0200
@@ -13,7 +13,7 @@
 unsigned long initrd_start, initrd_end;
 int initrd_below_start_ok;
 unsigned int real_root_dev;	/* do_proc_dointvec cannot handle kdev_t */
-static int __initdata old_fd, root_fd;
+static int __initdata old_fd = 0, root_fd = 0;
 static int __initdata mount_initrd = 1;
 
 static int __init no_initrd(char *str)
diff -urNp linux-2.6.20-rc6-mm3.org/init/do_mounts_md.c linux-2.6.20-rc6-mm3/init/do_mounts_md.c
--- linux-2.6.20-rc6-mm3.org/init/do_mounts_md.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/init/do_mounts_md.c	2007-01-31 22:19:30.000000000 +0200
@@ -12,7 +12,7 @@
  * The code for that is here.
  */
 
-static int __initdata raid_noautodetect, raid_autopart;
+static int __initdata raid_noautodetect = 0, raid_autopart = 0;
 
 static struct {
 	int minor;
@@ -20,9 +20,9 @@ static struct {
 	int level;
 	int chunk;
 	char *device_names;
-} md_setup_args[256] __initdata;
+} md_setup_args[256] __initdata = {{0}};
 
-static int md_setup_ents __initdata;
+static int md_setup_ents __initdata = 0;
 
 extern int mdp_major;
 /*
diff -urNp linux-2.6.20-rc6-mm3.org/init/initramfs.c linux-2.6.20-rc6-mm3/init/initramfs.c
--- linux-2.6.20-rc6-mm3.org/init/initramfs.c	2007-01-31 22:15:41.000000000 +0200
+++ linux-2.6.20-rc6-mm3/init/initramfs.c	2007-01-31 22:19:30.000000000 +0200
@@ -7,7 +7,7 @@
 #include <linux/string.h>
 #include <linux/syscalls.h>
 
-static __initdata char *message;
+static __initdata char *message = NULL;
 static void __init error(char *x)
 {
 	if (!message)
@@ -33,7 +33,7 @@ static __initdata struct hash {
 	mode_t mode;
 	struct hash *next;
 	char name[N_ALIGN(PATH_MAX)];
-} *head[32];
+} *head[32] = {0};
 
 static inline int hash(int major, int minor, int ino)
 {
@@ -84,12 +84,12 @@ static void __init free_hash(void)
 
 /* cpio header parsing */
 
-static __initdata unsigned long ino, major, minor, nlink;
-static __initdata mode_t mode;
-static __initdata unsigned long body_len, name_len;
-static __initdata uid_t uid;
-static __initdata gid_t gid;
-static __initdata unsigned rdev;
+static __initdata unsigned long ino = 0l, major = 0l, minor = 0l, nlink = 0l;
+static __initdata mode_t mode = 0;
+static __initdata unsigned long body_len = 0l, name_len = 0l;
+static __initdata uid_t uid = 0;
+static __initdata gid_t gid = 0;
+static __initdata unsigned rdev = 0;
 
 static void __init parse_header(char *s)
 {
@@ -125,13 +125,13 @@ static __initdata enum state {
 	CopyFile,
 	GotSymlink,
 	Reset
-} state, next_state;
+} state = Start, next_state = Start;
 
-static __initdata char *victim;
-static __initdata unsigned count;
-static __initdata loff_t this_header, next_header;
+static __initdata char *victim = NULL;
+static __initdata unsigned count = 0;
+static __initdata loff_t this_header = 0, next_header = 0;
 
-static __initdata int dry_run;
+static __initdata int dry_run = 0;
 
 static inline void eat(unsigned n)
 {
@@ -140,9 +140,9 @@ static inline void eat(unsigned n)
 	count -= n;
 }
 
-static __initdata char *collected;
-static __initdata int remains;
-static __initdata char *collect;
+static __initdata char *collected = NULL;
+static __initdata int remains = 0;
+static __initdata char *collect = NULL;
 
 static void __init read_into(char *buf, unsigned size, enum state next)
 {
@@ -158,7 +158,7 @@ static void __init read_into(char *buf, 
 	}
 }
 
-static __initdata char *header_buf, *symlink_buf, *name_buf;
+static __initdata char *header_buf = NULL, *symlink_buf = NULL, *name_buf = NULL;
 
 static int __init do_start(void)
 {
@@ -257,7 +257,7 @@ static void __init clean_path(char *path
 	}
 }
 
-static __initdata int wfd;
+static __initdata int wfd = 0;
 
 static int __init do_name(void)
 {
@@ -491,7 +491,7 @@ static char * __init unpack_to_rootfs(ch
 	return message;
 }
 
-static int __initdata do_retain_initrd;
+static int __initdata do_retain_initrd = 0;
 
 static int __init retain_initrd_param(char *str)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/init/main.c linux-2.6.20-rc6-mm3/init/main.c
--- linux-2.6.20-rc6-mm3.org/init/main.c	2007-01-31 22:15:41.000000000 +0200
+++ linux-2.6.20-rc6-mm3/init/main.c	2007-01-31 22:19:30.000000000 +0200
@@ -122,7 +122,7 @@ void (*late_time_init)(void);
 extern void softirq_init(void);
 
 /* Untouched command line saved by arch-specific code. */
-char __initdata boot_command_line[COMMAND_LINE_SIZE];
+char __initdata boot_command_line[COMMAND_LINE_SIZE] = "";
 /* Untouched saved command line (eg. for /proc) */
 char *saved_command_line;
 /* Command line for parameter parsing */
@@ -470,7 +470,7 @@ static int __init do_early_param(char *p
 void __init parse_early_param(void)
 {
 	static __initdata int done = 0;
-	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
+	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE] = "";
 
 	if (done)
 		return;
@@ -640,7 +640,7 @@ asmlinkage void __init start_kernel(void
 	rest_init();
 }
 
-static int __initdata initcall_debug;
+static int __initdata initcall_debug = 0;
 
 static int __init initcall_debug_setup(char *str)
 {
