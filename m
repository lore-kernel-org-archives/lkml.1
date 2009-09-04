Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbZIDUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbZIDUR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934122AbZIDUQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:16:52 -0400
Received: from kroah.org ([198.145.64.141]:36290 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100AbZIDUOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:56 2009
Message-Id: <20090904200856.062588101@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 39/48] NET: llc, zero sockaddr_llc struct
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=net-llc-zero-sockaddr_llc-struct.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Slaby <jirislaby@gmail.com>

commit 28e9fc592cb8c7a43e4d3147b38be6032a0e81bc upstream.

sllc_arphrd member of sockaddr_llc might not be changed. Zero sllc
before copying to the above layer's structure.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/llc/af_llc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -915,6 +915,7 @@ static int llc_ui_getname(struct socket 
 	struct llc_sock *llc = llc_sk(sk);
 	int rc = 0;
 
+	memset(&sllc, 0, sizeof(sllc));
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;


