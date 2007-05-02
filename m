Return-Path: <linux-kernel-owner+w=401wt.eu-S1767192AbXEBXBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767192AbXEBXBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767193AbXEBXBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:01:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47863 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767192AbXEBXBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:01:34 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46391834.2050209@s5r6.in-berlin.de>
Date: Thu, 03 May 2007 01:01:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 6/6] firewire: add it all to kbuild
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <tkrat.abd13e310a4516c7@s5r6.in-berlin.de> <20070502194442.GE1248@infradead.org>
In-Reply-To: <20070502194442.GE1248@infradead.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> +fw-core-objs := fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
>> +	fw-device.o fw-cdev.o
> 
> fw-core-y += ..
> 

Like such?

--- linux.orig/drivers/usb/core/Makefile
+++ linux/drivers/usb/core/Makefile
@@ -2,17 +2,12 @@
 # Makefile for USB Core files and filesystem
 #

-usbcore-objs	:= usb.o hub.o hcd.o urb.o message.o driver.o \
+usbcore-y	+= usb.o hub.o hcd.o urb.o message.o driver.o \
 			config.o file.o buffer.o sysfs.o endpoint.o \
 			devio.o notify.o generic.o quirks.o

-ifeq ($(CONFIG_PCI),y)
-	usbcore-objs	+= hcd-pci.o
-endif
-
-ifeq ($(CONFIG_USB_DEVICEFS),y)
-	usbcore-objs	+= inode.o devices.o
-endif
+usbcore-$(CONFIG_PCI)		+= hcd-pci.o
+usbcore-$(CONFIG_USB_DEVICEFS)	+= inode.o devices.o

 obj-$(CONFIG_USB)	+= usbcore.o


-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
