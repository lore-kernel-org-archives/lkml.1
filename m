Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZLCAk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZLCAk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZLCAk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:40:56 -0500
Received: from kbsmtao149.starhub.net.sg ([203.116.2.149]:13042 "EHLO
	kbsmtao149.starhub.net.sg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZLCAkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:40:55 -0500
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 19:40:54 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEABGWFkvLdAK3/2dsb2JhbACBTo8XAYw6un6EMQQ
Date: Wed, 02 Dec 2009 10:17:44 -0500
From: Casey Dahlin <cdahlin@redhat.com>
Subject: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world writeable
 permissions
To: linux-kernel@vger.kernel.org
Cc: eteo@redhat.com, "Bryn M. Reeves" <bmr@redhat.com>,
       Casey Dahlin <cdahlin@redhat.com>,
       Neela Syam Kolli <megaraidlinux@lsi.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Anand Gadiyar <gadiyar@ti.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org
Message-id: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryn M. Reeves <bmr@redhat.com>

/sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
world-writable, which seems bad (letting any user affect kernel driver
behavior).

This turns off group and user write permissions, so that on typical
production systems only root can write to it.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>
Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index a39addc..08a7f49 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3451,7 +3451,7 @@ out:
 	return retval;
 }
 
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
 		megasas_sysfs_show_poll_mode_io,
 		megasas_sysfs_set_poll_mode_io);
 
-- 
1.6.2.5

