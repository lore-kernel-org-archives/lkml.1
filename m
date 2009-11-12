Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZKLRUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZKLRUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZKLRUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:20:51 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44420 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753440AbZKLRUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:20:50 -0500
Message-Id: <20091112172027.111761000@alcatraz.americas.sgi.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 11:19:38 -0600
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
Subject: [PATCH 4/7] firmware: Limit the number of per cpu firmware messages during bootup
Content-Disposition: inline; filename=limit_firmware_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of per cpu firmware: messages when system is booting to
prevent clogging up the console output with repetitious messages.

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
