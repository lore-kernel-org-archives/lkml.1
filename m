Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYJFJfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYJFJfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYJFJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:35:28 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:46987 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYJFJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:35:27 -0400
X-Greylist: delayed 2581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 05:35:27 EDT
From: David John <davidjon@xenontk.org>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com
Subject: [PATCH] HPET: Remove spurious HPET busy warning message.
Date: Mon,  6 Oct 2008 14:22:20 +0530
Message-Id: <1223283140-8059-1-git-send-email-davidjon@xenontk.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 systems with CONFIG_HPET_TIMER enabled
and the HPET driver (drivers/char/hpet.c) compiled in,
an incorrect busy message is printed when the driver
initializes since the HPET has already been allocated
by the core timer code. Remove the warning message.

Signed-off-by: David John <davidjon@xenontk.org>
---
 drivers/char/hpet.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..454c13b 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -874,8 +874,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		hdp->hd_address = ioremap(addr.minimum, addr.address_length);
 
 		if (hpet_is_known(hdp)) {
-			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
@@ -891,8 +889,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 						HPET_RANGE_SIZE);
 
 		if (hpet_is_known(hdp)) {
-			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
