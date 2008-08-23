Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbYHWNBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbYHWNBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYHWNA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:00:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:19071 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHWNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m3a3xMbcJEChr0DDnyf/nmNFCelMdQTkstu4LoJTBKwwXwnsdFe1cabi5hyS2bwDa8
         dxO0bom7kG9SREXlb6ns4ye1jLrMjpccw3DNGoKYP5Ea0vaWhWnrvKa9yA+G85NGMNoi
         ibBe+9tT9eHDK0+N6ilkI8ZSB2UiDDTWSKvxo=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/8] x86: apic - unify setup_apicpmtimer
Date: Sat, 23 Aug 2008 17:01:20 +0400
Message-Id: <ecaafcc0376077fa7b0c90c501d6dad0f745ab2d.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   10 ++++++++++
 arch/x86/kernel/apic_64.c |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index b8d80c2..ad295cf 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1778,6 +1778,16 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
+#ifdef CONFIG_X86_64
+static __init int setup_apicpmtimer(char *s)
+{
+	apic_calibrate_pmtmr = 1;
+	notsc_setup(NULL);
+	return 0;
+}
+__setup("apicpmtimer", setup_apicpmtimer);
+#endif
+
 static int __init apic_set_verbosity(char *arg)
 {
 	if (!arg)  {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 6272c60..03641d7 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1806,6 +1806,7 @@ static int __init parse_nolapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_nolapic_timer);
 
+#ifdef CONFIG_X86_64
 static __init int setup_apicpmtimer(char *s)
 {
 	apic_calibrate_pmtmr = 1;
@@ -1813,6 +1814,7 @@ static __init int setup_apicpmtimer(char *s)
 	return 0;
 }
 __setup("apicpmtimer", setup_apicpmtimer);
+#endif
 
 static int __init apic_set_verbosity(char *arg)
 {
-- 
1.6.0.6.gc667

