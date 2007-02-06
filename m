Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXBFUPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXBFUPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965428AbXBFUPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:15:48 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37033 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965426AbXBFUPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:15:47 -0500
Date: Tue, 6 Feb 2007 12:10:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] Re: error 2 after a compile
Message-Id: <20070206121027.0a38e6ad.randy.dunlap@oracle.com>
In-Reply-To: <45C8DE76.5000109@wanadoo.fr>
References: <45C8DE76.5000109@wanadoo.fr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Feb 2007 21:00:54 +0100 Thibaud Hulin wrote:

> Hello !
> I'm trying to compile a kernel from 2.6.17-10 to 2.6.19 with suspend2.
> After this command :
> make-kpkg --append-to-version=swsusp2.070206 kernel_image --initrd 
> kernel_headers --revision=2.6.1
> 
> I obtain :
>   Building modules, stage 2.
>    MODPOST 1479 modules
> WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
> WARNING: "try_to_freeze" [drivers/usb/atm/ueagle-atm.ko] undefined!
> make[2]: *** [__modpost] Erreur 1
> make[1]: *** [modules] Erreur 2
> make[1]: quittant le répertoire « /home/hulin/src/linux-2.6.19 »
> make: *** [debian/stamp-build-kernel] Erreur 2
> 
> I don't understand the error ?


The driver is missing #include <linux/sched.h>.
Please try the patch below and report back on it.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Driver needs sched.h for try_to_freeze().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/atm/ueagle-atm.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2619-pv.orig/drivers/usb/atm/ueagle-atm.c
+++ linux-2619-pv/drivers/usb/atm/ueagle-atm.c
@@ -61,6 +61,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/ctype.h>
+#include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/version.h>
 #include <linux/mutex.h>
