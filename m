Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbYCZSX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbYCZSX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYCZSXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:23:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55642 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbYCZSXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:23:51 -0400
Date: Wed, 26 Mar 2008 19:23:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
Message-ID: <20080326182333.GA11187@elte.hu>
References: <20080313180538.GC4620@cathedrallabs.org> <20080321114752.GA25225@elte.hu> <20080326152417.GE25854@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326152417.GE25854@cathedrallabs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0758]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aristeu Rozanski <aris@ruivo.org> wrote:

> > stop_apic_nmi_watchdog() doesnt currently properly disable the 
> > generation of NMIs when they come from an IO-APIC, so this will need 
> > more fixes i believe. One approach would be to save the IO-APIC id and 
> > pin when the watchdog is set up, and use it later on to poke that 
> > IO-APIC register to disable NMI generation there.
> the patch I sent has this change:
> 
> @@ -270,6 +270,8 @@ void stop_apic_nmi_watchdog(void *unused
>                 return;
>         if (nmi_watchdog == NMI_LOCAL_APIC)
>                 lapic_watchdog_stop();
> +       else
> +               __acpi_nmi_disable(NULL);
>         __get_cpu_var(wd_enabled) = 0;
>         atomic_dec(&nmi_active);
>  }
> 
> and:
> static void __acpi_nmi_disable(void *__unused)
> {       
>         apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
> }
> 
> do you think this isn't enough?

but this stops all NMIs, not just the IO-APIC generated ones, doesnt it? 

	Ingo
