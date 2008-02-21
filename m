Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbYBUNHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbYBUNHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYBUNGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:06:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43074 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755249AbYBUNGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:06:04 -0500
Date: Thu, 21 Feb 2008 13:56:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
Subject: power_state: get rid of write-only variable in SATA
Message-ID: <20080221125652.GA23548@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


power_state is scheduled for removal, and libata uses it in write-only
mode. Remove it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b4985bc..a31572d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6542,8 +6542,6 @@ int ata_host_suspend(struct ata_host *ho
 	ata_lpm_enable(host);
 
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
-	if (rc == 0)
-		host->dev->power.power_state = mesg;
 	return rc;
 }
 
@@ -6562,7 +6560,6 @@ void ata_host_resume(struct ata_host *ho
 {
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
-	host->dev->power.power_state = PMSG_ON;
 
 	/* reenable link pm */
 	ata_lpm_disable(host);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
