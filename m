Return-Path: <linux-kernel-owner+w=401wt.eu-S936698AbZLQEnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936698AbZLQEnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763595AbZLQEDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:54 -0500
Received: from kroah.org ([198.145.64.141]:55314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761372AbZLQEDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:45 2009
Message-Id: <20091217035645.802252912@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikael Pettersson <mikpe@it.uu.se>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [022/151] x86, apic: Enable lapic nmi watchdog on AMD Family 11h
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

commit 7d1849aff6687a135a8da3a75e32a00e3137a5e2 upstream.

The x86 lapic nmi watchdog does not recognize AMD Family 11h,
resulting in:

  NMI watchdog: CPU not supported

As far as I can see from available documentation (the BKDM),
family 11h looks identical to family 10h as far as the PMU
is concerned.

Extending the check to accept family 11h results in:

  Testing NMI watchdog ... OK.

I've been running with this change on a Turion X2 Ultra ZM-82
laptop for a couple of weeks now without problems.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <19223.53436.931768.278021@pilspetsen.it.uu.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -712,7 +712,7 @@ static void probe_nmi_watchdog(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
+		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
 			return;
 		wd_ops = &k7_wd_ops;
 		break;


