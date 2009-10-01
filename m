Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZJAXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZJAXXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZJAXXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:23:22 -0400
Received: from kroah.org ([198.145.64.141]:39678 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZJAXXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:23:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:18:05 2009
Message-Id: <20091001231805.475593743@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:16:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jakub@redhat.com,
       security@kernel.org, mingo@elte.hu, davem@davemloft.net,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 7/9] net: Make the copy length in af_packet sockopt handler unsigned
References: <20091001231633.719696398@mini.kroah.org>
Content-Disposition: inline; filename=net-make-the-copy-length-in-af_packet-sockopt-handler-unsigned.patch
In-Reply-To: <20091001231938.GA29593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

fixed upstream in commit b7058842c940ad2c08dd829b21e5c92ebe3b8758 in a different way

The length of the to-copy data structure is currently stored in
a signed integer. However many comparisons are done with sizeof(..)
which is unsigned. It's more suitable for this variable to be unsigned
to make these comparisons more naturally right.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/packet/af_packet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1500,7 +1500,7 @@ packet_setsockopt(struct socket *sock, i
 static int packet_getsockopt(struct socket *sock, int level, int optname,
 			     char __user *optval, int __user *optlen)
 {
-	int len;
+	unsigned int len;
 	int val;
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
@@ -1513,7 +1513,7 @@ static int packet_getsockopt(struct sock
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	if (len < 0)
+	if ((int)len < 0)
 		return -EINVAL;
 
 	switch(optname)	{


