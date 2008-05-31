Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYEaRBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYEaRBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 13:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYEaRBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 13:01:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47864 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYEaRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 13:01:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 31 May 2008 19:01:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: don't panic on invalid AR request buffer
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.34bb35c39dcff3ec@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG() at this place is wrong.  (Unless if the low level driver would
already do higher-level input validation of incoming request headers.)

Invalid incoming requests or bugs in the controller which corrupt the
AR-req buffer needlessly crashed the box because this is run in tasklet
context.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -575,7 +575,8 @@ allocate_request(struct fw_packet *p)
 		break;
 
 	default:
-		BUG();
+		fw_error("ERROR - corrupt request received - %08x %08x %08x\n",
+			 p->header[0], p->header[1], p->header[2]);
 		return NULL;
 	}
 

-- 
Stefan Richter
-=====-==--- -=-= =====
http://arcgraph.de/sr/

