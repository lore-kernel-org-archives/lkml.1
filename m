Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYHGMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYHGMbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbYHGMam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:30:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:47158 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYHGMal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,319,1215414000"; 
   d="scan'208";a="30837816"
Subject: [PATCH 4/6] kexec jump: in sync with hibernation implementation
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:05:32 +0800
Message-Id: <1218099932.5164.35.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device_pm_lock() and device_pm_unlock() in kernel_kexec() to be
in sync with current hibernation implementation.

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


