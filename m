Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYHXJDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYHXJDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYHXJC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:02:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:51456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYHXJC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u9S/g5VYZHOnnr5UlVyKnaLkAI7FwDm4W1Qw3WziRmPkUWkjMMXcz0T02RljktOfQ3
         gtGQ7m2CAqtRjqG+Kxp0JlvFibvtPUYq2qKqtiFff55rKW99KC9A+RWJLLW+Je1sUFui
         v+mSTdELDxvXYf+R3hCKTKJOgwIh/LUqdMiJM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 02/18] x86: apic - introduce get_physical_broadcast for 64bit
Date: Sun, 24 Aug 2008 02:01:40 -0700
Message-Id: <1219568516-681-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

We don't really use it now on 64bit mode but
could reserve it for future.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_64.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 8f55127..bb46711 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -244,6 +244,16 @@ void __cpuinit enable_NMI_through_LVT0(void)
 	apic_write(APIC_LVT0, v);
 }
 
+#ifdef CONFIG_X86_32
+/**
+ * get_physical_broadcast - Get number of physical broadcast IDs
+ */
+int get_physical_broadcast(void)
+{
+	return modern_apic() ? 0xff : 0xf;
+}
+#endif
+
 /**
  * lapic_get_maxlvt - get the maximum number of local vector table entries
  */
-- 
1.5.4.5

