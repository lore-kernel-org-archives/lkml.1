Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZHZU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZHZU1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZHZU1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:27:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35954 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZHZU1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:27:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/6] PM: Allow serio input devices to suspend/resume asynchronously
Date: Wed, 26 Aug 2009 22:24:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl>
In-Reply-To: <200908262217.19609.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262224.19110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Set async_suspend for all serio input devices, so that they can be
suspended and resumed asynchronously with other devices they don't
depend on in a known way (i.e. devices which are not their parents
or children and to which they are not connected via struct pm_link
objects).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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
 

