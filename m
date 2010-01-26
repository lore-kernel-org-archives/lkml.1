Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093Ab0AZT37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0AZT37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076Ab0AZT3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:55 -0500
Received: from kroah.org ([198.145.64.141]:33570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab0AZT27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:28:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:24 2010
Message-Id: <20100126191624.026243857@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Bryn M. Reeves" <bmr@redhat.com>
Subject: [02/11] [SCSI] megaraid_sas: remove sysfs poll_mode_io world writeable permissions
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bryn M. Reeves <bmr@redhat.com>

commit bb7d3f24c71e528989501617651b669fbed798cb upstream.

/sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
world-writable, which seems bad (letting any user affect kernel driver
behavior).

This turns off group and user write permissions, so that on typical
production systems only root can write to it.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3462,7 +3462,7 @@ out:
 	return retval;
 }
 
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
 		megasas_sysfs_show_poll_mode_io,
 		megasas_sysfs_set_poll_mode_io);
 


