Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZISVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZISVhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZISVhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:37:39 -0400
Received: from kroah.org ([198.145.64.141]:50879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZISVhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:37:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       stable <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/79] serial: bfin_5xx: fix building as module when early printk is enabled
Date: Sat, 19 Sep 2009 14:36:07 -0700
Message-Id: <1253396244-7885-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Since early printk only makes sense/works when the serial driver is built
into the kernel, disable the option for this driver when it is going to be
built as a module.  Otherwise we get build failures due to the ifdef
handling.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index b4a7650..4fff4e5 100644
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
-- 
1.6.4.2

