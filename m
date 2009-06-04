Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZFDKZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZFDKZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZFDKYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:24:55 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:48842 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZFDKYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:24:54 -0400
Date: Thu, 4 Jun 2009 12:24:55 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Pierre Ossman <pierre@ossman.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.4] Driver for CB710/720 memory card reader (MMC
	part) - v5 fixed
Message-ID: <20090604102455.GA32296@rere.qmqm.pl>
References: <20081004215122.0626cd7b@mjolnir.drzeus.cx> <20081029141146.GA17741@rere.qmqm.pl> <20081114220658.38f0645c@mjolnir.drzeus.cx> <20090201185435.GA9165@rere.qmqm.pl> <20090221134603.6bc3c385@mjolnir.ossman.eu> <20090508151622.GA23006@rere.qmqm.pl> <20090522132755.144efcca@mjolnir.ossman.eu> <20090522175501.GA673@rere.qmqm.pl> <20090522183359.GA3567@rere.qmqm.pl> <20090527221342.3a1ba44d@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090527221342.3a1ba44d@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:13:42PM +0200, Pierre Ossman wrote:
> On Fri, 22 May 2009 20:33:59 +0200
> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
[cut: CB710 driver patch description]
> Queued.

One more fixup for the driver following.

Best Regards,
Micha³ Miros³aw

---here---

cb710: Fix compilation warning in DEBUG case.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urpN test1/drivers/misc/cb710/Kconfig test2/drivers/misc/cb710/Kconfig
--- test1/drivers/misc/cb710/Kconfig	2009-06-04 12:20:29.000000000 +0200
+++ test2/drivers/misc/cb710/Kconfig	2009-06-04 10:53:34.000000000 +0200
@@ -19,3 +19,8 @@ config CB710_DEBUG
 	  This is an option for use by developers; most people should
 	  say N here.  This adds a lot of debugging output to dmesg.
 
+config CB710_DEBUG_ASSUMPTIONS
+	bool
+	depends on CB710_CORE != n
+	default y
+
diff -urpN test1/drivers/misc/cb710/Makefile test2/drivers/misc/cb710/Makefile
--- test1/drivers/misc/cb710/Makefile	2009-06-04 12:20:29.000000000 +0200
+++ test2/drivers/misc/cb710/Makefile	2009-06-04 10:53:34.000000000 +0200
@@ -2,3 +2,5 @@ obj-$(CONFIG_CB710_CORE)	+= cb710.o
 
 cb710-y				:= core.o sgbuf2.o
 cb710-$(CONFIG_CB710_DEBUG)	+= debug.o
+
+ccflags-$(CONFIG_CB710_DEBUG)	+= -DDEBUG
diff -urpN test1/drivers/mmc/host/Makefile test2/drivers/mmc/host/Makefile
--- test1/drivers/mmc/host/Makefile	2009-06-04 12:20:29.000000000 +0200
+++ test2/drivers/mmc/host/Makefile	2009-06-04 10:53:34.000000000 +0200
@@ -29,3 +29,7 @@ obj-$(CONFIG_MMC_SDRICOH_CS)	+= sdricoh_
 obj-$(CONFIG_MMC_TMIO)		+= tmio_mmc.o
 obj-$(CONFIG_MMC_CB710)	+= cb710-mmc.o
 
+ifeq ($(CONFIG_CB710_DEBUG),y)
+CFLAGS-cb710-mmc		+= -DDEBUG
+endif
+
diff -urpN test1/include/linux/cb710.h test2/include/linux/cb710.h
--- test1/include/linux/cb710.h	2009-06-04 12:20:29.000000000 +0200
+++ test2/include/linux/cb710.h	2009-06-04 10:53:34.000000000 +0200
@@ -10,13 +10,6 @@
 #ifndef LINUX_CB710_DRIVER_H
 #define LINUX_CB710_DRIVER_H
 
-#ifdef CONFIG_CB710_DEBUG
-#define DEBUG
-#endif
-
-/* verify assumptions on platform_device framework */
-#define CONFIG_CB710_DEBUG_ASSUMPTIONS
-
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
