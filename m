Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYHGMcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYHGMcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbYHGMae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:30:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:36926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbYHGMa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:30:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,319,1215414000"; 
   d="scan'208";a="604728892"
Subject: [PATCH 5/6] kexec jump: fix for lockdep
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:05:35 +0800
Message-Id: <1218099935.5164.36.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace local_irq_disable() with raw_local_irq_disable() to prevent
lockdep complain.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -130,7 +130,7 @@ void machine_kexec(struct kimage *image)
 #endif
 
 	/* Interrupts aren't acceptable while we reboot */
-	local_irq_disable();
+	raw_local_irq_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC


