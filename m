Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbZFNMDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbZFNMDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZFNMBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52669 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758658AbZFNMBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 08/17] Blackfin: convert socket/poll to asm-generic
Date: Sun, 14 Jun 2009 08:01:09 -0400
Message-Id: <1244980878-2124-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/poll.h    |   21 ++----------
 arch/blackfin/include/asm/socket.h  |   60 +----------------------------------
 arch/blackfin/include/asm/sockios.h |   14 +-------
 3 files changed, 5 insertions(+), 90 deletions(-)

diff --git a/arch/blackfin/include/asm/poll.h b/arch/blackfin/include/asm/poll.h
index 94cc263..a055667 100644
--- a/arch/blackfin/include/asm/poll.h
+++ b/arch/blackfin/include/asm/poll.h
@@ -1,24 +1,9 @@
 #ifndef __BFIN_POLL_H
 #define __BFIN_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
-#define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
+#define POLLWRNORM	4 /* POLLOUT */
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
-#endif				/* __BFIN_POLL_H */
+#endif
diff --git a/arch/blackfin/include/asm/socket.h b/arch/blackfin/include/asm/socket.h
index fac7fe9..6b71384 100644
--- a/arch/blackfin/include/asm/socket.h
+++ b/arch/blackfin/include/asm/socket.h
@@ -1,59 +1 @@
-#ifndef _ASM_SOCKET_H
-#define _ASM_SOCKET_H
-
-#include <asm/sockios.h>
-
-/* For setsockoptions(2) */
-#define SOL_SOCKET	1
-
-#define SO_DEBUG	1
-#define SO_REUSEADDR	2
-#define SO_TYPE		3
-#define SO_ERROR	4
-#define SO_DONTROUTE	5
-#define SO_BROADCAST	6
-#define SO_SNDBUF	7
-#define SO_RCVBUF	8
-#define SO_SNDBUFFORCE	32
-#define SO_RCVBUFFORCE	33
-#define SO_KEEPALIVE	9
-#define SO_OOBINLINE	10
-#define SO_NO_CHECK	11
-#define SO_PRIORITY	12
-#define SO_LINGER	13
-#define SO_BSDCOMPAT	14
-/* To add :#define SO_REUSEPORT 15 */
-#define SO_PASSCRED	16
-#define SO_PEERCRED	17
-#define SO_RCVLOWAT	18
-#define SO_SNDLOWAT	19
-#define SO_RCVTIMEO	20
-#define SO_SNDTIMEO	21
-
-/* Security levels - as per NRL IPv6 - don't actually do anything */
-#define SO_SECURITY_AUTHENTICATION		22
-#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
-#define SO_SECURITY_ENCRYPTION_NETWORK		24
-
-#define SO_BINDTODEVICE	25
-
-/* Socket filtering */
-#define SO_ATTACH_FILTER	26
-#define SO_DETACH_FILTER	27
-
-#define SO_PEERNAME		28
-#define SO_TIMESTAMP		29
-#define SCM_TIMESTAMP		SO_TIMESTAMP
-
-#define SO_ACCEPTCONN		30
-#define SO_PEERSEC		31
-#define SO_PASSSEC		34
-#define SO_TIMESTAMPNS		35
-#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
-
-#define SO_MARK			36
-
-#define SO_TIMESTAMPING		37
-#define SCM_TIMESTAMPING	SO_TIMESTAMPING
-
-#endif				/* _ASM_SOCKET_H */
+#include <asm-generic/socket.h>
diff --git a/arch/blackfin/include/asm/sockios.h b/arch/blackfin/include/asm/sockios.h
index 426b89b..def6d47 100644
--- a/arch/blackfin/include/asm/sockios.h
+++ b/arch/blackfin/include/asm/sockios.h
@@ -1,13 +1 @@
-#ifndef __ARCH_BFIN_SOCKIOS__
-#define __ARCH_BFIN_SOCKIOS__
-
-/* Socket-level I/O control calls. */
-#define FIOSETOWN 	0x8901
-#define SIOCSPGRP	0x8902
-#define FIOGETOWN	0x8903
-#define SIOCGPGRP	0x8904
-#define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906	/* Get stamp (timeval) */
-#define SIOCGSTAMPNS	0x8907	/* Get stamp (timespec) */
-
-#endif				/* __ARCH_BFIN_SOCKIOS__ */
+#include <asm-generic/sockios.h>
-- 
1.6.3.1

