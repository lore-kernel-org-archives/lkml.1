Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZJAXmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZJAXmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZJAXma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:42:30 -0400
Received: from kroah.org ([198.145.64.141]:42054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbZJAXiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:21 2009
Message-Id: <20091001233321.578747017@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jakub@redhat.com,
       security@kernel.org, mingo@elte.hu, davem@davemloft.net,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 19/30] net: Make the copy length in af_packet sockopt handler unsigned
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=net-make-the-copy-length-in-af_packet-sockopt-handler-unsigned.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1501,7 +1501,7 @@ packet_setsockopt(struct socket *sock, i
 static int packet_getsockopt(struct socket *sock, int level, int optname,
 			     char __user *optval, int __user *optlen)
 {
-	int len;
+	unsigned int len;
 	int val;
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
@@ -1514,7 +1514,7 @@ static int packet_getsockopt(struct sock
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	if (len < 0)
+	if ((int)len < 0)
 		return -EINVAL;
 
 	switch(optname)	{


