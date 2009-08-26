Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbZHZTNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbZHZTNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZHZTNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:13:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:37744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZHZTNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:13:51 -0400
Date: Wed, 26 Aug 2009 19:13:19 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090826171324.GC4548@lenovo>
References: <20090826171324.GC4548@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Slim down stack usage in early_init_lapic_mapping()
Message-ID: <tip-d3a247bfb2c26f5b67367d58af7ad8c2efbbc6c1@git.kernel.org>
Git-Commit-ID: d3a247bfb2c26f5b67367d58af7ad8c2efbbc6c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 19:13:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3a247bfb2c26f5b67367d58af7ad8c2efbbc6c1
Gitweb:     http://git.kernel.org/tip/d3a247bfb2c26f5b67367d58af7ad8c2efbbc6c1
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 26 Aug 2009 21:13:24 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 20:26:23 +0200

x86, apic: Slim down stack usage in early_init_lapic_mapping()

As far as I see there is no external poking of mp_lapic_addr in
this procedure which could lead to unpredited changes and
require local storage unit for it. Lets use it plain forward.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090826171324.GC4548@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3fc3a6c..159740d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1562,8 +1562,6 @@ no_apic:
 #ifdef CONFIG_X86_64
 void __init early_init_lapic_mapping(void)
 {
-	unsigned long phys_addr;
-
 	/*
 	 * If no local APIC can be found then go out
 	 * : it means there is no mpatable and MADT
@@ -1571,11 +1569,9 @@ void __init early_init_lapic_mapping(void)
 	if (!smp_found_config)
 		return;
 
-	phys_addr = mp_lapic_addr;
-
-	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
+	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, phys_addr);
+		    APIC_BASE, mp_lapic_addr);
 
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
