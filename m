Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXK2Tqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXK2Tqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbXK2TqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:46:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3835 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619AbXK2Tp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=tXfpLf14kaIIPcPjQ1hZXI6+UC/ss8G5GD4EIIgNE6tT4FRxqqrLVHmY24qZXVEkg/vJKGg6V1+EZlaLPNGgz2NSrAD4vCoqM9Lp2ZdY796j7obkckSSR23zX++FXhimujwmr2xHsejCYYbqBbDTWDeLGeuadX8JgB/IN9S03Jw=
Date: Thu, 29 Nov 2007 22:46:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/5] PPC cleanup: celleb - do use for_each macro
Message-ID: <20071129194639.GE12123@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/platforms/celleb/scc_sio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/celleb/scc_sio.c b/arch/powerpc/platforms/celleb/scc_sio.c
index 6100082..5e43bac 100644
--- a/arch/powerpc/platforms/celleb/scc_sio.c
+++ b/arch/powerpc/platforms/celleb/scc_sio.c
@@ -42,14 +42,13 @@ static struct {
 static int __init txx9_serial_init(void)
 {
 	extern int early_serial_txx9_setup(struct uart_port *port);
-	struct device_node *node = NULL;
+	struct device_node *node;
 	int i;
 	struct uart_port req;
 	struct of_irq irq;
 	struct resource res;
 
-	while ((node = of_find_compatible_node(node,
-				"serial", "toshiba,sio-scc")) != NULL) {
+	for_each_compatible_node(node, "serial", "toshiba,sio-scc") {
 		for (i = 0; i < ARRAY_SIZE(txx9_scc_tab); i++) {
 			if (!(txx9_serial_bitmap & (1<<i)))
 				continue;
-- 
1.5.3.5
