Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbXJWFow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbXJWFow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXJWFoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:44:44 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:55810 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXJWFon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:44:43 -0400
Date: Tue, 23 Oct 2007 07:44:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] net: fix xfrm build - missing scatterlist.h include
Message-ID: <20071023054441.GA24546@osiris.boeblingen.de.ibm.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-3-git-send-email-jens.axboe@oracle.com> <20071023051316.GB10055@osiris.boeblingen.de.ibm.com> <20071023051640.GL16425@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023051640.GL16425@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

net/xfrm/xfrm_algo.c: In function 'skb_icv_walk':
net/xfrm/xfrm_algo.c:555: error: implicit declaration of function 'sg_set_page'
make[2]: *** [net/xfrm/xfrm_algo.o] Error 1

Cc: David Miller <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 net/xfrm/xfrm_algo.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/net/xfrm/xfrm_algo.c
===================================================================
--- linux-2.6.orig/net/xfrm/xfrm_algo.c
+++ linux-2.6/net/xfrm/xfrm_algo.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/pfkeyv2.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <net/xfrm.h>
 #if defined(CONFIG_INET_AH) || defined(CONFIG_INET_AH_MODULE) || defined(CONFIG_INET6_AH) || defined(CONFIG_INET6_AH_MODULE)
 #include <net/ah.h>
