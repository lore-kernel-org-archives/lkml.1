Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZDPVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZDPVox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDPVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:44:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:42294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbZDPVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:44:42 -0400
Subject: [PATCH -tip] x86: smpboot.c wakeup_secondary_cpu_via_nmi do not
 required __devinit
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 03:14:15 +0530
Message-Id: <1239918255.10567.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix section mismatch warning
 WARNING: arch/x86/built-in.o(.data+0x222c): Section mismatch in reference from the variable apic_numaq to the function .devinit.text:wakeup_secondary_cpu_via_nmi()
 The variable apic_numaq references
 the function __devinit wakeup_secondary_cpu_via_nmi()
 If the reference is valid then annotate the
 variable with __init* (see linux/init.h) or name the variable:
 *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/smpboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bf8ad63..483c2d3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -504,8 +504,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int __devinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+int wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
-- 
1.6.0.6



