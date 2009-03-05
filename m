Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZCEKbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZCEKbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZCEKb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:31:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:35698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZCEKbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:31:25 -0500
Date: Thu, 5 Mar 2009 10:30:30 GMT
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20090304220246.GC6288@sgi.com>
References: <20090304220246.GC6288@sgi.com>
Subject: [tip:x86/uv] x86: UV, SGI RTC: fix uv_time.c for UP
Message-ID: <tip-1400b3faab8fedfffde5a7fe47098e2732d4aa76@git.kernel.org>
Git-Commit-ID: 1400b3faab8fedfffde5a7fe47098e2732d4aa76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 10:30:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1400b3faab8fedfffde5a7fe47098e2732d4aa76
Gitweb:     http://git.kernel.org/tip/1400b3faab8fedfffde5a7fe47098e2732d4aa76
Author:     "Dimitri Sivanich" <sivanich@sgi.com>
AuthorDate: Wed, 4 Mar 2009 16:02:46 -0600
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 11:27:49 +0100

x86: UV, SGI RTC: fix uv_time.c for UP

Fix non-smp build of uv_time.c.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20090304220246.GC6288@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/uv_time.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 6f8e325..2ffb6c5 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -24,6 +24,8 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
 #include <asm/uv/uv.h>
+#include <asm/apic.h>
+#include <asm/cpu.h>
 
 #define RTC_NAME		"sgi_rtc"
 
@@ -84,7 +86,7 @@ static void uv_rtc_send_IPI(int cpu)
 	unsigned long apicid, val;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	apicid = cpu_physical_id(cpu);
 	pnode = uv_apicid_to_pnode(apicid);
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	      (apicid << UVH_IPI_INT_APIC_ID_SHFT) |
