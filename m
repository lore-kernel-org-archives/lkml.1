Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYCRFYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYCRFYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYCRFYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:06 -0400
Received: from gw.goop.org ([64.81.55.164]:37832 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYCRFYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 30 of 31] xen: no need for domU to worry about MCE/MCA
X-Mercurial-Node: 0f9569b38edd34d5e0675ce234090ebfcb811c13
Message-Id: <0f9569b38edd34d5e067.1205797041@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mask MCE/MCA out of cpu caps.  Its harmless to leave them there, but
it does prevent the kernel from starting an unnecessary thread.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -155,6 +155,8 @@
 	if (*ax == 1)
 		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
 			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
+			    (1 << X86_FEATURE_MCE)  |  /* disable MCE */
+			    (1 << X86_FEATURE_MCA)  |  /* disable MCA */
 			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
 
 	asm(XEN_EMULATE_PREFIX "cpuid"


