Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYFNMYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYFNMYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYFNMXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:23:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56913 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYFNMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:23:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Jun 2008 14:23:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: unify printk prefixes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.a94db08267f5b484@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The messages which can be enabled by fw-ohci's debug module parameter
are changed from KERN_DEBUG to KERN_NOTICE level and uniformly prefixed
with "firewire_ohci: ".  This further simplifies communication with
users when we ask them to capture debug messages.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |  101 +++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 53 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -265,27 +265,25 @@ static void log_irqs(u32 evt)
 	    !(evt & OHCI1394_busReset))
 		return;
 
-	printk(KERN_DEBUG KBUILD_MODNAME ": IRQ "
-	       "%08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
-	       evt,
-	       evt & OHCI1394_selfIDComplete	? " selfID"		: "",
-	       evt & OHCI1394_RQPkt		? " AR_req"		: "",
-	       evt & OHCI1394_RSPkt		? " AR_resp"		: "",
-	       evt & OHCI1394_reqTxComplete	? " AT_req"		: "",
-	       evt & OHCI1394_respTxComplete	? " AT_resp"		: "",
-	       evt & OHCI1394_isochRx		? " IR"			: "",
-	       evt & OHCI1394_isochTx		? " IT"			: "",
-	       evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
-	       evt & OHCI1394_cycleTooLong	? " cycleTooLong"	: "",
-	       evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
-	       evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
-	       evt & OHCI1394_busReset		? " busReset"		: "",
-	       evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
-		       OHCI1394_RSPkt | OHCI1394_reqTxComplete |
-		       OHCI1394_respTxComplete | OHCI1394_isochRx |
-		       OHCI1394_isochTx | OHCI1394_postedWriteErr |
-		       OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
-		       OHCI1394_regAccessFail | OHCI1394_busReset)
+	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
+	    evt & OHCI1394_selfIDComplete	? " selfID"		: "",
+	    evt & OHCI1394_RQPkt		? " AR_req"		: "",
+	    evt & OHCI1394_RSPkt		? " AR_resp"		: "",
+	    evt & OHCI1394_reqTxComplete	? " AT_req"		: "",
+	    evt & OHCI1394_respTxComplete	? " AT_resp"		: "",
+	    evt & OHCI1394_isochRx		? " IR"			: "",
+	    evt & OHCI1394_isochTx		? " IT"			: "",
+	    evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
+	    evt & OHCI1394_cycleTooLong		? " cycleTooLong"	: "",
+	    evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
+	    evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
+	    evt & OHCI1394_busReset		? " busReset"		: "",
+	    evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
+		    OHCI1394_RSPkt | OHCI1394_reqTxComplete |
+		    OHCI1394_respTxComplete | OHCI1394_isochRx |
+		    OHCI1394_isochTx | OHCI1394_postedWriteErr |
+		    OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
+		    OHCI1394_regAccessFail | OHCI1394_busReset)
 						? " ?"			: "");
 }
 
@@ -308,23 +306,22 @@ static void log_selfids(int node_id, int
 	if (likely(!(param_debug & OHCI_PARAM_DEBUG_SELFIDS)))
 		return;
 
-	printk(KERN_DEBUG KBUILD_MODNAME ": %d selfIDs, generation %d, "
-	       "local node ID %04x\n", self_id_count, generation, node_id);
+	fw_notify("%d selfIDs, generation %d, local node ID %04x\n",
+		  self_id_count, generation, node_id);
 
 	for (; self_id_count--; ++s)
 		if ((*s & 1 << 23) == 0)
-			printk(KERN_DEBUG "selfID 0: %08x, phy %d [%c%c%c] "
-			       "%s gc=%d %s %s%s%s\n",
-			       *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
-			       speed[*s >> 14 & 3], *s >> 16 & 63,
-			       power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
-			       *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "");
+			fw_notify("selfID 0: %08x, phy %d [%c%c%c] "
+			    "%s gc=%d %s %s%s%s\n",
+			    *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
+			    speed[*s >> 14 & 3], *s >> 16 & 63,
+			    power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
+			    *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "");
 		else
-			printk(KERN_DEBUG "selfID n: %08x, phy %d "
-			       "[%c%c%c%c%c%c%c%c]\n",
-			       *s, *s >> 24 & 63,
-			       _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
-			       _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2));
+			fw_notify("selfID n: %08x, phy %d [%c%c%c%c%c%c%c%c]\n",
+			    *s, *s >> 24 & 63,
+			    _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
+			    _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2));
 }
 
 static const char *evts[] = {
@@ -373,15 +370,14 @@ static void log_ar_at_event(char dir, in
 			evt = 0x1f;
 
 	if (evt == OHCI1394_evt_bus_reset) {
-		printk(KERN_DEBUG "A%c evt_bus_reset, generation %d\n",
-		       dir, (header[2] >> 16) & 0xff);
+		fw_notify("A%c evt_bus_reset, generation %d\n",
+		    dir, (header[2] >> 16) & 0xff);
 		return;
 	}
 
 	if (header[0] == ~header[1]) {
-		printk(KERN_DEBUG "A%c %s, %s, %08x\n",
-		       dir, evts[evt], phys[header[0] >> 30 & 0x3],
-		       header[0]);
+		fw_notify("A%c %s, %s, %08x\n",
+		    dir, evts[evt], phys[header[0] >> 30 & 0x3], header[0]);
 		return;
 	}
 
@@ -400,24 +396,23 @@ static void log_ar_at_event(char dir, in
 
 	switch (tcode) {
 	case 0xe: case 0xa:
-		printk(KERN_DEBUG "A%c %s, %s\n",
-		       dir, evts[evt], tcodes[tcode]);
+		fw_notify("A%c %s, %s\n", dir, evts[evt], tcodes[tcode]);
 		break;
 	case 0x0: case 0x1: case 0x4: case 0x5: case 0x9:
-		printk(KERN_DEBUG "A%c spd %x tl %02x, "
-		       "%04x -> %04x, %s, "
-		       "%s, %04x%08x%s\n",
-		       dir, speed, header[0] >> 10 & 0x3f,
-		       header[1] >> 16, header[0] >> 16, evts[evt],
-		       tcodes[tcode], header[1] & 0xffff, header[2], specific);
+		fw_notify("A%c spd %x tl %02x, "
+		    "%04x -> %04x, %s, "
+		    "%s, %04x%08x%s\n",
+		    dir, speed, header[0] >> 10 & 0x3f,
+		    header[1] >> 16, header[0] >> 16, evts[evt],
+		    tcodes[tcode], header[1] & 0xffff, header[2], specific);
 		break;
 	default:
-		printk(KERN_DEBUG "A%c spd %x tl %02x, "
-		       "%04x -> %04x, %s, "
-		       "%s%s\n",
-		       dir, speed, header[0] >> 10 & 0x3f,
-		       header[1] >> 16, header[0] >> 16, evts[evt],
-		       tcodes[tcode], specific);
+		fw_notify("A%c spd %x tl %02x, "
+		    "%04x -> %04x, %s, "
+		    "%s%s\n",
+		    dir, speed, header[0] >> 10 & 0x3f,
+		    header[1] >> 16, header[0] >> 16, evts[evt],
+		    tcodes[tcode], specific);
 	}
 }
 

-- 
Stefan Richter
-=====-==--- -==- -===-
http://arcgraph.de/sr/

