Return-Path: <linux-kernel-owner+w=401wt.eu-S934141AbZIDUOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbZIDUOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934120AbZIDUOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:49 -0400
Received: from kroah.org ([198.145.64.141]:36311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934113AbZIDUOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:56 2009
Message-Id: <20090904200856.494481884@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 42/48] rose: Fix rose_getname() leak
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=rose-fix-rose_getname-leak.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 17ac2e9c58b69a1e25460a568eae1b0dc0188c25 upstream.

rose_getname() can leak kernel memory to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rose/af_rose.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -957,6 +957,7 @@ static int rose_getname(struct socket *s
 	struct rose_sock *rose = rose_sk(sk);
 	int n;
 
+	memset(srose, 0, sizeof(*srose));
 	if (peer != 0) {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -ENOTCONN;


