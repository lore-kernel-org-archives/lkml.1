Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbYFESuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbYFESuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbYFESt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:49:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36304 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbYFESt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:49:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 5 Jun 2008 20:49:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: disable PHY packet reception into AR
 context
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de>
Message-ID: <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de>
References: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want the rcvPhyPkt bit in LinkControl off before we start using the
chip.  However, the spec says that the reset value of it is undefined.
Hence switch it explicitly off.

https://bugzilla.redhat.com/show_bug.cgi?id=244576#c48 shows that for
example the nForce2 integrated FireWire controller seems to have it on
by default.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Supersedes patch "fw-ohci: clear LinkControl register when enabling the
chip".  Changed from ~0 to OHCI1394_LinkControl_rcvPhyPkt bit only.

 drivers/firewire/fw-ohci.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1473,6 +1473,8 @@ static int ohci_enable(struct fw_card *c
 	reg_write(ohci, OHCI1394_HCControlClear,
 		  OHCI1394_HCControl_noByteSwapData);
 
+	reg_write(ohci, OHCI1394_LinkControlClear,
+		  OHCI1394_LinkControl_rcvPhyPkt);
 	reg_write(ohci, OHCI1394_LinkControlSet,
 		  OHCI1394_LinkControl_rcvSelfID |
 		  OHCI1394_LinkControl_cycleTimerEnable |

-- 
Stefan Richter
-=====-==--- -==- --=-=
http://arcgraph.de/sr/

