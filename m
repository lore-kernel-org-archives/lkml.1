Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbXK3TGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbXK3TGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbXK3TGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:06:22 -0500
Received: from rtr.ca ([76.10.145.34]:4082 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbXK3TGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:06:21 -0500
Message-ID: <47505F2B.2090109@rtr.ca>
Date: Fri, 30 Nov 2007 14:06:19 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Kernel <linux-acpi@vger.kernel.org>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] 2.6.24: restore missing sysfs max_cstate attr
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len, is there any good reason why max_cstate was made invisible in 2.6.24,
breaking my userspace scripts that access it?

Here's a patch to fix the regression from 2.6.23:

Restore visibility of /sys/module/processor/parameters/max_cstate 
for compatibility with kernels prior to 2.6.24.

I have scripts here that rely upon it.

Signed-off-by: Mark Lord <mlord@pobox.com>
---

Patch is against 2.6.24-rc3-git5.

--- linux/drivers/acpi/processor_idle.c.orig	2007-11-30 13:35:20.000000000 -0500
+++ linux/drivers/acpi/processor_idle.c	2007-11-30 13:35:31.000000000 -0500
@@ -76,7 +76,7 @@
 #define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
-module_param(max_cstate, uint, 0000);
+module_param(max_cstate, uint, 0644);
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
 
