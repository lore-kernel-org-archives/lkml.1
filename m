Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbZANLkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbZANLkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZANLkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:40:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbZANLke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:40:34 -0500
Date: Wed, 14 Jan 2009 12:40:06 +0100
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
Message-ID: <20090114114006.GF8625@elte.hu>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com> <m1d4esxfk2.fsf@frodo.ebiederm.org> <1231806563.4094.25.camel@perihelion.bos.jonmasters.org> <20090113014723.GA11366@elte.hu> <m1prirx3xn.fsf@frodo.ebiederm.org> <1231820798.4094.34.camel@perihelion.bos.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231820798.4094.34.camel@perihelion.bos.jonmasters.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0549]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jon Masters <jcm@redhat.com> wrote:

> On Mon, 2009-01-12 at 19:47 -0800, Eric W. Biederman wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> 
> > > a number of mainline drivers also mask/unmask irqs from within the IRQ 
> > > handler. It's not particularly smart in a native driver, but can happen - 
> > > and if we get an active line after that point (and this can happen because 
> > > the driver is active), we are in trouble.
> > 
> > Yep.  Right now it might be simpler to fix the mainline drivers.
> 
> Taking the easy option now doesn't make the pain go away later :) Just 
> because ACPI doesn't provide a handy description doesn't mean we 
> shouldn't handle "boot interrupts" - the kernel is riddled with quirks 
> already to deal with broken, buggy, or just quirky hardware scenarios.
> 
> > We are outside the descriptions provided by ACPI so it requires 
> > chipset specific knowledge, and a general understanding of how 
> > chipsets work to actually even comprehend the problem.
> 
> But how does that differ from most other chipset code? I'm not being 
> belligerent but I'm not seeing how your argument is uniquely special to 
> this particular situation. Personally, I'm a little biased because I'd 
> eventually like to see RT merged upstream and I /know/ that's going to 
> re-open this whole can of worms once again, even if it's "fixed" now.

it's not just -rt, but it is also needed for the concept of threaded IRQ 
handlers - which was discussed at the Kernel Summit to be desired for 
mainline.

	Ingo
