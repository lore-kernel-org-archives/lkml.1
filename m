Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbZAOUkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbZAOUkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbZAOUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:23 -0500
Received: from kroah.org ([198.145.64.141]:49527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932256AbZAOUCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:18 -0500
Date: Thu, 15 Jan 2009 11:59:42 -0800
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
Subject: [patch 63/94] [PATCH 32/44] [CVE-2009-0029] System call wrappers
	part 22
Message-ID: <20090115195942.GK14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0032--CVE-2009-0029-System-call-wrappers-part-22.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 3e0fa65f8ba4fd24b3dcfaf14d5b15eaab0fdc61 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/socket.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1215,7 +1215,7 @@ int sock_create_kern(int family, int typ
 	return __sock_create(&init_net, family, type, protocol, res, 1);
 }
 
-asmlinkage long sys_socket(int family, int type, int protocol)
+SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
 {
 	int retval;
 	struct socket *sock;
@@ -1256,8 +1256,8 @@ out_release:
  *	Create a pair of connected sockets.
  */
 
-asmlinkage long sys_socketpair(int family, int type, int protocol,
-			       int __user *usockvec)
+SYSCALL_DEFINE4(socketpair, int, family, int, type, int, protocol,
+		int __user *, usockvec)
 {
 	struct socket *sock1, *sock2;
 	int fd1, fd2, err;
@@ -1393,7 +1393,7 @@ SYSCALL_DEFINE3(bind, int, fd, struct so
  *	ready for listening.
  */
 
-asmlinkage long sys_listen(int fd, int backlog)
+SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 {
 	struct socket *sock;
 	int err, fput_needed;
@@ -1623,9 +1623,9 @@ SYSCALL_DEFINE3(getpeername, int, fd, st
  *	the protocol.
  */
 
-asmlinkage long sys_sendto(int fd, void __user *buff, size_t len,
-			   unsigned flags, struct sockaddr __user *addr,
-			   int addr_len)
+SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
+		unsigned, flags, struct sockaddr __user *, addr,
+		int, addr_len)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
@@ -1668,7 +1668,8 @@ out:
  *	Send a datagram down a socket.
  */
 
-asmlinkage long sys_send(int fd, void __user *buff, size_t len, unsigned flags)
+SYSCALL_DEFINE4(send, int, fd, void __user *, buff, size_t, len,
+		unsigned, flags)
 {
 	return sys_sendto(fd, buff, len, flags, NULL, 0);
 }
@@ -1679,9 +1680,9 @@ asmlinkage long sys_send(int fd, void __
  *	sender address from kernel to user space.
  */
 
-asmlinkage long sys_recvfrom(int fd, void __user *ubuf, size_t size,
-			     unsigned flags, struct sockaddr __user *addr,
-			     int __user *addr_len)
+SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
+		unsigned, flags, struct sockaddr __user *, addr,
+		int __user *, addr_len)
 {
 	struct socket *sock;
 	struct iovec iov;
@@ -1823,7 +1824,7 @@ SYSCALL_DEFINE2(shutdown, int, fd, int, 
  *	BSD sendmsg interface
  */
 
-asmlinkage long sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags)
+SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned, flags)
 {
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
@@ -1929,8 +1930,8 @@ out:
  *	BSD recvmsg interface
  */
 
-asmlinkage long sys_recvmsg(int fd, struct msghdr __user *msg,
-			    unsigned int flags)
+SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
+		unsigned int, flags)
 {
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
@@ -2053,7 +2054,7 @@ static const unsigned char nargs[19]={
  *  it is set by the callees.
  */
 
-asmlinkage long sys_socketcall(int call, unsigned long __user *args)
+SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 {
 	unsigned long a[6];
 	unsigned long a0, a1;

