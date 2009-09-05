Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbZIEAWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbZIEAWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964799AbZIEAVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:46 -0400
Received: from kroah.org ([198.145.64.141]:42358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811AbZIEAVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:58 2009
Message-Id: <20090905001457.816635813@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 68/71] netrom: Fix nr_getname() leak
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=netrom-fix-nr_getname-leak.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit f6b97b29513950bfbf621a83d85b6f86b39ec8db upstream.

nr_getname() can leak kernel memory to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netrom/af_netrom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -848,6 +848,7 @@ static int nr_getname(struct socket *soc
 		sax->fsa_ax25.sax25_family = AF_NETROM;
 		sax->fsa_ax25.sax25_ndigis = 1;
 		sax->fsa_ax25.sax25_call   = nr->user_addr;
+		memset(sax->fsa_digipeater, 0, sizeof(sax->fsa_digipeater));
 		sax->fsa_digipeater[0]     = nr->dest_addr;
 		*uaddr_len = sizeof(struct full_sockaddr_ax25);
 	} else {


