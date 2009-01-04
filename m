Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZADPbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZADPbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZADPax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:30:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44105 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZADPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:30:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:30:32 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 10/11] firewire: cdev: extend transaction payload size check
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.660183c8cfc89275@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the size check of ioctl_send_request and
ioctl_send_broadcast_request speed dependent.  Also change the error
return code from -EINVAL to -EIO to distinguish this from other errors
concerning the ioctl parameters.

Another payload size limit for which we don't check here though is the
remote node's Bus_Info_Block.max_rec.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -525,9 +525,8 @@ static int init_request(struct client *c
 	struct outbound_transaction_event *e;
 	int ret;
 
-	/* What is the biggest size we'll accept, really? */
-	if (request->length > 4096)
-		return -EINVAL;
+	if (request->length > 4096 || request->length > 512 << speed)
+		return -EIO;
 
 	e = kmalloc(sizeof(*e) + request->length, GFP_KERNEL);
 	if (e == NULL)

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

