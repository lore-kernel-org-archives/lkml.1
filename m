Return-Path: <linux-kernel-owner+w=401wt.eu-S1765491AbYBUQWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765491AbYBUQWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbYBUQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:21:56 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26239 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbYBUQVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:21:55 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: PNP: skip dev->protocol NULL checks
Date: Thu, 21 Feb 2008 09:15:39 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adam Belay <ambx1@neo.rr.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Rene Herman <rene.herman@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210915.40519.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every PNP device should have a valid protocol pointer.  If it doesn't,
something's wrong and we should oops so we can find and fix the problem.

[This fixes a Coverity warning, but does not need to be in 2.6.25.
I'd rather have it in -mm for a while and put it in 2.6.26.]

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work6/drivers/pnp/driver.c
===================================================================
--- work6.orig/drivers/pnp/driver.c	2008-02-20 09:46:01.000000000 -0700
+++ work6/drivers/pnp/driver.c	2008-02-20 09:46:28.000000000 -0700
@@ -167,7 +167,7 @@
 			return error;
 	}
 
-	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
+	if (pnp_dev->protocol->suspend)
 		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
 }
@@ -181,7 +181,7 @@
 	if (!pnp_drv)
 		return 0;
 
-	if (pnp_dev->protocol && pnp_dev->protocol->resume)
+	if (pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
 	if (pnp_can_write(pnp_dev)) {
