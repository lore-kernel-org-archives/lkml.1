Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYJ0W0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYJ0W0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYJ0W0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:26:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51160 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJ0W0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:26:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 23:26:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2.6.27.y 1/6] firewire: fix setting tag and sy in iso
 transmission
To: stable@kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
Message-ID: <tkrat.c6c9e197bd5d3af2@s5r6.in-berlin.de>
References: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Fri, 12 Sep 2008 18:09:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Reported by Jay Fenlason:
The iso packet control accessors in fw-cdev.c had bogus masks.

Same as commit 7a1003449c693f0d57443c8786bbf19717921ae0.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -720,8 +720,8 @@ static int ioctl_create_iso_context(stru
 #define GET_PAYLOAD_LENGTH(v)	((v) & 0xffff)
 #define GET_INTERRUPT(v)	(((v) >> 16) & 0x01)
 #define GET_SKIP(v)		(((v) >> 17) & 0x01)
-#define GET_TAG(v)		(((v) >> 18) & 0x02)
-#define GET_SY(v)		(((v) >> 20) & 0x04)
+#define GET_TAG(v)		(((v) >> 18) & 0x03)
+#define GET_SY(v)		(((v) >> 20) & 0x0f)
 #define GET_HEADER_LENGTH(v)	(((v) >> 24) & 0xff)
 
 static int ioctl_queue_iso(struct client *client, void *buffer)

-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/

