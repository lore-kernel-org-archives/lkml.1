Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZL1RSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZL1RSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZL1RSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:18:00 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:50232 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751423AbZL1RR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:17:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: init/initramfs.c: fix "symbol shadows an earlier one" noise
Date: Mon, 28 Dec 2009 12:17:58 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F473@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: init/initramfs.c: fix "symbol shadows an earlier one" noise
Thread-Index: AcqH4bPIumi60NOVSfmaLpruJdblWQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Dec 2009 17:17:58.0220 (UTC) FILETIME=[B37D38C0:01CA87E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'count' is a local global variable in this file.  The
function clean_rootfs() should use a different symbol name to
prevent "symbol shadows an earlier one" noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/init/initramfs.c b/init/initramfs.c
index b37d34b..37d3859 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -525,7 +525,7 @@ static void __init clean_rootfs(void)
 	int fd;
 	void *buf;
 	struct linux_dirent64 *dirp;
-	int count;
+	int num;
 
 	fd = sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
@@ -539,9 +539,9 @@ static void __init clean_rootfs(void)
 	}
 
 	dirp = buf;
-	count = sys_getdents64(fd, dirp, BUF_SIZE);
-	while (count > 0) {
-		while (count > 0) {
+	num = sys_getdents64(fd, dirp, BUF_SIZE);
+	while (num > 0) {
+		while (num > 0) {
 			struct stat st;
 			int ret;
 
@@ -554,12 +554,12 @@ static void __init clean_rootfs(void)
 					sys_unlink(dirp->d_name);
 			}
 
-			count -= dirp->d_reclen;
+			num -= dirp->d_reclen;
 			dirp = (void *)dirp + dirp->d_reclen;
 		}
 		dirp = buf;
 		memset(buf, 0, BUF_SIZE);
-		count = sys_getdents64(fd, dirp, BUF_SIZE);
+		num = sys_getdents64(fd, dirp, BUF_SIZE);
 	}
 
 	sys_close(fd); 
