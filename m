Return-Path: <linux-kernel-owner+w=401wt.eu-S1762550AbXJMV37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762550AbXJMV37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 17:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbXJMV3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 17:29:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39157 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbXJMV3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 17:29:50 -0400
Date: Sat, 13 Oct 2007 22:29:47 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gregkh@suse.de, mb@bu3sch.de, linux-kernel@vger.kernel.org
Subject: [PATCH] ohci-ssb with !CONFIG_PM
Message-ID: <20071013212947.GO8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	ohci_bus_{suspend,resume} exists only if we have CONFIG_PM;
do the same thing as other subdrivers...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
b0b4f616f9ca381aa6a8559923137ce7cadc4108
diff --git a/drivers/usb/host/ohci-ssb.c b/drivers/usb/host/ohci-ssb.c
index bc3e785..fe70e72 100644
--- a/drivers/usb/host/ohci-ssb.c
+++ b/drivers/usb/host/ohci-ssb.c
@@ -117,8 +117,10 @@ static const struct hc_driver ssb_ohci_hc_driver = {
 	.hub_status_data	= ohci_hub_status_data,
 	.hub_control		= ohci_hub_control,
 	.hub_irq_enable		= ohci_rhsc_enable,
+#ifdef	CONFIG_PM
 	.bus_suspend		= ohci_bus_suspend,
 	.bus_resume		= ohci_bus_resume,
+#endif
 
 	.start_port_reset	= ohci_start_port_reset,
 };
