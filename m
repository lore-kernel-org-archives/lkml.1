Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYHMJMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYHMJMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYHMJMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:12:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:54442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYHMJMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,200,1217833200"; 
   d="scan'208";a="606375939"
Subject: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock, 0)
	in kernel_kexec()
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 17:12:40 +0800
Message-Id: <1218618760.24951.137.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compiling warning on xchg(&kexec_lock, 0) in kernel_kexec().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 kernel/kexec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1433,6 +1433,7 @@ module_init(crash_save_vmcoreinfo_init)
 int kernel_kexec(void)
 {
 	int error = 0;
+	int locked;
 
 	if (xchg(&kexec_lock, 1))
 		return -EBUSY;
@@ -1498,7 +1499,8 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	xchg(&kexec_lock, 0);
+	locked = xchg(&kexec_lock, 0);
+	BUG_ON(!locked);
 
 	return error;
 }


