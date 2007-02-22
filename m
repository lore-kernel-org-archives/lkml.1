Return-Path: <linux-kernel-owner+w=401wt.eu-S1751420AbXBVFyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbXBVFyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXBVFyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:54:18 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52519 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXBVFyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:54:17 -0500
Date: Wed, 21 Feb 2007 23:48:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] libata: add NCQ blacklist entries from Silicon Image Windows
 driver
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <45DD2EC9.4050403@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in some NCQ blacklist entries taken from the Silicon
Image Windows drivers' .inf files for the 3124 and 3132 controllers.
These entries were marked as ""DisableSataQueueing". Assume these are
in their blacklist for a reason and disable NCQ on these drives.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.21-rc1edit/drivers/ata/libata-core.c.prev	2007-02-21 22:23:05.000000000 -0600
+++ linux-2.6.21-rc1edit/drivers/ata/libata-core.c	2007-02-21 22:25:44.000000000 -0600
@@ -3269,6 +3269,13 @@ static const struct ata_blacklist_entry 
 
 	/* Devices with NCQ limits */
 
+	/* The following blacklist entries are taken from the Windows
+	   driver .inf files for the Silicon Image 3124 and 3132. */
+	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541060G9SA00",	"MB3OC60D",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541080G9SA00",	"MB4OC60D",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541010G9SA00",	"MBZOC60D",	ATA_HORKAGE_NONCQ, },
+
 	/* End Marker */
 	{ }
 };

