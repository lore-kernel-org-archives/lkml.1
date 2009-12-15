Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbZLOV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbZLOV4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbZLOV4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:56:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933758AbZLOV4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Allow serio input devices to suspend/resume asynchronously (was: Re: [PATCH 0/5] Async suspend/resume tree)
Date: Tue, 15 Dec 2009 22:56:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200912132338.30921.rjw@sisk.pl>
In-Reply-To: <200912132338.30921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912152256.33605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just added the following patch to the async branch at:
http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/async

It has been discussed with Dmitry who says he's fine with it.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Allow serio input devices to suspend/resume asynchronously

Set async_suspend for all serio input devices, so that they can be
suspended and resumed asynchronously with other devices they don't
depend on in a known way (i.e. devices which are not their parents
or children).

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
 
