Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbZJIXnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbZJIXnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbZJIXnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:43:13 -0400
Received: from kroah.org ([198.145.64.141]:51492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761701AbZJIXmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:40 2009
Message-Id: <20091009233440.560038564@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 35/37] ax25: Fix possible oops in ax25_make_new
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=ax25-fix-possible-oops-in-ax25_make_new.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit 8c185ab6185bf5e67766edb000ce428269364c86 ]

In ax25_make_new, if kmemdup of digipeat returns an error, there would
be an oops in sk_free while calling sk_destruct, because sk_protinfo
is NULL at the moment; move sk->sk_destruct initialization after this.

BTW of reported-by: Bernard Pidoux F6BVP <f6bvp@free.fr>

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -893,7 +893,6 @@ struct sock *ax25_make_new(struct sock *
 
 	sock_init_data(NULL, sk);
 
-	sk->sk_destruct = ax25_free_sock;
 	sk->sk_type     = osk->sk_type;
 	sk->sk_priority = osk->sk_priority;
 	sk->sk_protocol = osk->sk_protocol;
@@ -931,6 +930,7 @@ struct sock *ax25_make_new(struct sock *
 	}
 
 	sk->sk_protinfo = ax25;
+	sk->sk_destruct = ax25_free_sock;
 	ax25->sk    = sk;
 
 	return sk;


