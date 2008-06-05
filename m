Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYFEIh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYFEIh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYFEIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:37:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:49224 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751721AbYFEIhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:37:12 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1++3MUf2Dy+yCNdfNr96ixqH2qymYjkyJGXhRld8E
	GP5YsveZAk8ILg
Date: Thu, 5 Jun 2008 10:37:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: dbrownell@users.sourceforge.net, eric miao <eric.miao@marvell.com>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH] spi: fix list scan success verification in PXA ssp driver
Message-ID: <Pine.LNX.4.64.0806051027340.6598@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list search success check in arch/arm/mach-pxa/ssp.c is wrong: for 
example, it didn't recognise failure for me when I requested port 0.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

 arch/arm/mach-pxa/ssp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/arm/mach-pxa/ssp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/ssp.c	2008-06-04 12:11:26.000000000 +0200
+++ linux-2.6/arch/arm/mach-pxa/ssp.c	2008-06-04 12:11:50.000000000 +0200
@@ -330,7 +330,7 @@
 
 	mutex_unlock(&ssp_lock);
 
-	if (ssp->port_id != port)
+	if (&ssp->node == &ssp_list)
 		return NULL;
 
 	return ssp;

