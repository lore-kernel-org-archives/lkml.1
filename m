Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbXBEQ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbXBEQ7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932814AbXBEQ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:59:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:25012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbXBEQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:59:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=P2N4nV/dNXabvgMpBHqTdRvwFo/75xCrfUYHn23man5CXvYDkhuJfxXrspNVlYElixPXHM9WHDPkcJ2SpzemjWkBHcOECuc6NP1EFS7TbIFxoRVeIdSFGNX0VD5vFB/l4TiBW60VEL0hchaxMWGrpXQaa4JHfCPyIdVNftyjRMg=
Date: Mon, 5 Feb 2007 18:59:16 +0200
To: ebs@ebshome.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linuxppc-embedded@ozlabs.org
Subject: [PATCH 2.6.20] ibm_emac: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165916.GK3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A patch to use ARRAY_SIZE macro already defined in kernel.h.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch isn't compile-tested cause I don't have the needed hardware.

diff --git a/drivers/net/ibm_emac/ibm_emac_debug.c b/drivers/net/ibm_emac/ibm_emac_debug.c
index 92f970d..1f70906 100644
--- a/drivers/net/ibm_emac/ibm_emac_debug.c
+++ b/drivers/net/ibm_emac/ibm_emac_debug.c
@@ -132,7 +132,7 @@ void emac_dbg_register(int idx, struct ocp_enet_private *dev)
 {
 	unsigned long flags;
 
-	if (idx >= sizeof(__emacs) / sizeof(__emacs[0])) {
+	if (idx >= ARRAY_SIZE(__emacs)) {
 		printk(KERN_WARNING
 		       "invalid index %d when registering EMAC for debugging\n",
 		       idx);
@@ -148,7 +148,7 @@ void mal_dbg_register(int idx, struct ibm_ocp_mal *mal)
 {
 	unsigned long flags;
 
-	if (idx >= sizeof(__mals) / sizeof(__mals[0])) {
+	if (idx >= ARRAY_SIZE(__mals)) {
 		printk(KERN_WARNING
 		       "invalid index %d when registering MAL for debugging\n",
 		       idx);
@@ -167,11 +167,11 @@ void emac_dbg_dump_all(void)
 
 	local_irq_save(flags);
 
-	for (i = 0; i < sizeof(__mals) / sizeof(__mals[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(__mals); ++i)
 		if (__mals[i])
 			emac_mal_dump(__mals[i]);
 
-	for (i = 0; i < sizeof(__emacs) / sizeof(__emacs[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(__emacs); ++i)
 		if (__emacs[i])
 			emac_mac_dump(i, __emacs[i]);
 

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
