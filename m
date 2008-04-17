Return-Path: <linux-kernel-owner+w=401wt.eu-S934010AbYDQR42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbYDQR42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761554AbYDQR4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:56:18 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:36141 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761481AbYDQR4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:56:17 -0400
Message-ID: <48078F3D.80704@tiscali.nl>
Date: Thu, 17 Apr 2008 19:56:13 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ehci-dbg: evaluate negative snprintf() retvals in qh_lines()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only when signed, a snprintf() retval below zero can be evaluated.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index 64ebfc5..25a98c1 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -394,7 +394,7 @@ static void qh_lines (
 	u32			hw_curr;
 	struct list_head	*entry;
 	struct ehci_qtd		*td;
-	unsigned		temp;
+	int			temp;
 	unsigned		size = *sizep;
 	char			*next = *nextp;
 	char			mark;
@@ -459,9 +459,9 @@ static void qh_lines (
 		else if (size < temp)
 			temp = size;
 		size -= temp;
-		next += temp;
 		if (temp == size)
 			goto done;
+		next += temp;
 	}
 
 	temp = snprintf (next, size, "\n");
@@ -470,11 +470,10 @@ static void qh_lines (
 	else if (size < temp)
 		temp = size;
 	size -= temp;
-	next += temp;
 
 done:
 	*sizep = size;
-	*nextp = next;
+	*nextp = next + temp;
 }
 
 static ssize_t fill_async_buffer(struct debug_buffer *buf)
