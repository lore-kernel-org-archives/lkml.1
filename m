Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbXB1Uny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbXB1Uny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXB1Uny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:43:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbXB1Unx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:43:53 -0500
Date: Wed, 28 Feb 2007 15:41:39 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Jeff Garzik <jeff@garzik.org>
Subject: Fix mv643xx_eth compilation.
Message-ID: <20070228204139.GA30657@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ralf Baechle <ralf@linux-mips.org>, Jeff Garzik <jeff@garzik.org>
References: <200702271559.l1RFxJXN013132@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702271559.l1RFxJXN013132@hera.kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 908b637fe793165b6aecdc875cdca67c4959a1ad removed ETH_DMA_ALIGN
but missed a usage of it in a macro, which broke the build.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/net/mv643xx_eth.h b/drivers/net/mv643xx_eth.h
index 7cb0a41..7d4e90c 100644
--- a/drivers/net/mv643xx_eth.h
+++ b/drivers/net/mv643xx_eth.h
@@ -9,6 +9,8 @@
 
 #include <linux/mv643xx.h>
 
+#include <asm/dma-mapping.h>
+
 /* Checksum offload for Tx works for most packets, but
  * fails if previous packet sent did not use hw csum
  */
@@ -47,7 +49,7 @@
 #define ETH_HW_IP_ALIGN		2		/* hw aligns IP header */
 #define ETH_WRAPPER_LEN		(ETH_HW_IP_ALIGN + ETH_HLEN + \
 					ETH_VLAN_HLEN + ETH_FCS_LEN)
-#define ETH_RX_SKB_SIZE		(dev->mtu + ETH_WRAPPER_LEN + ETH_DMA_ALIGN)
+#define ETH_RX_SKB_SIZE		(dev->mtu + ETH_WRAPPER_LEN + dma_get_cache_alignment())
 
 #define ETH_RX_QUEUES_ENABLED	(1 << 0)	/* use only Q0 for receive */
 #define ETH_TX_QUEUES_ENABLED	(1 << 0)	/* use only Q0 for transmit */

-- 
http://www.codemonkey.org.uk
