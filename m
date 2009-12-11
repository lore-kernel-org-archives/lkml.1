Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbZLKQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbZLKQI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbZLKQIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:08:51 -0500
Received: from relay3.sgi.com ([192.48.152.1]:59905 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932608AbZLKQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:08:50 -0500
Message-ID: <4B226E92.5080904@sgi.com>
Date: Fri, 11 Dec 2009 08:08:50 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH] x86: Remove 4095 enabling x2apic messages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Remove 4095 enabling x2apic messages

Print only once that the system is supporting x2apic mode.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/apic/apic.c
+++ linux/arch/x86/kernel/apic/apic.c
@@ -1358,7 +1358,7 @@
 
 	rdmsr(MSR_IA32_APICBASE, msr, msr2);
 	if (!(msr & X2APIC_ENABLE)) {
-		pr_info("Enabling x2apic\n");
+		printk_once(KERN_INFO "Enabling x2apic\n");
 		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
 	}
 }
