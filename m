Return-Path: <linux-kernel-owner+w=401wt.eu-S934094AbZIDUOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbZIDUOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934081AbZIDUOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:40 -0400
Received: from kroah.org ([198.145.64.141]:36246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934079AbZIDUOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:55 2009
Message-Id: <20090904200855.152815284@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 33/48] appletalk: fix atalk_getname() leak
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=appletalk-fix-atalk_getname-leak.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 3d392475c873c10c10d6d96b94d092a34ebd4791 upstream.

atalk_getname() can leak 8 bytes of kernel memory to user

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/appletalk/ddp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1245,6 +1245,7 @@ static int atalk_getname(struct socket *
 			return -ENOBUFS;
 
 	*uaddr_len = sizeof(struct sockaddr_at);
+	memset(&sat.sat_zero, 0, sizeof(sat.sat_zero));
 
 	if (peer) {
 		if (sk->sk_state != TCP_ESTABLISHED)


