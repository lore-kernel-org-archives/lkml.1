Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbXGYBad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbXGYBad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 21:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXGYBaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 21:30:25 -0400
Received: from pcls5.std.com ([192.74.137.145]:36381 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759065AbXGYBaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 21:30:24 -0400
From: Alan Curry <pacman@TheWorld.com>
Message-Id: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
Subject: [PATCH] powerpc: Pegasos keyboard detection
To: linux-kernel@vger.kernel.org
Date: Tue, 24 Jul 2007 21:28:32 -0400 (EDT)
Cc: linuxppc-dev@ozlabs.org
In-Reply-To: <200707230616.l6N6GaPg1212004@shell01.TheWorld.com>
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse controller
on the PegasosPPC. This is because of a feature/bug in the OF device tree:
the "device_type" attribute is an empty string instead of "8042" as the
kernel expects. This patch (against 2.6.22.1) adds a secondary detection
which looks for a device whose *name* is "8042" if there is no device whose
*type* is "8042".

Signed-off-by: Alan Curry <pacman@world.std.com>

--- arch/powerpc/kernel/setup-common.c.orig	2007-07-24 19:04:17.000000000 -0500
+++ arch/powerpc/kernel/setup-common.c	2007-07-24 19:06:36.000000000 -0500
@@ -487,6 +487,10 @@ int check_legacy_ioport(unsigned long ba
 	switch(base_port) {
 	case I8042_DATA_REG:
 		np = of_find_node_by_type(NULL, "8042");
+		/* Pegasos has no device_type on its 8042 node, look for the
+		 * name instead */
+		if (!np)
+			np = of_find_node_by_name(NULL, "8042");
 		break;
 	case FDC_BASE: /* FDC1 */
 		np = of_find_node_by_type(NULL, "fdc");

