Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYDJWt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYDJWt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYDJWtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:49:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55050 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYDJWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:49:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 11 Apr 2008 00:49:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: fw-ohci: fix debug logging of phy packets
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f3c267b896f5d604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix harmless but irritating off-by-one bug in patch "firewire: debug
interrupt events".  Should be folded into that one.

See OHCI 1.1 clause 8.7.1.4.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -371,10 +371,10 @@ static void log_ar_at_event(char dir, in
 	if (unlikely(evt >= ARRAY_SIZE(evts)))
 			evt = 0x1f;
 
-	if (header[0] == ~header[1]) {
+	if (header[1] == ~header[2]) {
 		printk(KERN_DEBUG "A%c %s, %s, %08x\n",
-		       dir, evts[evt], phys[header[0] >> 30 & 0x3],
-		       header[0]);
+		       dir, evts[evt], phys[header[1] >> 30 & 0x3],
+		       header[1]);
 		return;
 	}
 

-- 
Stefan Richter
-=====-==--- -=-- -=-==
http://arcgraph.de/sr/

