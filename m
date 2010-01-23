Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498Ab0AWXmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0AWXmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 18:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164Ab0AWXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 18:42:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0AWXmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 18:42:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] PM: Add parent information to timing messages
Date: Sun, 24 Jan 2010 00:34:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux SCSI <linux-scsi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
References: <201001240033.34253.rjw@sisk.pl>
In-Reply-To: <201001240033.34253.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001240034.36423.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add parent information to the messages printed by the suspend/resume
core when initcall_debug is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -271,8 +271,9 @@ static int pm_noirq_op(struct device *de
 	ktime_t calltime, delta, rettime;
 
 	if (initcall_debug) {
-		pr_info("calling  %s_i+ @ %i\n",
-				dev_name(dev), task_pid_nr(current));
+		pr_info("calling  %s+ @ %i, parent: %s\n",
+				dev_name(dev), task_pid_nr(current),
+				dev->parent ? dev_name(dev->parent) : "none");
 		calltime = ktime_get();
 	}
 

