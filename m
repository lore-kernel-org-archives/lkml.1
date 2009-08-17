Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZHQAXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZHQAXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZHQAWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:22:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46005 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbZHQAWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:22:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 7/7] PM: Asynchronous suspend and resume of i8042
Date: Mon, 17 Aug 2009 02:21:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl>
In-Reply-To: <200908170215.21173.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908170221.34885.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set async_suspend for i8042.

---
 drivers/input/serio/i8042.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/input/serio/i8042.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/i8042.c
+++ linux-2.6/drivers/input/serio/i8042.c
@@ -1289,6 +1289,8 @@ static int __init i8042_init(void)
 	if (err)
 		goto err_free_device;
 
+	device_enable_async_suspend(&i8042_platform_device->dev, true);
+
 	panic_blink = i8042_panic_blink;
 
 	return 0;
