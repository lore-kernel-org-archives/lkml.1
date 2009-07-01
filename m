Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbZGABRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbZGABRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761634AbZGAAf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:59 -0400
Received: from kroah.org ([198.145.64.141]:60741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761585AbZGAAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:44 2009
Message-Id: <20090701002444.463759633@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>, Alan Cox <alan@linux.intel.com>
Subject: [patch 104/108] serial: bfin_5xx: fix building as module when early printk is enabled
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 607c268ef9a4675287e77f732071e426e62c2d86 upstream.

Since early printk only makes sense/works when the serial driver is built
into the kernel, disable the option for this driver when it is going to be
built as a module.  Otherwise we get build failures due to the ifdef
handling.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/bfin_5xx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -38,6 +38,10 @@
 #include <asm/cacheflush.h>
 #endif
 
+#ifdef CONFIG_SERIAL_BFIN_MODULE
+# undef CONFIG_EARLY_PRINTK
+#endif
+
 /* UART name and device definitions */
 #define BFIN_SERIAL_NAME	"ttyBF"
 #define BFIN_SERIAL_MAJOR	204


