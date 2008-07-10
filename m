Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbYGJTys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbYGJTys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYGJTyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:54:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbYGJTyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:54:38 -0400
Date: Thu, 10 Jul 2008 21:54:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080710195425.GB23322@elte.hu>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com> <20080710171721.GA19737@elte.hu> <20080710181234.GA32174@elte.hu> <20080710195249.GB17255@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710195249.GB17255@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, Jul 10, 2008 at 08:12:34PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Robert Richter <robert.richter@amd.com> wrote:
> > > 
> > > > This patch series contains patches for tip/x86/unify-pci. It fixes 
> > > > NUMA initialization code reflecting latest changes in tip/master. 
> > > > Also there are build fixes and minor cleanups. Patch #5 is a cherry 
> > > > pick that fixes build on UP systems. Code reboots for smp/nosmp, 
> > > > acpi/noacpi, numaq, 32/64bit. It compiles for visws.
> > > 
> > > thanks Robert. Today i've eliminated the VISWS subarch which greatly 
> > > simplified your series. I've picked up these two fixes:
> > > 
> > >  Robert Richter (2):
> > >        x86/pci merge: fixing numaq initialization
> > >        x86/pci: fix warnings in subsys_initcall functions
> > 
> > btw., this is how arch/x86/pci/Makefile looks like now in tip/master:
> > 
> > ----------------------------------------->
> > pci-y                           := fixup.o
> > pci-$(CONFIG_ACPI)              += acpi.o
> > pci-y                           += legacy.o irq.o
> > 
> > pci-$(CONFIG_X86_VISWS)         += visws.o
> > 
> > pci-$(CONFIG_X86_NUMAQ)         += numa.o
> > 
> > obj-y                           += $(pci-y) common.o early.o
> > obj-y                           += amd_bus.o
> > <-----------------------------------------
> 
> So if I am not mistaken you can kill pci-y entirely:
> 
> obj-y                           := fixup.o
> obj-$(CONFIG_ACPI)              += acpi.o
> obj-y                           += legacy.o irq.o
> 
> obj-$(CONFIG_X86_VISWS)         += visws.o
> 
> obj-$(CONFIG_X86_NUMAQ)         += numa.o
> 
> obj-y                           += common.o early.o
> obj-y                           += amd_bus.o

ah, indeed :-) Very nice.

	Ingo
