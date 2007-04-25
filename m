Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXDYKRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXDYKRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXDYKRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:17:25 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:19451 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbXDYKRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:17:23 -0400
X-Greylist: delayed 2882 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 06:17:23 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Date: Wed, 25 Apr 2007 11:27:09 +0200
Message-ID: <D7810733513F4840B4EBAAFA64D9C6A4012D5C9F@stgw002a.ww002.siemens.net>
In-Reply-To: <44c9a2b88950e3848d2c4e457641eb9b@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Thread-Index: AceF7Dxw1HG7Z+0/Q922AExek2MqSwBLNw6A
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
To: <linux-pcmcia@lists.infradead.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Apr 2007 09:26:35.0392 (UTC) FILETIME=[D19CA800:01C7871B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without the following patch, the kernel does not automatically detect
2GB CompactFlash cards from Transcend.

I'm not sure which correct values must be assigned to the 3th and 4th
parameters (here: 0x709b1bf1, 0xf54a91c8). Anyway, the patch is working
with these values. Tested on arch=mips.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>

===================================================================
--- linux-2.6.20.7-orig/drivers/ide/legacy/ide-cs.c     2007-04-15
21:08:02.000000000 +0200
+++ linux-2.6.20.7/drivers/ide/legacy/ide-cs.c  2007-04-25
10:53:53.000000000 +0200
@@ -64,6 +64,7 @@
 
 #define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0)
 
+#define PCMCIA_DEBUG 1
 #ifdef PCMCIA_DEBUG
 INT_MODULE_PARM(pc_debug, PCMCIA_DEBUG);
 #define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
@@ -399,6 +400,7 @@
        PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a,
0x3489e003),
        PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
        PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1,
0x2a54d4b1),
+       PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1,
0xf54a91c8),
        PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1,
0xf54a91c8),
        PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
        PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c,
0x212bb918),
