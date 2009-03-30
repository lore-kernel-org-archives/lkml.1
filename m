Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZC3Slf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZC3Slf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZC3SlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:41:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60641 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZC3SlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:41:24 -0400
To: user-mode-linux-devel@lists.sourceforge.net
CC: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 1/3] uml: fix compile error from net_device_ops conversion
Message-Id: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 20:41:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix the following compile error:

arch/um/drivers/net_kern.c: In function 'uml_inetaddr_event':
arch/um/drivers/net_kern.c:760: error: 'struct net_device' has no member named 'open'

This was introduced by commit 8bb95b39, "uml: convert network device
to netdevice ops".

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/um/drivers/net_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/net_kern.c	2009-03-30 17:07:10.000000000 +0200
+++ linux-2.6/arch/um/drivers/net_kern.c	2009-03-30 19:25:30.000000000 +0200
@@ -757,7 +757,7 @@ static int uml_inetaddr_event(struct not
 	void (*proc)(unsigned char *, unsigned char *, void *);
 	unsigned char addr_buf[4], netmask_buf[4];
 
-	if (dev->open != uml_net_open)
+	if (dev->netdev_ops->ndo_open != uml_net_open)
 		return NOTIFY_DONE;
 
 	lp = netdev_priv(dev);
