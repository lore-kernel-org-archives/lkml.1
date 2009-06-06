Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZFFWRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZFFWRM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZFFWQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:49154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFFWQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:16:59 -0400
Message-ID: <4A2AEAC6.8060404@kernel.org>
Date: Sat, 06 Jun 2009 15:16:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix dummy apic read/write warning
References: <20090606073737.GA3163@elte.hu>
In-Reply-To: <20090606073737.GA3163@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ingo got
[    0.000000] Using APIC driver default
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] APIC: disable apic facility
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/apic/apic.c:254 native_apic_read_dummy+0x2d/0x3b()
[    0.000000] Hardware name: HP OmniBook PC

we have wrong check in dummy read and write.
[we only test on system that have APIC with "disableapic"...]

Signed-off-by: yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -246,12 +246,12 @@ static int modern_apic(void)
  */
 static void native_apic_write_dummy(u32 reg, u32 v)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 }
 
 static u32 native_apic_read_dummy(u32 reg)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 	return 0;
 }
 

