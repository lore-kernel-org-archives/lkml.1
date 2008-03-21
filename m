Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYCULsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYCULsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYCULsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:48:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYCULsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:48:08 -0400
Date: Fri, 21 Mar 2008 12:47:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
Message-ID: <20080321114752.GA25225@elte.hu>
References: <20080313180538.GC4620@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313180538.GC4620@cathedrallabs.org>
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


* Aristeu Rozanski <aris@ruivo.org> wrote:

> This patch includes code to handle NMI_IO_APIC enabling/disabling by
> nmi_watchdog proc file.

hm:

> +static void disable_ioapic_nmi_watchdog(void)
> +{
> +	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
> +}

stop_apic_nmi_watchdog() doesnt currently properly disable the 
generation of NMIs when they come from an IO-APIC, so this will need 
more fixes i believe. One approach would be to save the IO-APIC id and 
pin when the watchdog is set up, and use it later on to poke that 
IO-APIC register to disable NMI generation there.

	Ingo
