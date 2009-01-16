Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbZAPNVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbZAPNVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762557AbZAPNVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:21:25 -0500
Received: from smtp.nokia.com ([192.100.105.134]:58121 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761014AbZAPNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:21:23 -0500
Date: Fri, 16 Jan 2009 15:21:12 +0200 (EET)
Message-Id: <20090116.152112.90140354.Hiroshi.DOYU@nokia.com>
To: roel.kluin@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 01/10] omap mailbox: cleanup omap2 register definition
 with macro
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20090116.141524.236287675.Hiroshi.DOYU@nokia.com>
References: <20090116082706.17571.31102.stgit@oreo.research.nokia.com>
	<25e057c00901160156w6058ade2j9c99ef727d8767ab@mail.gmail.com>
	<20090116.141524.236287675.Hiroshi.DOYU@nokia.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Fri_Jan_16_15_21_12_2009_137)--"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 13:21:13.0762 (UTC) FILETIME=[4E0B7020:01C977DD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Fri_Jan_16_15_21_12_2009_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Updated one attached.

From: "ext Hiroshi DOYU" <Hiroshi.DOYU@nokia.com>
Subject: Re: [PATCH 01/10] omap mailbox: cleanup omap2 register definition with macro
Date: Fri, 16 Jan 2009 14:15:24 +0200 (EET)

> From: "ext roel kluin" <roel.kluin@gmail.com>
> Subject: Re: [PATCH 01/10] omap mailbox: cleanup omap2 register definition with macro
> Date: Fri, 16 Jan 2009 10:56:01 +0100
> 
> [...]
> > > +#define MAILBOX_SYSCONFIG              0x010
> > > +#define MAILBOX_SYSSTATUS              0x014
> > > +#define MAILBOX_MESSAGE(m)             (0x040 + 4 * (m))
> > > +#define MAILBOX_FIFOSTATUS(m)          (0x080 + 4 * (m))
> > > +#define MAILBOX_MSGSTATUS(m)           (0x0c0 + 4 * (m))
> > > +#define MAILBOX_IRQSTATUS(u)           (0x100 + 8 * (u))
> > > +#define MAILBOX_IRQENABLE(u)           (0x108 + 8 * (u))
> >                                                                   ^^^^^^^
> > shouldn't this be
> > #define MAILBOX_IRQENABLE(u)           (0x104 + 8 * (u))
> 
> Right. I'll fix, thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

----Next_Part(Fri_Jan_16_15_21_12_2009_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename=omap-mailbox-cleanup-omap2-reg

omap mailbox: cleanup omap2 register definition with macro

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/mailbox.c |   77 +++++++++++++++--------------------------
 1 files changed, 29 insertions(+), 48 deletions(-)


diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 32b7af3..85c3ab8 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -1,9 +1,9 @@
 /*
- * Mailbox reservation modules for OMAP2
+ * Mailbox reservation modules for OMAP2/3
  *
- * Copyright (C) 2006 Nokia Corporation
+ * Copyright (C) 2006-2008 Nokia Corporation
  * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
- *        and  Paul Mundt <paul.mundt@nokia.com>
+ *        and  Paul Mundt
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -18,40 +18,19 @@
 #include <mach/mailbox.h>
 #include <mach/irqs.h>
 
-#define MAILBOX_REVISION		0x00
-#define MAILBOX_SYSCONFIG		0x10
-#define MAILBOX_SYSSTATUS		0x14
-#define MAILBOX_MESSAGE_0		0x40
-#define MAILBOX_MESSAGE_1		0x44
-#define MAILBOX_MESSAGE_2		0x48
-#define MAILBOX_MESSAGE_3		0x4c
-#define MAILBOX_MESSAGE_4		0x50
-#define MAILBOX_MESSAGE_5		0x54
-#define MAILBOX_FIFOSTATUS_0		0x80
-#define MAILBOX_FIFOSTATUS_1		0x84
-#define MAILBOX_FIFOSTATUS_2		0x88
-#define MAILBOX_FIFOSTATUS_3		0x8c
-#define MAILBOX_FIFOSTATUS_4		0x90
-#define MAILBOX_FIFOSTATUS_5		0x94
-#define MAILBOX_MSGSTATUS_0		0xc0
-#define MAILBOX_MSGSTATUS_1		0xc4
-#define MAILBOX_MSGSTATUS_2		0xc8
-#define MAILBOX_MSGSTATUS_3		0xcc
-#define MAILBOX_MSGSTATUS_4		0xd0
-#define MAILBOX_MSGSTATUS_5		0xd4
-#define MAILBOX_IRQSTATUS_0		0x100
-#define MAILBOX_IRQENABLE_0		0x104
-#define MAILBOX_IRQSTATUS_1		0x108
-#define MAILBOX_IRQENABLE_1		0x10c
-#define MAILBOX_IRQSTATUS_2		0x110
-#define MAILBOX_IRQENABLE_2		0x114
-#define MAILBOX_IRQSTATUS_3		0x118
-#define MAILBOX_IRQENABLE_3		0x11c
+#define MAILBOX_REVISION		0x000
+#define MAILBOX_SYSCONFIG		0x010
+#define MAILBOX_SYSSTATUS		0x014
+#define MAILBOX_MESSAGE(m)		(0x040 + 4 * (m))
+#define MAILBOX_FIFOSTATUS(m)		(0x080 + 4 * (m))
+#define MAILBOX_MSGSTATUS(m)		(0x0c0 + 4 * (m))
+#define MAILBOX_IRQSTATUS(u)		(0x100 + 8 * (u))
+#define MAILBOX_IRQENABLE(u)		(0x104 + 8 * (u))
 
-static unsigned long mbox_base;
+#define MAILBOX_IRQ_NEWMSG(u)		(1 << (2 * (u)))
+#define MAILBOX_IRQ_NOTFULL(u)		(1 << (2 * (u) + 1))
 
-#define MAILBOX_IRQ_NOTFULL(n)		(1 << (2 * (n) + 1))
-#define MAILBOX_IRQ_NEWMSG(n)		(1 << (2 * (n)))
+static unsigned long mbox_base;
 
 struct omap_mbox2_fifo {
 	unsigned long msg;
@@ -209,15 +188,15 @@ static struct omap_mbox_ops omap2_mbox_ops = {
 /* DSP */
 static struct omap_mbox2_priv omap2_mbox_dsp_priv = {
 	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE_0,
-		.fifo_stat	= MAILBOX_FIFOSTATUS_0,
+		.msg		= MAILBOX_MESSAGE(0),
+		.fifo_stat	= MAILBOX_FIFOSTATUS(0),
 	},
 	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE_1,
-		.msg_stat	= MAILBOX_MSGSTATUS_1,
+		.msg		= MAILBOX_MESSAGE(1),
+		.msg_stat	= MAILBOX_MSGSTATUS(1),
 	},
-	.irqenable	= MAILBOX_IRQENABLE_0,
-	.irqstatus	= MAILBOX_IRQSTATUS_0,
+	.irqenable	= MAILBOX_IRQENABLE(0),
+	.irqstatus	= MAILBOX_IRQSTATUS(0),
 	.notfull_bit	= MAILBOX_IRQ_NOTFULL(0),
 	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(1),
 };
@@ -232,15 +211,15 @@ EXPORT_SYMBOL(mbox_dsp_info);
 /* IVA */
 static struct omap_mbox2_priv omap2_mbox_iva_priv = {
 	.tx_fifo = {
-		.msg		= MAILBOX_MESSAGE_2,
-		.fifo_stat	= MAILBOX_FIFOSTATUS_2,
+		.msg		= MAILBOX_MESSAGE(2),
+		.fifo_stat	= MAILBOX_FIFOSTATUS(2),
 	},
 	.rx_fifo = {
-		.msg		= MAILBOX_MESSAGE_3,
-		.msg_stat	= MAILBOX_MSGSTATUS_3,
+		.msg		= MAILBOX_MESSAGE(3),
+		.msg_stat	= MAILBOX_MSGSTATUS(3),
 	},
-	.irqenable	= MAILBOX_IRQENABLE_3,
-	.irqstatus	= MAILBOX_IRQSTATUS_3,
+	.irqenable	= MAILBOX_IRQENABLE(3),
+	.irqstatus	= MAILBOX_IRQSTATUS(3),
 	.notfull_bit	= MAILBOX_IRQ_NOTFULL(2),
 	.newmsg_bit	= MAILBOX_IRQ_NEWMSG(3),
 };
@@ -320,4 +299,6 @@ static void __exit omap2_mbox_exit(void)
 module_init(omap2_mbox_init);
 module_exit(omap2_mbox_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: omap2/3 architecture specific functions");
+MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Paul Mundt");

----Next_Part(Fri_Jan_16_15_21_12_2009_137)----
