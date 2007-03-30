Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXC3Wpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXC3Wpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXC3Wpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:45:45 -0400
Received: from gretel.pobox.com ([208.58.1.197]:34284 "EHLO gretel.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXC3Wpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:45:44 -0400
X-Greylist: delayed 2625 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 18:45:43 EDT
Message-ID: <460D8510.1050102@pobox.com>
Date: Fri, 30 Mar 2007 17:45:52 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com>
In-Reply-To: <20070330210659.GK29450@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ideally, this would go into linux-2.6.21.

Preserve the LBA bit in the DevSel/Head register for HDIO_DRIVE_TASK.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- linux/drivers/ata/libata-scsi.c.orig	2007-03-21 13:35:02.000000000 -0400
+++ linux/drivers/ata/libata-scsi.c	2007-03-30 17:40:58.000000000 -0400
@@ -333,7 +333,7 @@
 	scsi_cmd[8]  = args[3];
 	scsi_cmd[10] = args[4];
 	scsi_cmd[12] = args[5];
-	scsi_cmd[13] = args[6] & 0x0f;
+	scsi_cmd[13] = args[6] & 0x4f;
 	scsi_cmd[14] = args[0];
 
 	/* Good values for timeout and retries?  Values below
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
