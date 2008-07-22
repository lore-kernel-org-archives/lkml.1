Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYGVF3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYGVF3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYGVFXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:43070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913AbYGVFXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 22/79] device create: net: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:46 -0700
Message-Id: <1216703983-21448-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/ppp_generic.c |    3 ++-
 drivers/net/wan/cosa.c    |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 6b1d7a8..739b3ab 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -866,7 +866,8 @@ static int __init ppp_init(void)
 			err = PTR_ERR(ppp_class);
 			goto out_chrdev;
 		}
-		device_create(ppp_class, NULL, MKDEV(PPP_MAJOR, 0), "ppp");
+		device_create_drvdata(ppp_class, NULL, MKDEV(PPP_MAJOR, 0),
+				      NULL, "ppp");
 	}
 
 out:
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 5827324..f7d3349 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -397,9 +397,9 @@ static int __init cosa_init(void)
 		err = PTR_ERR(cosa_class);
 		goto out_chrdev;
 	}
-	for (i=0; i<nr_cards; i++) {
-		device_create(cosa_class, NULL, MKDEV(cosa_major, i), "cosa%d", i);
-	}
+	for (i = 0; i < nr_cards; i++)
+		device_create_drvdata(cosa_class, NULL, MKDEV(cosa_major, i),
+				      NULL, "cosa%d", i);
 	err = 0;
 	goto out;
 	
-- 
1.5.6.3

