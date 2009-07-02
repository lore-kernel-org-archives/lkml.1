Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZGBFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZGBFc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZGBFcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:32:01 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58731 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbZGBFb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RlnvpJXok297DNKywEahHgjRjsh8qwN3o3V2JVNEbp5EWYsqJScvmH6vfr30O9oGb+
         kjBiB/KM0oVQNmzaDUnAlkkSZ3jTCKXJ5EuNDSFpTpBsHcnh85P20MPk3dr2jTf6D1EW
         wlbMx/ADCcJCdra1uuAeWYbgJe9xCgZxZuooI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/8] SELinux netlabel.c non trivial fixes.
Date: Wed,  1 Jul 2009 22:32:43 -0700
Message-Id: <1246512767-2999-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix a comment to sound better.
Fix some comments.
---
 security/selinux/netlabel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 2e98441..7868ea2 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -167,7 +167,7 @@ void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec)
  *
  * Description:
  * Call the NetLabel mechanism to get the security attributes of the given
- * packet and use those attributes to determine the correct context/SID to
+ * packet and use those attributes to determine the correct context/SID to be
  * assign to the packet.  Returns zero on success, negative values on failure.
  *
  */
@@ -216,8 +216,8 @@ int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
 	struct netlbl_lsm_secattr *secattr = NULL;
 	struct sock *sk;
 
-	/* if this is a locally generated packet check to see if it is already
-	 * being labeled by it's parent socket, if it is just exit */
+	/* If this is a locally generated packet check to see if it is already
+	 * being labeled by it's parent socket, if it is just exit. */
 	sk = skb->sk;
 	if (sk != NULL) {
 		struct sk_security_struct *sksec = sk->sk_security;
@@ -444,9 +444,9 @@ int selinux_netlbl_socket_connect(struct sock *sk, struct sockaddr *addr)
 	local_bh_disable();
 	bh_lock_sock_nested(sk);
 
-	/* connected sockets are allowed to disconnect when the address family
+	/* Connected sockets are allowed to disconnect when the address family
 	 * is set to AF_UNSPEC, if that is what is happening we want to reset
-	 * the socket */
+	 * the socket. */
 	if (addr->sa_family == AF_UNSPEC) {
 		netlbl_sock_delattr(sk);
 		sksec->nlbl_state = NLBL_REQSKB;
-- 
1.6.3.2

