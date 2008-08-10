Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYHJVhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYHJVhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYHJVhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:37:31 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35798 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYHJVha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:37:30 -0400
Message-ID: <489F5F99.1000905@keyaccess.nl>
Date: Sun, 10 Aug 2008 23:37:29 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L1: make PMS not autoprobe when builtin.
Content-Type: multipart/mixed;
 boundary="------------060403080504020009040702"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060403080504020009040702
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew.

Alternate version of the PMS patch sent yesterday. This one makes it 
need explicit enabling when builtin and doesn't change anything when 
modular as per Alan Cox's comments.

This is a deprecated, unused driver meaning it doesn't matter. It still 
fixes that (randconfig testing breakage) which it is supposed to fix.

Rene.

--------------060403080504020009040702
Content-Type: text/plain;
 name="0001-V4L1-make-PMS-not-autoprobe-when-builtin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-V4L1-make-PMS-not-autoprobe-when-builtin.patch"

>From e089b11a8eee4876c2c65988a9f423a1ae111d7a Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sat, 9 Aug 2008 20:39:19 +0200
Subject: [PATCH] V4L1: make PMS not autoprobe when builtin.

The old Mediavision Pro Movie Studio legacy ISA V4L1 driver was
found to hang the boot during Ingo Molnar's testing of randconfig
kernels. Have it require a "pms.enable=1" kernel parameter to
enable the driver when builtin which avoids such problems.

This is a deprecated and, very likely, unused driver. Nothing
changes modular moreover.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/media/video/pms.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 00425d7..ede522a 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -1019,10 +1019,22 @@ static int init_mediavision(void)
  *	Initialization and module stuff
  */
 
+#ifndef MODULE
+static int enable;
+module_param(enable, int, 0);
+#endif
+
 static int __init init_pms_cards(void)
 {
 	printk(KERN_INFO "Mediavision Pro Movie Studio driver 0.02\n");
 
+#ifndef MODULE
+	if (!enable) {
+		printk(KERN_INFO "Not enabled\n");
+		return -ENODEV;
+	}
+#endif
+
 	data_port = io_port +1;
 
 	if(init_mediavision())
-- 
1.5.5


--------------060403080504020009040702--
