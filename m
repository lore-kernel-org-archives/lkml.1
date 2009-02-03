Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZBCRWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZBCRWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZBCRWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:22:22 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:40133 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZBCRWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:22:21 -0500
X-BigFish: VPS5(zz936fM8b9dnzzzzz32i6bh6di43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KEI2WT-01-PSS-01
Date: Tue, 3 Feb 2009 18:22:00 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: APIC: enable workaround on AMD Fam10h CPUs
Message-ID: <20090203172200.GA3955@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Feb 2009 17:22:02.0918 (UTC) FILETIME=[EDD92C60:01C98623]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 3 Feb 2009 16:24:22 +0100
Subject: [PATCH] APIC: enable workaround on AMD Fam10h CPUs

Impact: fix to enable APIC for AMD Fam10h on chipsets with a missing/b0rked
	ACPI MP table (MADT)

Booting a 32bit kernel on an AMD Fam10h CPU running on chipsets with
missing/b0rked MP table leads to a hang pretty early in the boot process
due to the APIC not being initialized. Fix that by falling back to the
default APIC base address in 32bit code, as it is done in the 64bit
codepath.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 4b6df24..115449f 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1436,7 +1436,7 @@ static int __init detect_init_APIC(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
-		    (boot_cpu_data.x86 == 15))
+		    (boot_cpu_data.x86 >= 15))
 			break;
 		goto no_apic;
 	case X86_VENDOR_INTEL:
-- 
1.6.0.4

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

