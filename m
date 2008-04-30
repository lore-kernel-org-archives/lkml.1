Return-Path: <linux-kernel-owner+w=401wt.eu-S933356AbYD3U6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356AbYD3U6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYD3U6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:58:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13432 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbYD3U6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:58:13 -0400
Date: Wed, 30 Apr 2008 13:56:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] PNP: fix printk format warnings
Message-Id: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

next-20080430/drivers/pnp/pnpbios/rsparser.c:594: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'
next-20080430/drivers/pnp/pnpbios/rsparser.c:605: warning: format '%d' expects type 'int', but argument 4 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pnp/pnpbios/rsparser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- next-20080430.orig/drivers/pnp/pnpbios/rsparser.c
+++ next-20080430/drivers/pnp/pnpbios/rsparser.c
@@ -591,7 +591,7 @@ static void pnpbios_encode_irq(struct pn
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode irq %d\n", (int)res->start);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -602,7 +602,7 @@ static void pnpbios_encode_dma(struct pn
 	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %d\n", res->start);
+	dev_dbg(&dev->dev, "  encode dma %d\n", (int)res->start);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
