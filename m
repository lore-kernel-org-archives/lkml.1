Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbZIEAWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbZIEAWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964827AbZIEAWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:22:43 -0400
Received: from kroah.org ([198.145.64.141]:42376 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964802AbZIEAVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:58 2009
Message-Id: <20090905001458.529147675@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 71/71] NET: llc, zero sockaddr_llc struct
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=net-llc-zero-sockaddr_llc-struct.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

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
@@ -914,6 +914,7 @@ static int llc_ui_getname(struct socket 
 	struct llc_sock *llc = llc_sk(sk);
 	int rc = 0;
 
+	memset(&sllc, 0, sizeof(sllc));
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;


