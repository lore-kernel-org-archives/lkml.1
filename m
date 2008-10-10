Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYJJKvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYJJKvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbYJJKtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:49:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47569 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757879AbYJJKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:49:39 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 13/27] Fix oti6858 debug level
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:49:36 +0100
Message-ID: <20081010104928.31597.32630.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
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

