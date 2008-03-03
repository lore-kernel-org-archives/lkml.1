Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYCCRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYCCRS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbYCCROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbYCCROd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:33 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 13/52] use disabled_cpus in i386
Date: Mon,  3 Mar 2008 14:12:41 -0300
Message-Id: <1204564400-17636-14-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-13-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch allows a cpu to be marked as present but disabled in i386,
just as x86_64 currently does.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/mpparse_32.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index f349e68..b2aded3 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -70,6 +70,8 @@ unsigned int boot_cpu_physical_apicid = -1U;
 /* Internal processor count */
 unsigned int num_processors;
 
+unsigned disabled_cpus __cpuinitdata;
+
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
@@ -108,8 +110,10 @@ static void __cpuinit MP_processor_info (struct mpc_config_processor *m)
  	int ver, apicid;
 	physid_mask_t phys_cpu;
  	
-	if (!(m->mpc_cpuflag & CPU_ENABLED))
+	if (!(m->mpc_cpuflag & CPU_ENABLED)) {
+		disabled_cpus++;
 		return;
+	}
 
 	apicid = mpc_apic_id(m, translation_table[mpc_record]);
 
-- 
1.5.0.6

