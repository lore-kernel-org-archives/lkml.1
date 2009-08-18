Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZHRXjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZHRXjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZHRXjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:39:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZHRXjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:39:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC][PATCH 7/7] PM: Asynchronous suspend and resume of i8042
Date: Wed, 19 Aug 2009 01:40:26 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <1250579010.5351.69.camel@rzhang-dt> <200908182157.53283.rjw@sisk.pl>
In-Reply-To: <200908182157.53283.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908190140.26730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Rafael J. Wysocki wrote:
> On Tuesday 18 August 2009, Zhang Rui wrote:
> > On Mon, 2009-08-17 at 08:21 +0800, Rafael J. Wysocki wrote:
> > > Set async_suspend for i8042.
> > > 
> > it's the psmouse reset that takes the 0.4 seconds during suspend.
> > ﻿so we should call device_enable_async_suspend for the psmouse serio
> > device in psmouse-base.c
> > 
> > Or invoking device_enable_async_suspend for every serio device in
> > serio.c, as the keyboard also takes about 0.2s to suspend.
> 
> Yes we can do that.  I'll test that later today.

The appended patch appears to work on my test box.

Thanks,
Rafael

---
Set async_suspend for serio input devices.

---
 drivers/input/serio/serio.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/input/serio/serio.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/serio.c
+++ linux-2.6/drivers/input/serio/serio.c
@@ -576,6 +576,7 @@ static void serio_add_port(struct serio 
 			printk(KERN_ERR
 				"serio: sysfs_create_group() failed for %s (%s), error: %d\n",
 				serio->phys, serio->name, error);
+		device_enable_async_suspend(&serio->dev, true);
 	}
 }
 
