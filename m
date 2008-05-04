Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYEDRUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYEDRUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYEDRUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:20:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55292 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYEDRUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:20:35 -0400
Date: Sun, 4 May 2008 19:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Toralf F?rster <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #487 for v2.6.26-rc1-6-gafa26be :undefined
	reference to `es7000_plat'
Message-ID: <20080504172023.GA3858@elte.hu>
References: <200805041535.55503.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805041535.55503.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Toralf F?rster <toralf.foerster@gmx.de> wrote:

> Hello,
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/x86/mach-generic/built-in.o: In function `es7000_rename_gsi':
> es7000plat.c:(.text+0xb52): undefined reference to `es7000_plat'

fix for that got queued in x86.git yesterday - see below.

	Ingo

------------------->
Subject: x86: es7000 build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 03 22:01:31 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/mpparse.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/mpparse.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/mpparse.c
+++ linux-x86.q/arch/x86/kernel/mpparse.c
@@ -794,6 +794,11 @@ void __init find_smp_config(void)
                             ACPI-based MP Configuration
    -------------------------------------------------------------------------- */
 
+/*
+ * Keep this outside and initialized to 0, for !CONFIG_ACPI builds:
+ */
+int es7000_plat;
+
 #ifdef CONFIG_ACPI
 
 #ifdef	CONFIG_X86_IO_APIC
@@ -909,8 +914,6 @@ void __init mp_override_legacy_irq(u8 bu
 	MP_intsrc_info(&intsrc);
 }
 
-int es7000_plat;
-
 void __init mp_config_acpi_legacy_irqs(void)
 {
 	struct mpc_config_intsrc intsrc;
