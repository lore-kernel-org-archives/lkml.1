Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYIXJih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYIXJih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYIXJi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:38:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:55325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYIXJiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:38:25 -0400
Message-ID: <48DA0A2C.8010008@kernel.org>
Date: Wed, 24 Sep 2008 18:36:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, lists@ku-gbr.de, bhalevy.lists@gmail.com
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita>
In-Reply-To: <20080924084846.GA2094@anita>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------070207090508010706020306"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Sep 2008 09:38:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070207090508010706020306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please apply the attached patch and post the resulting log.  Please
don't forget to turn on KALLSYMS.

Thanks.

-- 
tejun

--------------070207090508010706020306
Content-Type: text/x-patch;
 name="sata_nv-eh-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_nv-eh-debug.patch"

---
 drivers/ata/libata-eh.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: tree0/drivers/ata/libata-eh.c
===================================================================
--- tree0.orig/drivers/ata/libata-eh.c
+++ tree0/drivers/ata/libata-eh.c
@@ -671,6 +671,9 @@ static void ata_eh_set_pending(struct at
 
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 
+	ata_port_printk(ap, KERN_INFO, "XXX EH_SET_PENDING\n");
+	dump_stack();
+
 	if (!fastdrain)
 		return;
 
@@ -1077,6 +1080,11 @@ void ata_eh_about_to_do(struct ata_link
 	struct ata_eh_context *ehc = &link->eh_context;
 	unsigned long flags;
 
+	if (link)
+		ata_link_printk(link, KERN_INFO, "XXX about_to_do %x\n", action);
+	else if (dev)
+		ata_dev_printk(dev, KERN_INFO, "XXX about_to_do %x\n", action);
+
 	spin_lock_irqsave(ap->lock, flags);
 
 	ata_eh_clear_action(link, dev, ehi, action);
@@ -1890,8 +1898,8 @@ static void ata_eh_link_report(struct at
 		nr_failed++;
 	}
 
-	if (!nr_failed && !ehc->i.err_mask)
-		return;
+	//if (!nr_failed && !ehc->i.err_mask)
+	//	return;
 
 	frozen = "";
 	if (ap->pflags & ATA_PFLAG_FROZEN)

--------------070207090508010706020306--

