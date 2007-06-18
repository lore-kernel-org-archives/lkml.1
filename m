Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXFRVFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXFRVFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbXFRVDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:03:48 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:52763 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090AbXFRVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:03:44 -0400
Message-Id: <20070618210342.271517227@fluff.org.uk>
References: <20070618205620.284044146@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 21:56:25 +0100
From: ben@fluff.org.uk
To: ben@fluff.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sm5xx-devel@lists.berlios.de
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch #2 5/6] SM501: Add Documentation/SM501.txt
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-docs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the SM501 in Documentation/SM501.txt
outlining the SM501 driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt8/Documentation/SM501.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-quilt8/Documentation/SM501.txt	2007-06-13 13:12:04.000000000 +0100
@@ -0,0 +1,66 @@
+			SM501 Driver
+			============
+
+Copyright 2006, 2007 Simtec Electronics
+
+Core
+----
+
+The core driver in drivers/mfd provides common services for the
+drivers which manage the specific hardware blocks. These services
+include locking for common registers, clock control and resource
+management.
+
+The core registers drivers for both PCI and generic bus based
+chips via the platform device and driver system.
+
+On detection of a device, the core initialises the chip (which may
+be specified by the platform data) and then exports the selected
+peripheral set as platform devices for the specific drivers.
+
+The core re-uses the platform device system as the platform device
+system provides enough features to support the drivers without the
+need to create a new bus-type and the associated code to go with it.
+
+
+Resources
+---------
+
+Each peripheral has a view of the device which is implicitly narrowed to
+the specific set of resources that peripheral requires in order to
+function correctly.
+
+The centralised memory allocation allows the driver to ensure that the
+maximum possible resource allocation can be made to the video subsystem
+as this is by-far the most resource-sensitive of the on-chip functions.
+
+The primary issue with memory allocation is that of moving the video
+buffers once a display mode is chosen. Indeed when a video mode change
+occurs the memory footprint of the video subsystem changes.
+
+Since video memory is difficult to move without changing the display
+(unless sufficient contiguous memory can be provided for the old and new
+modes simultaneously) the video driver fully utilises the memory area
+given to it by aligning fb0 to the start of the area and fb1 to the end
+of it. Any memory left over in the middle is used for the acceleration
+functions, which are transient and thus their location is less critical
+as it can be moved.
+
+
+Configuration
+-------------
+
+The platform device driver uses a set of platform data to pass
+configurations through to the core and the subsidiary drivers
+so that there can be support for more than one system carrying
+an SM501 built into a single kernel image.
+
+The PCI driver assumes that the PCI card behaves as per the Silicon
+Motion reference design.
+
+There is an errata (AB-5) affecting the selection of the
+of the M1XCLK and M1CLK frequencies. These two clocks
+must be sourced from the same PLL, although they can then
+be divided down individually. If this is not set, then SM501 may
+lock and hang the whole system. The driver will refuse to
+attach if the PLL selection is different.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
