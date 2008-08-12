Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYHLDQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYHLDQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYHLDOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:14:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:3706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbYHLDOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="605967495"
Subject: [PATCH -v3 5/7] kexec jump: in sync with hibernation implementation
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 11:14:33 +0800
Message-Id: <1218510873.24951.44.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device_pm_lock() and device_pm_unlock() in kernel_kexec() in sync
with current hibernation implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 kernel/kexec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1457,6 +1457,7 @@ int kernel_kexec(void)
 		error = disable_nonboot_cpus();
 		if (error)
 			goto Resume_devices;
+		device_pm_lock();
 		local_irq_disable();
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
@@ -1485,6 +1486,7 @@ int kernel_kexec(void)
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
 		local_irq_enable();
+		device_pm_unlock();
 		enable_nonboot_cpus();
  Resume_devices:
 		device_resume(PMSG_RESTORE);


