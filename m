Return-Path: <linux-kernel-owner+w=401wt.eu-S933764AbYDQBZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbYDQBZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760907AbYDQBJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:07 -0400
Received: from sous-sol.org ([216.99.217.87]:58973 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759487AbYDQBJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:05 -0400
Message-Id: <20080417010327.627675797@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>
Subject: xen: mask out SEP from CPUID
Content-Disposition: inline; filename=xen-mask-out-sep-from-cpuid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeremy Fitzhardinge <jeremy@xensource.com>

upstream commit: d40e705903397445c6861a0a56c23e5b2e8f9b9a

Fix 32-on-64 pvops kernel:

we don't want userspace using syscall/sysenter, even if the hypervisor
supports it, so mask it out from CPUID.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/xen/enlighten.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -153,6 +153,7 @@ static void xen_cpuid(unsigned int *eax,
 	if (*eax == 1)
 		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
 			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
+			    (1 << X86_FEATURE_SEP)  |  /* disable SEP */
 			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
 
 	asm(XEN_EMULATE_PREFIX "cpuid"

-- 
