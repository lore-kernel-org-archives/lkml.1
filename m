Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbYCSUSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbYCSUSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYCSTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbYCSTi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:56 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 75/79] [PATCH] introduce smpboot_clear_io_apic
Date: Wed, 19 Mar 2008 14:26:10 -0300
Message-Id: <12059479112131-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947906258-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

x86_64 has two nr_ioapics = 0 statements. In 32-bit, it can be done
too. We do it through the smpboot_clear_io_apic() inline function,
to cope with subarchitectures (visws) that does not compile mpparse in

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c                 |    2 ++
 arch/x86/kernel/smpboot_64.c                 |    4 ++--
 include/asm-x86/mach-default/smpboot_hooks.h |    5 +++++
 include/asm-x86/mach-visws/smpboot_hooks.h   |    4 ++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index ae23b60..5a0f57f 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -155,6 +155,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
 			boot_cpu_physical_apicid);
 		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
+		smpboot_clear_io_apic();
 		return -1;
 	}
 
@@ -173,6 +174,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 			setup_local_APIC();
 			end_local_APIC_setup();
 		}
+		smpboot_clear_io_apic();
 		return -1;
 	}
 	return 0;
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index c66fb15..7752445 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -134,7 +134,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
 			boot_cpu_physical_apicid);
 		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
-		nr_ioapics = 0;
+		smpboot_clear_io_apic();
 		return -1;
 	}
 
@@ -145,7 +145,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated, forcing use of dummy APIC emulation.\n");
-		nr_ioapics = 0;
+		smpboot_clear_io_apic();
 		return -1;
 	}
 
diff --git a/include/asm-x86/mach-default/smpboot_hooks.h b/include/asm-x86/mach-default/smpboot_hooks.h
index 8e1c6c0..3ff2c5b 100644
--- a/include/asm-x86/mach-default/smpboot_hooks.h
+++ b/include/asm-x86/mach-default/smpboot_hooks.h
@@ -44,3 +44,8 @@ static inline void smpboot_setup_io_apic(void)
 	else
 		nr_ioapics = 0;
 }
+
+static inline void smpboot_clear_io_apic(void)
+{
+	nr_ioapics = 0;
+}
diff --git a/include/asm-x86/mach-visws/smpboot_hooks.h b/include/asm-x86/mach-visws/smpboot_hooks.h
index d926471..c9b83e3 100644
--- a/include/asm-x86/mach-visws/smpboot_hooks.h
+++ b/include/asm-x86/mach-visws/smpboot_hooks.h
@@ -22,3 +22,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 static inline void smpboot_setup_io_apic(void)
 {
 }
+
+static inline void smpboot_clear_io_apic(void)
+{
+}
-- 
1.5.0.6

