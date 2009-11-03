Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZKCLEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZKCLEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZKCLEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:04:43 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33513 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbZKCLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:04:43 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>
Subject: [PATCH 02/42] driver core: Don't remove kobjects in device_shutdown.
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 03:04:45 -0800
Message-ID: <m1y6mnc1iq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


device_shutdown is defined to just shutdown the hardware and to not
clean up any kernel data structures.  Therefore don't put the kobjects
for /sys/dev and /sys/dev/block and /sys/dev/char.

This ensures we don't remove /sys/dev/block and /sys/dev/char while
we still have symlinks from there to the actual devices.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/base/core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6bee6af..3324d5a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1728,8 +1728,5 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-	kobject_put(sysfs_dev_char_kobj);
-	kobject_put(sysfs_dev_block_kobj);
-	kobject_put(dev_kobj);
 	async_synchronize_full();
 }
-- 
1.6.5.2.143.g8cc62

