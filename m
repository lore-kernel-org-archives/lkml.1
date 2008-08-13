Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYHMBEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYHMBEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYHMBEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:04:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:18562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYHMBEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,198,1217833200"; 
   d="scan'208";a="606287380"
Subject: [PATCH] kexec jump: fix code size checking
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 09:04:35 +0800
Message-Id: <1218589475.24951.59.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building issue when CONFIG_KEXEC=n. Thanks to Vivek Goyal for his
reminding.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/asm-x86/kexec.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -43,6 +43,9 @@
 
 #ifdef CONFIG_X86_32
 # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
+# ifndef CONFIG_KEXEC
+#  define kexec_control_code_size	0
+# endif
 #endif
 
 #ifndef __ASSEMBLY__


