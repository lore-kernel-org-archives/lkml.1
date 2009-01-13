Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZAMBsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZAMBsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZAMBr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:47:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbZAMBr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:47:58 -0500
Date: Tue, 13 Jan 2009 02:47:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jon Masters <jcm@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Stefan Assmann <sassmann@suse.de>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090113014723.GA11366@elte.hu>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com> <m1d4esxfk2.fsf@frodo.ebiederm.org> <1231806563.4094.25.camel@perihelion.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231806563.4094.25.camel@perihelion.bos.jonmasters.org>
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


* Jon Masters <jcm@redhat.com> wrote:

> On Mon, 2009-01-12 at 15:36 -0800, Eric W. Biederman wrote:
> 
> > This hardware behavior is not specific to boot interrupts or Intel.
> 
> It's not specific to Intel, but it is a specific compatibility behavior.
> 
> > Is this case really so interesting and compelling that we want to 
> > fight through and figure what we need to do to make this work reliably 
> > on every x86 chipset?
> 
> How else do you propose implementing IRQ handling in e.g. the RT kernel? 
> We get a hardware interrupt, we can't FastEOI, we can't process 
> synchronously, we can't do all of those things you might expect. 
> Implementing RT requires that we delay handling of the IRQ until 
> arbitrarily later in the future when we get around to it.

a number of mainline drivers also mask/unmask irqs from within the IRQ 
handler. It's not particularly smart in a native driver, but can happen - 
and if we get an active line after that point (and this can happen because 
the driver is active), we are in trouble.

	Ingo
