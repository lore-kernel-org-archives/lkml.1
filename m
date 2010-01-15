Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0AOMRn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283Ab0AOMRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:17:43 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:59505 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab0AOMRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:17:42 -0500
Date: Fri, 15 Jan 2010 13:18:01 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de,
        Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (X86_MCE_P4THERMAL)
Message-ID: <20100115121801.GB3321@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	By this we noticed one occurenc of CONFIG_X86_MCE_P4THERMAL
is still in the kernel source as alternative to
CONFIG_X86_MCE_INTEL. The attached patch now only checks for the
latter which is still present.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

--CdrF4e02JqNVZeln
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-Drop-check-for-removed-config-variable-X86_MCE_P4THE.patch"

>From c312848eb2574c54a3effb39f3287b3d2c464518 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 15 Jan 2010 12:13:42 +0100
Subject: [PATCH 2/4] Drop check for removed config variable X86_MCE_P4THERMAL

With the removal of the old MCE code in
5bb38adcb54cf7192b154368ad62982caa11ca0b the config Item
X86_MCE_P4THERMAL was dropped from the kernel tree. However it was
left as a alternative in one block which is now also dropped hereby

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e80f291..8566b97 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2075,7 +2075,7 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
+#if defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
-- 
1.6.3.3


--CdrF4e02JqNVZeln--
