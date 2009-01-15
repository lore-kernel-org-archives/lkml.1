Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbZAOUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbZAOUkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZAOUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:22 -0500
Received: from kroah.org ([198.145.64.141]:49508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932251AbZAOUCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:17 -0500
Date: Thu, 15 Jan 2009 11:59:40 -0800
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
Subject: [patch 62/94] [PATCH 31/44] [CVE-2009-0029] System call wrappers
	part 21
Message-ID: <20090115195940.GJ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0031--CVE-2009-0029-System-call-wrappers-part-21.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 20f37034fb966a1c35894f9fe529fda0b6440101 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/readdir.c |    6 ++++--
 net/socket.c |   30 +++++++++++++++---------------
 2 files changed, 19 insertions(+), 17 deletions(-)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -187,7 +187,8 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * dirent, unsigned int count)
+SYSCALL_DEFINE3(getdents, unsigned int, fd,
+		struct linux_dirent __user *, dirent, unsigned int, count)
 {
 	struct file * file;
 	struct linux_dirent __user * lastdirent;
@@ -268,7 +269,8 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long sys_getdents64(unsigned int fd, struct linux_dirent64 __user * dirent, unsigned int count)
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
 {
 	struct file * file;
 	struct linux_dirent64 __user * lastdirent;
--- a/net/socket.c
+++ b/net/socket.c
@@ -1364,7 +1364,7 @@ out_fd:
  *	the protocol layer (having also checked the address is ok).
  */
 
-asmlinkage long sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
+SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
@@ -1426,8 +1426,8 @@ asmlinkage long sys_listen(int fd, int b
  *	clean when we restucture accept also.
  */
 
-asmlinkage long sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
-			    int __user *upeer_addrlen, int flags)
+SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
+		int __user *, upeer_addrlen, int, flags)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
@@ -1510,8 +1510,8 @@ out_fd:
 	goto out_put;
 }
 
-asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
-			   int __user *upeer_addrlen)
+SYSCALL_DEFINE3(accept, int, fd, struct sockaddr __user *, upeer_sockaddr,
+		int __user *, upeer_addrlen)
 {
 	return sys_accept4(fd, upeer_sockaddr, upeer_addrlen, 0);
 }
@@ -1528,8 +1528,8 @@ asmlinkage long sys_accept(int fd, struc
  *	include the -EINPROGRESS status for such sockets.
  */
 
-asmlinkage long sys_connect(int fd, struct sockaddr __user *uservaddr,
-			    int addrlen)
+SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
+		int, addrlen)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
@@ -1560,8 +1560,8 @@ out:
  *	name to user space.
  */
 
-asmlinkage long sys_getsockname(int fd, struct sockaddr __user *usockaddr,
-				int __user *usockaddr_len)
+SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
+		int __user *, usockaddr_len)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
@@ -1591,8 +1591,8 @@ out:
  *	name to user space.
  */
 
-asmlinkage long sys_getpeername(int fd, struct sockaddr __user *usockaddr,
-				int __user *usockaddr_len)
+SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr __user *, usockaddr,
+		int __user *, usockaddr_len)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
@@ -1733,8 +1733,8 @@ asmlinkage long sys_recv(int fd, void __
  *	to pass the user mode parameter for the protocols to sort out.
  */
 
-asmlinkage long sys_setsockopt(int fd, int level, int optname,
-			       char __user *optval, int optlen)
+SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
+		char __user *, optval, int, optlen)
 {
 	int err, fput_needed;
 	struct socket *sock;
@@ -1767,8 +1767,8 @@ out_put:
  *	to pass a user mode parameter for the protocols to sort out.
  */
 
-asmlinkage long sys_getsockopt(int fd, int level, int optname,
-			       char __user *optval, int __user *optlen)
+SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
+		char __user *, optval, int __user *, optlen)
 {
 	int err, fput_needed;
 	struct socket *sock;

