Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZBYNjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZBYNjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZBYNi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:38:58 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:11967 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZBYNi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=HHn24EHGhwpmZ4/EGdYGS9UPxhlhi0eK/g/VmQQvl9fvS10ZDQ4cnmFg+tktXqpIjq
         Tv8QnF285t9UzxptHDb26V13pEx5/Ka/XDHraGAIWMPCmO7YhYf0Rty46ckYD8+jqIiV
         3VUkcyVON4KsAcfZvvOyHaoDszfdkiFF/1U3Q=
Message-ID: <49A549EE.7020202@gmail.com>
Date: Wed, 25 Feb 2009 14:38:54 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: ecashin@coraid.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] aoe: error printed 1 too early
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with while (i-- > 0); i reaches -1 after the loop, so the test below is printed
one too early: 0 still means success.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index cc25057..eeea477 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -173,7 +173,7 @@ skbfree(struct sk_buff *skb)
 		return;
 	while (atomic_read(&skb_shinfo(skb)->dataref) != 1 && i-- > 0)
 		msleep(Sms);
-	if (i <= 0) {
+	if (i < 0) {
 		printk(KERN_ERR
 			"aoe: %s holds ref: %s\n",
 			skb->dev ? skb->dev->name : "netif",
