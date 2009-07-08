Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZGHUHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZGHUHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZGHUHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:07:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46649 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbZGHUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Lh7FviCD/jjWjWPaB0BEWCtehGCKtbBe91reddygP5emQxdCMS+nJG6LusmiAMPR3M
         JVVGyq+6LqMXvuAVsM4JfBzhwl3XK+MiSCHIJ724iVneemnv8zc7xQf+UB8UgcRch0W2
         3YTh9FPcIfWIrIiSeov10ULMBmkjMm6mgMZ08=
Date: Thu, 9 Jul 2009 00:07:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86,apic -- don't forget to disconnect BSP discrete
	apic
Message-ID: <20090708200741.GI5301@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of discrete APIC cpu_has_apic could be not set.
This leads to disconnect_bsp_APIC is not called where
it should.

Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review.

 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -2002,7 +2002,7 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	if (cpu_has_apic)
+	if (cpu_has_apic || smp_found_config)
 		disconnect_bsp_APIC(!intr_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }
