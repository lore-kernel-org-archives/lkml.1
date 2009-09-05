Return-Path: <linux-kernel-owner+w=401wt.eu-S964859AbZIEAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859AbZIEAVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964809AbZIEAVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:45 -0400
Received: from kroah.org ([198.145.64.141]:42360 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835AbZIEAVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:58 2009
Message-Id: <20090905001458.109470948@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 69/71] econet: Fix econet_getname() leak
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=econet-fix-econet_getname-leak.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

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


