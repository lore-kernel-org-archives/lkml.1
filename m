Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXKYUZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXKYUZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 15:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXKYUZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 15:25:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33551 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbXKYUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 15:25:24 -0500
Date: Sun, 25 Nov 2007 21:25:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: [patch] Re: nohz and strange sleep latencies
Message-ID: <20071125202557.GB7739@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu> <20071122185238.GA1821@elf.ucw.cz> <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Okay, so the problem seems to be we are using unreliable lapic
timer... which is stopped in C3 (and in C2 on broken machines).

I do not see any mechanism to disable lapic; there seems to be some
mechanism to work around stopped lapic timer is used (in
acpi/processor_idle.c) but it does not seem to work. So what about
this?

							Pavel
Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 08b07c1..b9bf79c 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -63,8 +63,8 @@ static int enable_local_apic __initdata 
 static int local_apic_timer_verify_ok;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk
    or using CPU MSR check */
-int local_apic_timer_disabled;
-/* Local APIC timer works in C2 */
+int local_apic_timer_disabled = 1;
+/* Local APIC timer works in C2: used in processor_idle.c  */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
