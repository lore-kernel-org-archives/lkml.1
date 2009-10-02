Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZJBBsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZJBBsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZJBBdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:33 -0400
Received: from kroah.org ([198.145.64.141]:33253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZJBBd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:17 2009
Message-Id: <20091002012417.843865598@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jakub@redhat.com,
       mingo@elte.hu, davem@davemloft.net,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [072/136] net: Make the copy length in af_packet sockopt handler unsigned
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=net-make-the-copy-length-in-af_packet-sockopt-handler-unsigned.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1836,7 +1836,7 @@ packet_setsockopt(struct socket *sock, i
 static int packet_getsockopt(struct socket *sock, int level, int optname,
 			     char __user *optval, int __user *optlen)
 {
-	int len;
+	unsigned int len;
 	int val;
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
@@ -1849,7 +1849,7 @@ static int packet_getsockopt(struct sock
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	if (len < 0)
+	if ((int)len < 0)
 		return -EINVAL;
 
 	switch (optname) {


