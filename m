Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYJ0W1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYJ0W1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYJ0W0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:26:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51168 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJ0W0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:26:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 23:26:35 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2.6.27.y 2/6] firewire: fix ioctl() return code
To: stable@kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
Message-ID: <tkrat.509dbd5216c80cfd@s5r6.in-berlin.de>
References: <tkrat.df6e0a4afb92ef6e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Fri, 12 Sep 2008 18:20:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Reported by Jay Fenlason:  ioctl() did not return as intended
  - the size of data read into ioctl_send_request,
  - the number of datagrams enqueued by ioctl_queue_iso.

Same as commit 99692f71ee04c6f249d0bf6a581359f32f409a38.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -913,7 +913,7 @@ dispatch_ioctl(struct client *client, un
 			return -EFAULT;
 	}
 
-	return 0;
+	return retval;
 }
 
 static long

-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/

