Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbZDIOqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbZDIOqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764086AbZDIOpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:45:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:39760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755AbZDIOpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:45:43 -0400
Subject: [PATCH -tip] x86: apic/nmi.c prev_nmi_count should be unsigned
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 20:15:20 +0530
Message-Id: <1239288320.3296.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning:
  arch/x86/kernel/apic/nmi.c:158:27: warning: incorrect type in argument 2 (different signedness)
  arch/x86/kernel/apic/nmi.c:158:27:    expected int *prev_nmi_count
  arch/x86/kernel/apic/nmi.c:158:27:    got unsigned int *[assigned] prev_nmi_count

prev_nmi_count is a non-negative count so it should be unsigned

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index d6bd624..0205631 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -104,7 +104,7 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
-static void report_broken_nmi(int cpu, int *prev_nmi_count)
+static void report_broken_nmi(int cpu, unsigned int *prev_nmi_count)
 {
 	printk(KERN_CONT "\n");
 
-- 
1.6.0.6



