Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYHWNC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYHWNC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYHWNBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:01:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYHWNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vHyl6IokKBAgj7O6eTU3ltGxQRzFXxafHVmzPX9HLIEuiuK1kE1mWeT/eMktwvgmSk
         GMqOldcbKtQL1D8wiyYkfyRloDDkzHYU+NmxRJ4ez8UKJC2RqsEiw7gA8oyVjOrK4Pyk
         IpJb7fsS47I8ZG3lXA5f7oj0tK2vQhr3mkSRI=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/8] x86: apic_64.c - setup_APIC_timer has to be __cpuinit function
Date: Sat, 23 Aug 2008 17:01:18 +0400
Message-Id: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to hold this code if CPU_HOTPLUG is not
defined

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 37e0376..5c908dc 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -392,7 +392,7 @@ static void lapic_timer_broadcast(cpumask_t mask)
  * Setup the local APIC timer for this CPU. Copy the initilized values
  * of the boot CPU and register the clock event in the framework.
  */
-static void setup_APIC_timer(void)
+static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-- 
1.6.0.6.gc667

