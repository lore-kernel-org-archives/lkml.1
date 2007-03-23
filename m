Return-Path: <linux-kernel-owner+w=401wt.eu-S934047AbXCWKOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbXCWKOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934046AbXCWKOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:14:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59108 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934047AbXCWKOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:14:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 23 Mar 2007 11:14:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 fix
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.b2b116c1f23637be@s5r6.in-berlin.de>
Message-ID: <tkrat.c0b0fd71777944c3@s5r6.in-berlin.de>
References: <tkrat.792fbaf365daed11@s5r6.in-berlin.de>
 <tkrat.b2b116c1f23637be@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the appended fix for 2.6.21-rc4. Or apply from this mail.
Thanks.

(The eth1394 issue will be revised as soon as ieee1394 core got rid of
class_Device.)

 drivers/ieee1394/eth1394.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Stefan Richter (1):
      ieee1394: fix oops on "modprobe -r ohci1394" after network class_device conversion



>From 7a9eeb2fa1b3a3a83670b9ba08dd396beedb88f8 Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Tue, 20 Mar 2007 22:43:22 +0100
Subject: [PATCH] ieee1394: fix oops on "modprobe -r ohci1394" after network class_device conversion
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The networking subsystem has been converted from class_device to device
but ieee1394 hasn't.  This results in a 100% reproducible NULL pointer
dereference if the ohci1394 driver module is unloaded while the eth1394
module is still loaded.
http://lkml.org/lkml/2006/11/16/147
http://lkml.org/lkml/2007/3/14/4

This is a regression in 2.6.21-rc1.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Tested-by: Ismail Dönmez <ismail@pardus.org.tr>
---
 drivers/ieee1394/eth1394.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
index a953135..03e44b3 100644
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -584,7 +584,10 @@ static void ether1394_add_host (struct hpsb_host *host)
         }
 
 	SET_MODULE_OWNER(dev);
+#if 0
+	/* FIXME - Is this the correct parent device anyway? */
 	SET_NETDEV_DEV(dev, &host->device);
+#endif
 
 	priv = netdev_priv(dev);
 
-- 
1.4.4.4





