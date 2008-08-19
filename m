Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYHSAWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYHSAWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYHSAWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:22:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbYHSAWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:22:09 -0400
Date: Tue, 19 Aug 2008 02:21:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "macro@linux-mips.org" <macro@linux-mips.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: one more apic merging preliminary series
Message-ID: <20080819002142.GE9914@elte.hu>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com> <20080817124540.GF21434@elte.hu> <20080818203726.GB1152@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818203726.GB1152@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Sun, Aug 17, 2008 at 05:45:40AM -0700, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> > > Please review - any comments are welcome!
> > >
> > > For now it's like code bloating - but it's just preliminary series to
> > > make apic_*.c code more or less similar. And it's still a bit far from
> > > being ready to be merged down.
> > 
> > applied to tip/x86/apic - thanks Cyrill.
> > 
> > Maciej's point about cleaning up the x2apic impact is very much true -
> > i've Cc:-ed Suresh and Venki. Even if we wont truly use x2apic in 32-bit
> > kernels, it's a piece of glue hardware that does not depend on which
> > mode the CPU is in, so support for it should be bitsize agnostic. It
> > will also obviously be good for test coverage, once x2apic capable hw
> > will be more widespread.
> 
> Interrupt-remapping(part of chipset) must be enabled before 
> enabling/using x2apic mode.
> 
> So, there is little bit more work (adding the intr-remapping pieces to 
> 32bit kernel etc) to be done, before enabling x2apic for 32-bit kernel 
> aswell.
> 
> I am planning to do some work (introduce some kind of 
> interrupt-remapping ops and cleanup some of the code in the existing 
> io_apic_64.c), that will eventually make it easy to add 
> interrupt-remapping and x2apic to 32bit aswell.

Yinghai unified io_apic.c in latest tip/master, and that means that the 
CONFIG_INTR_REMAP bit are now all in 32-bit code as well. It's not yet 
enabled in the Kconfig:

 config INTR_REMAP
        bool "Support for Interrupt Remapping (EXPERIMENTAL)"
        depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL

but it should be a lot less work now i suspect.

	Ingo
