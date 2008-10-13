Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYJMJgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYJMJgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758438AbYJMJeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:34:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56136 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759222AbYJMJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:34:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/80] Fix oti6858 debug level
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:34:00 +0100
Message-ID: <20081013093356.21645.82633.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Ashcroft <scott.ashcroft@talk21.com>

For some reason the oti6858 driver undefines and redefines the dbg
macro. This makes it spew debugging messages at KERN_INFO instead of
KERN_DEBUG.

This patch removes the undef and define making the driver log like every
other USB serial driver.

Signed-off-by: Scott Ashcroft <scott.ashcroft@talk21.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/oti6858.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)


diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 81db571..42f9281 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -224,10 +224,6 @@ struct oti6858_private {
 	struct usb_serial_port *port;   /* USB port with which associated */
 };
 
-#undef dbg
-/* #define dbg(format, arg...) printk(KERN_INFO "%s: " format "\n", __FILE__, ## arg) */
-#define dbg(format, arg...) printk(KERN_INFO "" format "\n", ## arg)
-
 static void setup_line(struct work_struct *work)
 {
 	struct oti6858_private *priv = container_of(work,

