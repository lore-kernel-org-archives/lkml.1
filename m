Return-Path: <linux-kernel-owner+w=401wt.eu-S1763697AbYCSUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697AbYCSUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYCSTig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103AbYCSTi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:28 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 40/79] [PATCH] wipe get_nmi_reason out of nmi_64.h
Date: Wed, 19 Mar 2008 14:25:35 -0300
Message-Id: <12059477561937-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477521176-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

use mach_traps when it is supposed to be used.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/nmi_64.c   |    2 ++
 arch/x86/kernel/traps_64.c |    2 ++
 include/asm-x86/nmi_64.h   |    2 --
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index bd0fac5..5a29ded 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -26,6 +26,8 @@
 #include <asm/proto.h>
 #include <asm/mce.h>
 
+#include <mach_traps.h>
+
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 int panic_on_unrecovered_nmi;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3d36144..6d883b1 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -33,6 +33,8 @@
 #include <linux/kdebug.h>
 #include <linux/utsname.h>
 
+#include <mach_traps.h>
+
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
 #endif
diff --git a/include/asm-x86/nmi_64.h b/include/asm-x86/nmi_64.h
index 2eeb74e..94a5b19 100644
--- a/include/asm-x86/nmi_64.h
+++ b/include/asm-x86/nmi_64.h
@@ -36,8 +36,6 @@ static inline void unset_nmi_pm_callback(struct pm_dev * dev)
 extern void default_do_nmi(struct pt_regs *);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 
-#define get_nmi_reason() inb(0x61)
-
 extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
-- 
1.5.0.6

