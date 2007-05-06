Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXEFX14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXEFX14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXEFX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:27:56 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39298 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXEFX1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:27:55 -0400
Date: Mon, 7 May 2007 01:27:41 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Thomas Meyer <thomas@m3y3r.de>, Greg KH <gregkh@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Appletouch is gone!
In-Reply-To: <46398A14.6060801@m3y3r.de>
Message-ID: <Pine.LNX.4.64.0705070059200.16923@twin.jikos.cz>
References: <46398A14.6060801@m3y3r.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Thomas Meyer wrote:

> With current git head from linus' tree and LOCALVERSION_AUTO [=y] and 
> USB_APPLETOUCH [=m]
> find /lib/modules/ -name apple*
> /lib/modules/2.6.20/kernel/drivers/usb/input/appletouch.ko
> /lib/modules/2.6.21/kernel/drivers/usb/input/appletouch.ko

This doesn't seem to be a bug specific to current state of the git tree. 
You probably previously had .config which selected some other driver from 
drivers/usb/input and therefore build system correctly descended into it. 
The patch below should solve your issue.

Greg, could you please take it through your tree? Thanks.



From: Jiri Kosina <jkosina@suse.cz>

USB: add forgotten values to Makefile
    
There are several CONFIG_ values related to drivers/usb/input directory
that are missing in drivers/usb/Makefile, and therefore they are not
sufficient to cause Kbuild to recurse into input/ subdirectory when they
are set.
    
Add missing values.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index f5de58a..18ef432 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -25,12 +25,18 @@ obj-$(CONFIG_USB)		+= storage/
 
 obj-$(CONFIG_USB_ACECAD)	+= input/
 obj-$(CONFIG_USB_AIPTEK)	+= input/
+obj-$(CONFIG_USB_APPLETOUCH)	+= input/
 obj-$(CONFIG_USB_ATI_REMOTE)	+= input/
+obj-$(CONFIG_USB_ATI_REMOTE2)	+= input/
+obj-$(CONFIG_USB_GTCO)		+= input/
 obj-$(CONFIG_USB_KBTAB)		+= input/
+obj-$(CONFIG_USB_KEYSPAN_REMOTE)	+= input/
 obj-$(CONFIG_USB_MTOUCH)	+= input/
 obj-$(CONFIG_USB_POWERMATE)	+= input/
+obj-$(CONFIG_USB_TOUCHSCREEN)	+= input/
 obj-$(CONFIG_USB_WACOM)		+= input/
 obj-$(CONFIG_USB_XPAD)		+= input/
+obj-$(CONFIG_USB_YEALINK)	+= input/
 
 obj-$(CONFIG_USB_CATC)		+= net/
 obj-$(CONFIG_USB_KAWETH)	+= net/
