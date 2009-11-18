Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZKRAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZKRAXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZKRAWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:22:55 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35762 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756447AbZKRAWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:22:15 -0500
Message-Id: <20091118002220.610780000@alcatraz.americas.sgi.com>
References: <20091118002211.709343000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Nov 2009 18:22:14 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] firmware: Limit the number of per cpu firmware messages during bootup
Content-Disposition: inline; filename=limit_firmware_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of per cpu firmware: messages by sending them
only to the kernel debug log buffer.

	[  170.643130] firmware: requesting intel-ucode/06-2e-0

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/base/firmware_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -495,7 +495,7 @@
 	}
 
 	if (uevent)
-		dev_info(device, "firmware: requesting %s\n", name);
+		dev_dbg(device, "firmware: requesting %s\n", name);
 
 	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
 	if (retval)

-- 
