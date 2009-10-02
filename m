Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZJBCCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZJBCCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbZJBCCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:02:47 -0400
Received: from kroah.org ([198.145.64.141]:32868 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZJBBc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:06 2009
Message-Id: <20091002012406.489259007@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>
Subject: [005/136] serial: bfin_5xx: fix building as module when early printk is enabled
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mike Frysinger <vapier@gentoo.org>

commit 0271edd4b1b16f255162029359bb69c1ee4d9c3b upstream.

Since early printk only makes sense/works when the serial driver is built
into the kernel, disable the option for this driver when it is going to be
built as a module.  Otherwise we get build failures due to the ifdef
handling.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/bfin_5xx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -42,6 +42,10 @@
 # undef CONFIG_EARLY_PRINTK
 #endif
 
+#ifdef CONFIG_SERIAL_BFIN_MODULE
+# undef CONFIG_EARLY_PRINTK
+#endif
+
 /* UART name and device definitions */
 #define BFIN_SERIAL_NAME	"ttyBF"
 #define BFIN_SERIAL_MAJOR	204


