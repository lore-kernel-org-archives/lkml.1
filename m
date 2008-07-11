Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYGKIy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYGKIy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYGKIyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:54:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48402 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYGKIyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:54:21 -0400
Date: Fri, 11 Jul 2008 10:54:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [x86, patch] turn x86 VISWS into a generic architecture
Message-ID: <20080711085407.GB20987@elte.hu>
References: <20080710170712.GA14583@elte.hu> <20080711083946.GU7963@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711083946.GU7963@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 10.07.08 19:07:12, Ingo Molnar wrote:
> 
> [...]
> 
> > diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> > index 99d9f09..e515e8d 100644
> > --- a/arch/x86/pci/Makefile
> > +++ b/arch/x86/pci/Makefile
> > @@ -9,9 +9,7 @@ pci-y				:= fixup.o
> >  pci-$(CONFIG_ACPI)		+= acpi.o
> >  pci-y				+= legacy.o irq.o
> >  
> > -# Careful: VISWS overrule the pci-y above. The colons are
> > -# therefor correct. This needs a proper fix by distangling the code.
> > -pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
> > +pci-$(CONFIG_X86_VISWS)		+= visws.o
> 
> Ingo, if we turn this into generic code, we have to remove the 
> subsys_initcall for this too. Otherwise subsystem initialization is 
> running twice, in legacy.c and in visws.c.

Ok. Mind sending a patch for this against tip/master? Both your changes 
and the visws cleanups are all in there and are tested through on 
typical hardware.

(Also, there's the suggestion from Yinghai to first do the numa init.)

	Ingo
