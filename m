Return-Path: <linux-kernel-owner+w=401wt.eu-S1751465AbZBPWnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbZBPWnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZBPWmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:42:54 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58876 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZBPWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:42:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Feb 2009 23:42:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: remove superfluous assertions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.351fd9f1c4787166@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsb_read, hpsb_write, hpsb_lock are sleeping functions which nobody is
in danger to use in atomic context.  Besides, in_interrupt does not
cover all types of atomic context.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ieee1394_transactions.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/drivers/ieee1394/ieee1394_transactions.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_transactions.c
+++ linux/drivers/ieee1394/ieee1394_transactions.c
@@ -501,8 +501,6 @@ int hpsb_read(struct hpsb_host *host, no
 	if (length == 0)
 		return -EINVAL;
 
-	BUG_ON(in_interrupt());	// We can't be called in an interrupt, yet
-
 	packet = hpsb_make_readpacket(host, node, addr, length);
 
 	if (!packet) {
@@ -550,8 +548,6 @@ int hpsb_write(struct hpsb_host *host, n
 	if (length == 0)
 		return -EINVAL;
 
-	BUG_ON(in_interrupt());	// We can't be called in an interrupt, yet
-
 	packet = hpsb_make_writepacket(host, node, addr, buffer, length);
 
 	if (!packet)
@@ -577,8 +573,6 @@ int hpsb_lock(struct hpsb_host *host, no
 	struct hpsb_packet *packet;
 	int retval = 0;
 
-	BUG_ON(in_interrupt());
-
 	packet = hpsb_make_lockpacket(host, node, addr, extcode, data, arg);
 	if (!packet)
 		return -ENOMEM;

-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/

