Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZDHWbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZDHWbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZDHWbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:31:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41176 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751676AbZDHWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:31:41 -0400
Date: Wed, 8 Apr 2009 18:31:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: usb-storage@lists.one-eyed-alien.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: usual_tables: module license 'unspecified' taints kernel.
In-Reply-To: <49DCD481.1050104@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.44L0.0904081829050.3138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009, Alan Jenkins wrote:

> Hi, I see this regression in v2.6.30-rc1.  I end up with a module 
> "usual_tables.ko", which is loaded on boot and causes the kernel to 
> complain about an unspecified license.  See subject for the exact error 
> message.
> 
> I have
> 
> CONFIG_USB_STORAGE=m
> CONFIG_USB_LIBUSUAL=y

This looks like a mistake in the Makefile.  Does the patch below fix
the problem?

Alan Stern


Index: usb-2.6/drivers/usb/storage/Makefile
===================================================================
--- usb-2.6.orig/drivers/usb/storage/Makefile
+++ usb-2.6/drivers/usb/storage/Makefile
@@ -17,7 +17,8 @@ usb-storage-objs :=	scsiglue.o protocol.
 ifeq ($(CONFIG_USB_LIBUSUAL),)
 	usb-storage-objs	+= usual-tables.o
 else
-	obj-$(CONFIG_USB)	+= libusual.o usual-tables.o
+	obj-$(CONFIG_USB)	+= usb-libusual.o
+	usb-libusual-objs	:= libusual.o usual-tables.o
 endif
 
 obj-$(CONFIG_USB_STORAGE_ALAUDA)	+= ums-alauda.o

