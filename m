Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbZHGUnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbZHGUnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933964AbZHGUnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:43:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965AbZHGUnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:43:10 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Lennert Buytenhek <kernel@wantstofly.org>, netdev@vger.kernel.org
Subject: [PATCH 5/6] [NET] ixp2000/enp2611: don't set non-existent member get_stats
Date: Fri,  7 Aug 2009 22:42:40 +0200
Message-Id: <1249677761-19470-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090807203939.GA19374@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build failure for 2.6.31-rc5 (ARCH=arm, ixp2000_defconfig):

	  CC      drivers/net/ixp2000/enp2611.o
	drivers/net/ixp2000/enp2611.c: In function 'enp2611_init_module':
	drivers/net/ixp2000/enp2611.c:213: error: 'struct net_device' has no member named 'get_stats'

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: netdev@vger.kernel.org
---
Hello,

obviously this has the downside that the stats won't work, I let the fix
for someone else :-)

Best regards
Uwe
---
 drivers/net/ixp2000/enp2611.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixp2000/enp2611.c b/drivers/net/ixp2000/enp2611.c
index b02a981..d6ef176 100644
--- a/drivers/net/ixp2000/enp2611.c
+++ b/drivers/net/ixp2000/enp2611.c
@@ -210,7 +210,7 @@ static int __init enp2611_init_module(void)
 			return -ENOMEM;
 		}
 
-		nds[i]->get_stats = enp2611_get_stats;
+		/* nds[i]->get_stats = enp2611_get_stats; */
 		pm3386_init_port(i);
 		pm3386_get_mac(i, nds[i]->dev_addr);
 	}
-- 
1.6.3.3

