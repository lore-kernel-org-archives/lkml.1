Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbXJASlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbXJASlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXJASla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:41:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60765 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXJASl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:41:29 -0400
Date: Mon, 1 Oct 2007 13:41:15 -0500
To: linux-pcmcia@lists.infradead.org, Dominik Brodowski <linux@brodo.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Simplify yenta code
Message-ID: <20071001184115.GB4338@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Simplify some of the resource detection logic in yenta_socket.
This patch results in the same run-time behaviour as the 
current code, but does so with fewer lines of code. This
makes the logical flow of the code a bit easier to understand.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: Dominik Brodowski <linux@brodo.de>

----
 drivers/pcmcia/yenta_socket.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

Index: linux-2.6.23-rc8-mm1/drivers/pcmcia/yenta_socket.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/drivers/pcmcia/yenta_socket.c	2007-10-01 12:17:02.000000000 -0500
+++ linux-2.6.23-rc8-mm1/drivers/pcmcia/yenta_socket.c	2007-10-01 12:37:36.000000000 -0500
@@ -654,20 +654,14 @@ static int yenta_allocate_res(struct yen
 				pci_name(socket->dev), nr);
 	}
 
-	if (type & IORESOURCE_IO) {
-		if ((yenta_search_res(socket, res, BRIDGE_IO_MAX)) ||
-		    (yenta_search_res(socket, res, BRIDGE_IO_ACC)) ||
-		    (yenta_search_res(socket, res, BRIDGE_IO_MIN)))
-			return 1;
-	} else {
-		if (type & IORESOURCE_PREFETCH) {
-			if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
-			    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
-			    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
-				return 1;
-			/* Approximating prefetchable by non-prefetchable */
-			res->flags = IORESOURCE_MEM;
-		}
+	if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
+	    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
+	    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
+		return 1;
+
+	if (type & IORESOURCE_PREFETCH) {
+		/* Approximating prefetchable by non-prefetchable */
+		res->flags = IORESOURCE_MEM;
 		if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
 		    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
 		    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
