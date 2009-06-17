Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZFQQh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZFQQh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZFQQhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:37:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44820 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZFQQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SfcWpI7ZuMEtopixTvVK4EBwKXSWC2WEavMqiofscPiMbV88K+I3SvzdyngKnQfiXd
         O+msoMFhwirCOocPrJyxz0b/FkAJlgT3ANW/Y35UUa+6rcAfPFVNka5p+NxvW4/ABJ0O
         4mEbW3uEE34A2gi5DqvABgKc2YS6ic1AXPW/k=
Date: Wed, 17 Jun 2009 20:37:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:249
	native_apic_write_dummy
Message-ID: <20090617163714.GD10822@lenovo>
References: <19f34abd0906170811h36a7082asf68294db9490a049@mail.gmail.com> <20090617151439.GC4675@lenovo> <19f34abd0906170846k2a1ab1e9q36f2a47852fbb8a4@mail.gmail.com> <20090617155337.GA10822@lenovo> <19f34abd0906170933m6be38a4cv2e4f49c3b78d71c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19f34abd0906170933m6be38a4cv2e4f49c3b78d71c4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Wed, Jun 17, 2009 at 06:33:31PM +0200]
| 2009/6/17 Cyrill Gorcunov <gorcunov@gmail.com>:
| > Vegard, could you test the patch?
| >
| >        -- Cyrill
| > ---
| >
| > If we have apic disabled we don't even switch to APIC mode and do not
| > calling for connect_bsp_APIC. Though on SMP compiled kernel the
| > native_machine_shutdown does try to write the apic register anyway.
| > Fix it with explicit check if we really should touch apic registers.
| >
| > Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| >  arch/x86/kernel/apic/io_apic.c |    4 +++-
| >  1 file changed, 3 insertions(+), 1 deletion(-)
| >
| > Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
| > =====================================================================
| > --- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
| > +++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
| > @@ -2003,7 +2003,9 @@ void disable_IO_APIC(void)
| >        /*
| >         * Use virtual wire A mode when interrupt remapping is enabled.
| >         */
| > -       disconnect_bsp_APIC(!intr_remapping_enabled && ioapic_i8259.pin != -1);
| > +       if (cpu_has_apic)
| > +               disconnect_bsp_APIC(!intr_remapping_enabled &&
| > +                               ioapic_i8259.pin != -1);
| >  }
| >
| >  #ifdef CONFIG_X86_32
| >
| 
| Seems to work here:
| 
| [  317.596743] ACPI: Preparing to enter system sleep state S5
| [  317.633421] Disabling non-boot CPUs ...
| [  317.637493] Power down.
| [  317.638305] acpi_power_off called
| 
| and no warning.
| 
| Thanks!
| 
| 
| Vegard
|

Thanks for testing Vegard! I'll recheck again and send
properly formed patch a bit later.
 
	-- Cyrill
