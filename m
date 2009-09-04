Return-Path: <linux-kernel-owner+w=401wt.eu-S934079AbZIDURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbZIDURo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934052AbZIDURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:17:42 -0400
Received: from kroah.org ([198.145.64.141]:36271 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934079AbZIDUOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:55 2009
Message-Id: <20090904200855.571467442@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 36/48] econet: Fix econet_getname() leak
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=econet-fix-econet_getname-leak.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 80922bbb12a105f858a8f0abb879cb4302d0ecaa upstream.

econet_getname() can leak kernel memory to user.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/econet/af_econet.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -520,6 +520,7 @@ static int econet_getname(struct socket 
 	if (peer)
 		return -EOPNOTSUPP;
 
+	memset(sec, 0, sizeof(*sec));
 	mutex_lock(&econet_mutex);
 
 	sk = sock->sk;


