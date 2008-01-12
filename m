Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbYALUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbYALUM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762224AbYALUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:12:48 -0500
Received: from mail.queued.net ([207.210.101.209]:3725 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762171AbYALUMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:12:47 -0500
Date: Sat, 12 Jan 2008 15:13:07 -0500
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] input: check return value of input_register_device() in
 hil_ptr.c's init
Message-ID: <20080112151307.62cd958e@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/hil_ptr.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/hil_ptr.c b/drivers/input/mouse/hil_ptr.c
index 27f88fb..de8b836 100644
--- a/drivers/input/mouse/hil_ptr.c
+++ b/drivers/input/mouse/hil_ptr.c
@@ -380,7 +380,10 @@ static int hil_ptr_connect(struct serio *serio, struct serio_driver *driver)
 	ptr->dev->id.version	= 0x0100; /* TODO: get from ptr->rsc */
 	ptr->dev->dev.parent	= &serio->dev;
 
-	input_register_device(ptr->dev);
+	if (input_register_device(ptr->dev)) {
+		printk(KERN_INFO PREFIX "Unable to register input device\n");
+		goto bail2;
+	}
 	printk(KERN_INFO "input: %s (%s), ID: %d\n",
 		ptr->dev->name,
 		(btntype == BTN_MOUSE) ? "HIL mouse":"HIL tablet or touchpad",
-- 
1.5.3.5

