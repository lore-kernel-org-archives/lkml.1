Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYGVMKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYGVMKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYGVMJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:09:55 -0400
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:40090 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYGVMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:09:52 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 08:09:52 EDT
Date: Tue, 22 Jul 2008 14:00:47 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] Fix crash due to missing debugctlmsr on AMD K6-3
Message-ID: <20080722120047.GA6795@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

currently if you use PTRACE_SINGLEBLOCK on AMD K6-3 (i586) it will crash.
Kernel now wrongly assumes existing DEBUGCTLMSR MSR register there.

Removed the assumption also for some other non-K6 CPUs but I am not sure there
(but it can only bring small inefficiency there if my assumption is wrong).

Based on info from Roland McGrath, Chuck Ebbert and Mikulas Patocka.
More info at:
	https://bugzilla.redhat.com/show_bug.cgi?id=456175

Please Cc me in a reply.


Regards,
Jan

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="linux-2.6.26-debugctlmsr-k6.patch"

Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>

--- linux-2.6.26/arch/x86/Kconfig.cpu-orig	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.26/arch/x86/Kconfig.cpu	2008-07-22 13:44:19.000000000 +0200
@@ -414,4 +414,4 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)

--zhXaljGHf11kAtnf--
