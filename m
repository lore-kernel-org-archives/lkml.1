Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZJWXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZJWXh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZJWXhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:37:54 -0400
Received: from relay2.sgi.com ([192.48.179.30]:54753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752283AbZJWXhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:52 -0400
Message-Id: <20091023233755.880019000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:48 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] SGI x86_64 UV: Limit the number of firmware messages
Content-Disposition: inline; filename=limit_firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of firmware messages of the form:

[  170.643130] firmware: requesting intel-ucode/06-2e-0

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/base/firmware_class.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -471,6 +471,7 @@
 	struct firmware *firmware;
 	struct builtin_fw *builtin;
 	int retval;
+	static int msgcnt;
 
 	if (!firmware_p)
 		return -EINVAL;
@@ -494,8 +495,10 @@
 		return 0;
 	}
 
-	if (uevent)
+	if (uevent && (msgcnt < 4 || !limit_console_output(false))) {
 		dev_info(device, "firmware: requesting %s\n", name);
+		msgcnt++;
+	}
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)

-- 
