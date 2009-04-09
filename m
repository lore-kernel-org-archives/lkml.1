Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbZDIOav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbZDIOav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbZDIOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:30:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:59669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758679AbZDIOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:30:39 -0400
Subject: [PATCH -tip] x86: apic/probe_32.c declare apic_default before they
 get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 20:00:16 +0530
Message-Id: <1239287416.3296.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning:
  arch/x86/kernel/apic/probe_32.c:96:13: warning: symbol 'apic_default' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/apic.h     |    3 +++
 arch/x86/kernel/apic/probe_32.c |    1 -
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..5773660 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -478,6 +478,9 @@ static inline unsigned int read_apic_id(void)
 extern void default_setup_apic_routing(void);
 
 #ifdef CONFIG_X86_32
+
+extern struct apic apic_default;
+
 /*
  * Set up the logical destination ID.
  *
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 01eda2a..440a8bc 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -160,7 +160,6 @@ extern struct apic apic_summit;
 extern struct apic apic_bigsmp;
 extern struct apic apic_es7000;
 extern struct apic apic_es7000_cluster;
-extern struct apic apic_default;
 
 struct apic *apic = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
-- 
1.6.0.6



