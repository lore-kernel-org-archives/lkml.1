Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843Ab0B0Uk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:40:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55655 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030794Ab0B0Uk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:40:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Driver core: Reduce the level of request_firmware() messages
Date: Sat, 27 Feb 2010 21:43:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002272143.22156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The messages from _request_firmware() informing that firmware is
being requested or built-in firmware is going to be used are printed
at KERN_INFO, which produces lots of noise on systems with huge
numbers of AMD CPUs.  Reduce the level of these messages to
KERN_DEBUG to get rid of that noise.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.32-SLE11-SP1/drivers/base/firmware_class.c
===================================================================
--- linux-2.6.32-SLE11-SP1.orig/drivers/base/firmware_class.c
+++ linux-2.6.32-SLE11-SP1/drivers/base/firmware_class.c
@@ -487,15 +487,14 @@ _request_firmware(const struct firmware 
 	     builtin++) {
 		if (strcmp(name, builtin->name))
 			continue;
-		dev_info(device, "firmware: using built-in firmware %s\n",
-			 name);
+		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
 		firmware->size = builtin->size;
 		firmware->data = builtin->data;
 		return 0;
 	}
 
 	if (uevent)
-		dev_info(device, "firmware: requesting %s\n", name);
+		dev_dbg(device, "firmware: requesting %s\n", name);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)
