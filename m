Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYGGQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYGGQvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYGGQuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:04 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754072AbYGGQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:01 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] SELinux: remove unused and shadowed addrlen variable
Date: Tue,  8 Jul 2008 01:42:19 +0900
Message-Id: <1215448942-17581-18-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused and shadowed addrlen variable.  Picked up by sparse.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Paul Moore <paul.moore@hp.com>
---
 security/selinux/hooks.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f530008..6e8d0e9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3669,7 +3669,7 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 		struct sockaddr_in6 *addr6 = NULL;
 		unsigned short snum;
 		struct sock *sk = sock->sk;
-		u32 sid, node_perm, addrlen;
+		u32 sid, node_perm;
 
 		tsec = current->security;
 		isec = SOCK_INODE(sock)->i_security;
@@ -3677,12 +3677,10 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 		if (family == PF_INET) {
 			addr4 = (struct sockaddr_in *)address;
 			snum = ntohs(addr4->sin_port);
-			addrlen = sizeof(addr4->sin_addr.s_addr);
 			addrp = (char *)&addr4->sin_addr.s_addr;
 		} else {
 			addr6 = (struct sockaddr_in6 *)address;
 			snum = ntohs(addr6->sin6_port);
-			addrlen = sizeof(addr6->sin6_addr.s6_addr);
 			addrp = (char *)&addr6->sin6_addr.s6_addr;
 		}
 
-- 
1.5.5.1

