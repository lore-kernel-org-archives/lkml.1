Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZJNSjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZJNSjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZJNSjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:39:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54580 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbZJNSjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:39:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Oct 2009 20:37:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: core: WARN on wrong usage of core transaction
 functions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.97d03c31313cb391@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the code path which creates request packets, clearly mark a switch
branch which must never be reached with a WARN.

In the code path which creates response packets, replace a BUG by a
friendlier to debug WARN.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-transaction.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-transaction.c
+++ linux-2.6.31/drivers/firewire/core-transaction.c
@@ -218,6 +218,9 @@ static void fw_fill_request(struct fw_pa
 		packet->header_length = 16;
 		packet->payload_length = 0;
 		break;
+
+	default:
+		WARN(1, KERN_ERR "wrong tcode %d", tcode);
 	}
  common:
 	packet->speed = speed;
@@ -595,8 +598,7 @@ void fw_fill_response(struct fw_packet *
 		break;
 
 	default:
-		BUG();
-		return;
+		WARN(1, KERN_ERR "wrong tcode %d", tcode);
 	}
 
 	response->payload_bus = 0;

-- 
Stefan Richter
-=====-==--= =-=- -===-
http://arcgraph.de/sr/

