Return-Path: <linux-kernel-owner+w=401wt.eu-S964829AbZIEAX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbZIEAX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934628AbZIEAX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:23:27 -0400
Received: from kroah.org ([198.145.64.141]:42300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825AbZIEAVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:57 2009
Message-Id: <20090905001457.538817270@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 66/71] irda: Fix irda_getname() leak
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=irda-fix-irda_getname-leak.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 09384dfc76e526c3993c09c42e016372dc9dd22c upstream.

irda_getname() can leak kernel memory to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/af_irda.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -714,6 +714,7 @@ static int irda_getname(struct socket *s
 	struct sock *sk = sock->sk;
 	struct irda_sock *self = irda_sk(sk);
 
+	memset(&saddr, 0, sizeof(saddr));
 	if (peer) {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -ENOTCONN;


