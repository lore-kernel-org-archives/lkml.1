Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbZATOP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbZATOP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761509AbZATONy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:13:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:11889 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761352AbZATONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=E2VWtVQVI2f8CWkRLf0Ist5Vvha6NyJ2ODcmJEYT7K1pUHZzHXIf4Ud2YDwLa89eQJ
         mFKTEO819V97uJejmxpWI4cYU7ujZ8f+Oj/wQDDyXbUOi+G4/aAmHHdAA0Wn4ibZ4R7z
         Y2NarJjT2xYrW6ICxImWr7QLj8lDVHNNusHws=
Message-Id: <4975dc14.0637560a.7f8e.729c@mx.google.com>
References: <20090120140510.228815074@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: davem@davemloft.net, jchapman@katalix.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, devel@openvz.org, xemul@openvz.org
Cc: Michal Ostrowski <mostrows@earthlink.net>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 5/5] net: pppoe,pppol2tp - register channels with explicit net
Content-Disposition: inline; filename=net-ppp-register-net-channel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In PPPo[E|L2TP] we could explicitly point which net namespace
we're going to use for channels - make it so.

CC: James Chapman <jchapman@katalix.com>
CC: Michal Ostrowski <mostrows@earthlink.net>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/net/pppoe.c    |    2 +-
 drivers/net/pppol2tp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/drivers/net/pppoe.c
===================================================================
--- linux-2.6.git.orig/drivers/net/pppoe.c
+++ linux-2.6.git/drivers/net/pppoe.c
@@ -695,7 +695,7 @@ static int pppoe_connect(struct socket *
 		po->chan.private = sk;
 		po->chan.ops = &pppoe_chan_ops;
 
-		error = ppp_register_channel(&po->chan);
+		error = ppp_register_net_channel(dev_net(dev), &po->chan);
 		if (error)
 			goto err_put;
 
Index: linux-2.6.git/drivers/net/pppol2tp.c
===================================================================
--- linux-2.6.git.orig/drivers/net/pppol2tp.c
+++ linux-2.6.git/drivers/net/pppol2tp.c
@@ -1749,7 +1749,7 @@ static int pppol2tp_connect(struct socke
 	po->chan.ops	 = &pppol2tp_chan_ops;
 	po->chan.mtu	 = session->mtu;
 
-	error = ppp_register_channel(&po->chan);
+	error = ppp_register_net_channel(sock_net(sk), &po->chan);
 	if (error)
 		goto end_put_tun;
 

-- 
