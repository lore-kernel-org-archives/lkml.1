Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395Ab0AUEXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0AUEXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219Ab0AUEXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:23:05 -0500
Received: from kroah.org ([198.145.64.141]:60160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab0AUEXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.078046215@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Bryn M. Reeves" <bmr@redhat.com>
Subject: [20/30] [SCSI] megaraid_sas: remove sysfs poll_mode_io world writeable permissions
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3451,7 +3451,7 @@ out:
 	return retval;
 }
 
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
 		megasas_sysfs_show_poll_mode_io,
 		megasas_sysfs_set_poll_mode_io);
 


