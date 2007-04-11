Return-Path: <linux-kernel-owner+w=401wt.eu-S1161366AbXDKWze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161366AbXDKWze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161380AbXDKWzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55745 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161342AbXDKWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:28 -0400
Date: Wed, 11 Apr 2007 15:52:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 24/31] libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
Message-ID: <20070411225239.GY24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-bugfix-preserve-lba-bit-for-hdio_drive_task.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark Lord <mlord@pobox.com>

libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK

Preserve the LBA bit in the DevSel/Head register for HDIO_DRIVE_TASK.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -295,7 +295,7 @@ int ata_task_ioctl(struct scsi_device *s
 	scsi_cmd[8]  = args[3];
 	scsi_cmd[10] = args[4];
 	scsi_cmd[12] = args[5];
-	scsi_cmd[13] = args[6] & 0x0f;
+	scsi_cmd[13] = args[6] & 0x4f;
 	scsi_cmd[14] = args[0];
 
 	/* Good values for timeout and retries?  Values below

-- 
