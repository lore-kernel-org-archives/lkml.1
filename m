Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877Ab0AOAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0AOAVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292Ab0AOAVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:21:42 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15418 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750757Ab0AOAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:21:42 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net/core/sock.c: quiet sparse noise
Date: Thu, 14 Jan 2010 17:21:45 -0700
Cc: davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141721.45305.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/core/sock.c: quiet sparse noise

In sock_getsockopt the symbol 'lv' is declared as an
unsigned int type, probably due to sizeof returning a
size_t which is really an unsigned int.

This produces a sparse warning for SO_PEERNAME due to
the sock->ops->getname() call:

warning: incorrect type in argument 3 (different signedness)
   expected int *sockaddr_len
   got unsigned int *<noident>

Quiet the warning my changing the type of 'lv' to an int.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/net/core/sock.c b/net/core/sock.c
index e1f6f22..10b1d32 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -741,7 +741,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct timeval tm;
 	} v;
 
-	unsigned int lv = sizeof(int);
+	int lv = sizeof(int);
 	int len;
 
 	if (get_user(len, optlen))
