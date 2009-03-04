Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZCDJ1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZCDJ1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZCDJ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:26:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:41739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZCDJ0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:26:37 -0500
Message-ID: <49AE4922.605@kernel.org>
Date: Wed, 04 Mar 2009 01:25:54 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: reserve exact size of mptable
References: <49AE485B.8000902@kernel.org> <49AE4901.3090801@kernel.org>
In-Reply-To: <49AE4901.3090801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

get the exact size for reserve_bootmem

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -716,10 +716,10 @@ static int __init smp_scan_config(unsign
 
 			if (!reserve)
 				return 1;
-			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
+			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
 					BOOTMEM_DEFAULT);
 			if (mpf->physptr) {
-				unsigned long size = PAGE_SIZE;
+				unsigned long size = get_mpc_size(mpf->physptr);
 #ifdef CONFIG_X86_32
 				/*
 				 * We cannot access to MPC table to compute
