Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXHWDbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXHWDbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbXHWDbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:31:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57050 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674AbXHWDbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:31:40 -0400
Date: Thu, 23 Aug 2007 09:14:25 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rudolf Marek <r.marek@assembler.cz>
cc: Mark Hoffman <mhoffman@lightlink.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] hwmon coretemp: Remove bogus __cpuinitdata etc cleanup
Message-ID: <alpine.LFD.0.999.0708230910120.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The CPU hotplug notifier_block coretemp_cpu_notifier is already defined
inside an #ifdef HOTPLUG_CPU, therefore marking it as __cpuinitdata is
quite a pointless thing to do.

Also, remove duplicate prototype of function coretemp_update_device()
at the top of this file (another one already exists barely 10 lines
above this one :-)

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

[ Rudolf, Mark, would it be acceptable to you to remove all the open
  #ifdef HOTPLUG_CPU from this file and replace them with __cpuinit{data}
  instead? That could increase size of modular builds, but would remain
  consistent with rest of kernel, and make the file #ifdef-clean ... ]

 drivers/hwmon/coretemp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 7c17952..f7b0ef4 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -58,8 +58,6 @@ struct coretemp_data {
 	u8 alarm;
 };
 
-static struct coretemp_data *coretemp_update_device(struct device *dev);
-
 /*
  * Sysfs stuff
  */
@@ -350,7 +348,7 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata coretemp_cpu_notifier = {
+static struct notifier_block coretemp_cpu_notifier = {
 	.notifier_call = coretemp_cpu_callback,
 };
 #endif				/* !CONFIG_HOTPLUG_CPU */
