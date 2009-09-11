Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZIKAdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZIKAdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZIKAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:33:18 -0400
Received: from kroah.org ([198.145.64.141]:38047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZIKA3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:09 2009
Message-Id: <20090911002409.656912578@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/22] pppol2tp: calls unregister_pernet_gen_device() at unload time
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=pppol2tp-calls-unregister_pernet_gen_device-at-unload-time.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 446e72f30eca76d6f9a1a54adf84d2c6ba2831f8 ]

Failure to call unregister_pernet_gen_device() can exhaust memory
if module is loaded/unloaded many times.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/pppol2tp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -2682,6 +2682,7 @@ out_unregister_pppol2tp_proto:
 static void __exit pppol2tp_exit(void)
 {
 	unregister_pppox_proto(PX_PROTO_OL2TP);
+	unregister_pernet_gen_device(pppol2tp_net_id, &pppol2tp_net_ops);
 	proto_unregister(&pppol2tp_sk_proto);
 }
 


