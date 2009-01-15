Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbZAOWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbZAOWN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761063AbZAOWCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:16 -0500
Received: from kroah.org ([198.145.64.141]:38272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765602AbZAOWCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:10 -0500
Date: Thu, 15 Jan 2009 13:59:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 21/85] [PATCH 01/44] [CVE-2009-0029] Move compat system
	call declarations to compat header file
Message-ID: <20090115215936.GV17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001--CVE-2009-0029-Move-compat-system-call-declarations.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 4c696ba7982501d43dea11dbbaabd2aa8a19cc42 upstream.

Move declarations to correct header file.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/compat.h   |   13 +++++++++++++
 include/linux/syscalls.h |   12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -278,5 +278,18 @@ asmlinkage long compat_sys_timerfd_setti
 asmlinkage long compat_sys_timerfd_gettime(int ufd,
 				   struct compat_itimerspec __user *otmr);
 
+asmlinkage long compat_sys_move_pages(pid_t pid, unsigned long nr_page,
+				      __u32 __user *pages,
+				      const int __user *nodes,
+				      int __user *status,
+				      int flags);
+asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename,
+				     struct compat_timeval __user *t);
+asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
+				      struct compat_stat __user *statbuf,
+				      int flag);
+asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
+				  int flags, int mode);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -531,11 +531,6 @@ asmlinkage long sys_move_pages(pid_t pid
 				const int __user *nodes,
 				int __user *status,
 				int flags);
-asmlinkage long compat_sys_move_pages(pid_t pid, unsigned long nr_page,
-				__u32 __user *pages,
-				const int __user *nodes,
-				int __user *status,
-				int flags);
 asmlinkage long sys_mbind(unsigned long start, unsigned long len,
 				unsigned long mode,
 				unsigned long __user *nmask,
@@ -584,13 +579,6 @@ asmlinkage long sys_readlinkat(int dfd, 
 			       int bufsiz);
 asmlinkage long sys_utimensat(int dfd, char __user *filename,
 				struct timespec __user *utimes, int flags);
-asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename,
-				     struct compat_timeval __user *t);
-asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
-				      struct compat_stat __user *statbuf,
-				      int flag);
-asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
-				   int flags, int mode);
 asmlinkage long sys_unshare(unsigned long unshare_flags);
 
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,

