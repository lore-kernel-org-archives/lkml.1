Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbYB2RY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbYB2RY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYB2RYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:24:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:26423 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbYB2RYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:24:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ml4p1y5haDT/ldp9drwO0E1WufqHWX1fotyLkDf9YL7BzCjQCmBleyegSSGqI5S0Jsn6tlAWspH1B2OY7vEejylS4NNXSUB99LYK0GDcEZAc3N7PNqIrIURxOvSC6eB6DnI835TP6N5AY0YdSewk7uGpociGCq6GRO4Fa11edxg=
Message-ID: <847993120802290924m6b12567p964a17e080030889@mail.gmail.com>
Date: Fri, 29 Feb 2008 10:24:44 -0700
From: "Craig Kelley" <namonai@gmail.com>
To: mhoffman@lightlink.com
Subject: [patch 1/1] hwmon: add 0x8c id for smsc47b397 driver
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Craig Kelley <namonai@gmail.com>

Added a new ID (0x8c) for the smsc47b397 hardware monitor driver.
This ID is used by HP in, at least, their dc7700 line.

Signed-off-by: Craig Kelley <namonai@gmail.com>
---

--- drivers/hwmon/smsc47b397.c-orig     2008-02-29 07:54:18.000000000 -0800
+++ drivers/hwmon/smsc47b397.c  2008-02-29 07:53:00.000000000 -0800
@@ -331,11 +331,23 @@ exit:
 static int __init smsc47b397_find(unsigned short *addr)
 {
        u8 id, rev;
+       char *name;

        superio_enter();
        id = superio_inb(SUPERIO_REG_DEVID);

-       if ((id != 0x6f) && (id != 0x81) && (id != 0x85)) {
+       switch(id) {
+       case 0x81:
+               name = "SCH5307-NS";
+               break;
+       case 0x6f:
+               name = "LPC47B397-NC";
+               break;
+       case 0x85:
+       case 0x8c:
+               name = "SCH5317";
+               break;
+       default:
                superio_exit();
                return -ENODEV;
        }
@@ -348,8 +360,7 @@ static int __init smsc47b397_find(unsign

        printk(KERN_INFO DRVNAME ": found SMSC %s "
                "(base address 0x%04x, revision %u)\n",
-               id == 0x81 ? "SCH5307-NS" : id == 0x85 ? "SCH5317" :
-              "LPC47B397-NC", *addr, rev);
+               name, *addr, rev);

        superio_exit();
        return 0;
