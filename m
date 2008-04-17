Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYDQBHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYDQBHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYDQBGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:06:40 -0400
Received: from sous-sol.org ([216.99.217.87]:58711 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbYDQBGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:36 -0400
Message-Id: <20080417010359.629397865@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linux-acpi@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>
Subject: pnpacpi: reduce printk severity for "pnpacpi: exceeded the max number of ..."
Content-Disposition: inline; filename=pnpacpi-reduce-printk-severity-for-pnpacpi-exceeded-the-max-number-of.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Len Brown <len.brown@intel.com>

upstream commit 33fd7afd66ffdc6addf1b085fe6403b6af532f8e 

We have been printing these messages at KERN_ERR since 2.6.24,
per http://bugzilla.kernel.org/show_bug.cgi?id=9535

But KERN_ERR pops up on a console booted with "quiet"
and causes users to get alarmed and file bugs
about the message itself:
https://bugzilla.redhat.com/show_bug.cgi?id=436589

So reduce the severity of these messages to
KERN_WARNING, which is not printed by "quiet".

This message will still be seen without "quiet",
but a lot of messages are printed in that mode
and it will be less likely to cause undue alarm.

We could go all the way to KERN_DEBUG, but this
is a real warning after all, so it seems prudent
not to require "debug" to see it.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pnp/pnpacpi/rsparser.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -85,7 +85,7 @@ static void pnpacpi_parse_allocated_irqr
 	       i < PNP_MAX_IRQ)
 		i++;
 	if (i >= PNP_MAX_IRQ && !warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
+		printk(KERN_WARNING "pnpacpi: exceeded the max number of IRQ "
 				"resources: %d \n", PNP_MAX_IRQ);
 		warned = 1;
 		return;
@@ -187,7 +187,7 @@ static void pnpacpi_parse_allocated_dmar
 		res->dma_resource[i].start = dma;
 		res->dma_resource[i].end = dma;
 	} else if (!warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
+		printk(KERN_WARNING "pnpacpi: exceeded the max number of DMA "
 				"resources: %d \n", PNP_MAX_DMA);
 		warned = 1;
 	}
@@ -213,7 +213,7 @@ static void pnpacpi_parse_allocated_iore
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
 	} else if (!warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
+		printk(KERN_WARNING "pnpacpi: exceeded the max number of IO "
 				"resources: %d \n", PNP_MAX_PORT);
 		warned = 1;
 	}
@@ -241,7 +241,7 @@ static void pnpacpi_parse_allocated_memr
 		res->mem_resource[i].start = mem;
 		res->mem_resource[i].end = mem + len - 1;
 	} else if (!warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
+		printk(KERN_WARNING "pnpacpi: exceeded the max number of mem "
 				"resources: %d\n", PNP_MAX_MEM);
 		warned = 1;
 	}

-- 
