Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYHHGyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYHHGyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYHHGww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:52:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:36362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYHHGwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,325,1215414000"; 
   d="scan'208";a="427278662"
Subject: [PATCH -v2 6/8] kexec jump: fix for lockdep
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:52:45 +0800
Message-Id: <1218178365.22039.79.camel@caritas-dev.intel.com>
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
@@ -123,7 +123,7 @@ void machine_kexec(struct kimage *image)
 	tracer_disable();
 
 	/* Interrupts aren't acceptable while we reboot */
-	local_irq_disable();
+	raw_local_irq_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC


