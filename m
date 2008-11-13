Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYKMR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYKMR4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYKMR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:56:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:46481 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751618AbYKMR4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:56:04 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18Ih9AMGr8Ij0XSB1TdY1yFhMCB24lq9NLtHfN5Nu
	RbOqrwbmZGhIu6
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Kyle Mc Martin <kyle@hera.kernel.org>, linux-parisc@vger.kernel.org
Subject: [PATCH] fix cpumask build breakage on parisc
Date: Thu, 13 Nov 2008 18:55:54 +0100
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131855.55450.deller@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:
	2d3854a37e8b767a51aba38ed6d22817b0631e33
	cpumask: introduce new API, without changing anything

introduced a build breakage on parisc.

This trivial patch fixes it.


Signed-off-by: Helge Deller <deller@gmx.de>
CC:	Rusty Russell <rusty@rustcorp.com.au>
CC:	akpm@linux-foundation.org
CC:	torvalds@linux-foundation.org
CC:	Kyle Mc Martin <kyle@hera.kernel.org>
	

--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -44,8 +44,6 @@ extern void arch_send_call_function_ipi(cpumask_t mask);
  
 #define PROC_CHANGE_PENALTY	15		/* Schedule penalty */
 
-extern unsigned long cpu_present_mask;
-
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 #else /* CONFIG_SMP */
