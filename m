Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0CETLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:11:24 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56486 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0CETKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:10:37 -0500
Message-Id: <20100305191035.496296948@gulag1.americas.sgi.com>
References: <20100305191035.058221526@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 13:10:37 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/3] firmware: reduce per cpu boot up messages
Content-Disposition: inline; filename=change-firmware-msglevel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write per cpu firmare boot up messages to debug log only.

Signed-of-by: Mike Travis <travis@sgi.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/base/firmware_class.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -487,15 +487,14 @@ _request_firmware(const struct firmware
 	     builtin++) {
 		if (strcmp(name, builtin->name))
 			continue;
-		dev_info(device, "firmware: using built-in firmware %s\n",
-			 name);
+		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
 		firmware->size = builtin->size;
 		firmware->data = builtin->data;
 		return 0;
 	}
 
 	if (uevent)
-		dev_info(device, "firmware: requesting %s\n", name);
+		dev_dbg(device, "firmware: requesting %s\n", name);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)

-- 
