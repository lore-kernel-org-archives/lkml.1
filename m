Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYEaXIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYEaXIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYEaXIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:08:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50251 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYEaXIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:08:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 1 Jun 2008 01:08:22 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: clear LinkControl register when enabling
 the chip
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want the rcvPhyPkt bit in LinkControl off before we start using the
chip.  However, the spec says that the reset value of it is undefined.
Hence switch it (and all other bits while we are at it) explicitly off.

https://bugzilla.redhat.com/show_bug.cgi?id=244576#c48 shows that for
example the nForce2 integrated FireWire controller seems to have it on
by default.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1473,6 +1473,7 @@ static int ohci_enable(struct fw_card *c
 	reg_write(ohci, OHCI1394_HCControlClear,
 		  OHCI1394_HCControl_noByteSwapData);
 
+	reg_write(ohci, OHCI1394_LinkControlClear, ~0);
 	reg_write(ohci, OHCI1394_LinkControlSet,
 		  OHCI1394_LinkControl_rcvSelfID |
 		  OHCI1394_LinkControl_cycleTimerEnable |

-- 
Stefan Richter
-=====-==--- -==- ----=
http://arcgraph.de/sr/

