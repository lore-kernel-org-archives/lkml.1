Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYHWNBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYHWNBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYHWNA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:00:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:13629 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYHWNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ihtrs5QPJTRl2tIN/DVhUM+pnTDt8ArosCV9wjEvCxSfy7LEJvO6hW/Tqtfe6T2HoS
         8i7KTAbymOKmrdBnmj5LmRlCO9wA4Ylo6oK2SASl6RNJGjXNbR3lP1GUGBoerAHst8qB
         Yto23iuTba5+mWitMIGDQgqVHovZp+GLjWLNY=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/8] x86: apic - introduce get_physical_broadcast for 64bit
Date: Sat, 23 Aug 2008 17:01:19 +0400
Message-Id: <919ba12b3b4b9748ef7ed17fc92ca053e81a6507.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't really use it now on 64bit mode but
could reserve it for future.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_64.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5c908dc..6272c60 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -241,6 +241,14 @@ void __cpuinit enable_NMI_through_LVT0(void)
 }
 
 /**
+ * get_physical_broadcast - Get number of physical broadcast IDs
+ */
+int get_physical_broadcast(void)
+{
+	return modern_apic() ? 0xff : 0xf;
+}
+
+/**
  * lapic_get_maxlvt - get the maximum number of local vector table entries
  */
 int lapic_get_maxlvt(void)
-- 
1.6.0.6.gc667

