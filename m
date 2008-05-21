Return-Path: <linux-kernel-owner+w=401wt.eu-S936453AbYEURv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936453AbYEURv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763664AbYEURvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:51:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60466 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755855AbYEURvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:51:18 -0400
Date: Wed, 21 May 2008 13:51:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
cc: Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@sunset.davemloft.net>,
       <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-cifs-client@lists.samba.org>, <linux-nfs@vger.kernel.org>
Subject: [PATCH] usb-storage: don't call utsname()
In-Reply-To: <20080521123700.GA8770@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0805211349480.3409-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1100) replaces the core-kernel function call to utsname()
in usb-storage with the UTS_RELEASE macro.  It's used only for warning
about extra unusual_devs entries.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/usb/storage/usb.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/usb.c
+++ usb-2.6/drivers/usb/storage/usb.c
@@ -53,7 +53,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-#include <linux/utsname.h>
+#include <linux/utsrelease.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -531,8 +531,8 @@ static int get_device_info(struct us_dat
 		if (msg >= 0 && !(us->fflags & US_FL_NEED_OVERRIDE))
 			printk(KERN_NOTICE USB_STORAGE "This device "
 				"(%04x,%04x,%04x S %02x P %02x)"
-				" has %s in unusual_devs.h (kernel"
-				" %s)\n"
+				" has %s in unusual_devs.h (kernel "
+				UTS_RELEASE ")\n"
 				"   Please send a copy of this message to "
 				"<linux-usb@vger.kernel.org> and "
 				"<usb-storage@lists.one-eyed-alien.net>\n",
@@ -541,8 +541,7 @@ static int get_device_info(struct us_dat
 				le16_to_cpu(ddesc->bcdDevice),
 				idesc->bInterfaceSubClass,
 				idesc->bInterfaceProtocol,
-				msgs[msg],
-				utsname()->release);
+				msgs[msg]);
 	}
 
 	return 0;

