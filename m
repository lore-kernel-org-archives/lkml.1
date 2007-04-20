Return-Path: <linux-kernel-owner+w=401wt.eu-S1767303AbXDTWzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767303AbXDTWzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767306AbXDTWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:55:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767303AbXDTWy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:54:59 -0400
Message-ID: <462944B3.8060304@redhat.com>
Date: Fri, 20 Apr 2007 18:54:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>
Subject: [RFC PATCH 3/3] x86: use the x86 CPU feature API
References: <4629438C.4070209@redhat.com>
In-Reply-To: <4629438C.4070209@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010208050203090008000200"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010208050203090008000200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------010208050203090008000200
Content-Type: text/plain;
 name="x86_use_cpu_api.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_use_cpu_api.patch"

x86: use the x86 CPU feature API

Just a small demo for now.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
---
 arch/i386/kernel/cpu/amd.c    |    4 ++--
 arch/i386/kernel/cpu/common.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- 2.6.21-rc7-d390.orig/arch/i386/kernel/cpu/amd.c
+++ 2.6.21-rc7-d390/arch/i386/kernel/cpu/amd.c
@@ -109,8 +109,8 @@ static void __cpuinit init_amd(struct cp
 			{
 				/* Based on AMD doc 20734R - June 2000 */
 				if ( c->x86_model == 0 ) {
-					clear_bit(X86_FEATURE_APIC, c->x86_capability);
-					set_bit(X86_FEATURE_PGE, c->x86_capability);
+					clear_cpu_feature(APIC, c);
+					set_cpu_feature(PGE, c);
 				}
 				break;
 			}
--- 2.6.21-rc7-d390.orig/arch/i386/kernel/cpu/common.c
+++ 2.6.21-rc7-d390/arch/i386/kernel/cpu/common.c
@@ -381,7 +381,7 @@ void __cpuinit identify_cpu(struct cpuin
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
 	c->x86_clflush_size = 32;
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
+	clear_all_cpu_features(c);
 
 	if (!have_cpuid_p()) {
 		/* First of all, decide if this is a 486 or higher */

--------------010208050203090008000200--
