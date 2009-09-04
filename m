Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbZIDURq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbZIDURq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934084AbZIDUOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:41 -0400
Received: from kroah.org ([198.145.64.141]:36256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934049AbZIDUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:55 2009
Message-Id: <20090904200855.314980155@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 34/48] can: Fix raw_getname() leak
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=can-fix-raw_getname-leak.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit e84b90ae5eb3c112d1f208964df1d8156a538289 upstream.

raw_getname() can leak 10 bytes of kernel memory to user

(two bytes hole between can_family and can_ifindex,
8 bytes at the end of sockaddr_can structure)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Oliver Hartkopp <oliver@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/raw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -396,6 +396,7 @@ static int raw_getname(struct socket *so
 	if (peer)
 		return -EOPNOTSUPP;
 
+	memset(addr, 0, sizeof(*addr));
 	addr->can_family  = AF_CAN;
 	addr->can_ifindex = ro->ifindex;
 


