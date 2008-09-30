Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYI3UCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYI3UCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYI3UCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:02:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYI3UCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:02:32 -0400
Date: Tue, 30 Sep 2008 22:01:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
	in quirk_system_pci_resources()
Message-ID: <20080930200130.GA23954@elte.hu>
References: <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu> <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > so instead of the current hardcoded levels:
> > 
> >   core_initcall(sysctl_init);
> > 
> > we could have natural constructs like:
> > 
> >   initcall_depends_on(sysctl_init, securityfs_init);
> >   initcall_depends_on(sock_init, sysctl_init)
> 
> would be a TOTAL DISASTER, because if you do that, then you are 
> essentially back to the insane situation where people need to know 
> what other parts are enabled.

well, as i mentioned it was and is on the backburner, because we went 
over the same list of problems that you mentioned: harder to read and 
interpret and debug, harder to reproduce boot ordering, etc.

but i'd still like the address the above specific point: it would be 
silly to propagate Kconfig dependencies into the initcall dependencies, 
why do you assume we'd do that?

When PROCFS or PNP is turned off, then their initcall symbols should 
naturally alias to some NOP definition, a function that is immediately 
marked as 'done'. We _already_ have NOP stubs for many initializer 
symbols.

and note:

> > ( More details: we'd have a number of compatibility and convenience
> >   symbols as well - well-known initialization stages for various 
> >   customary phases of bootup.

One convenience symbol would be "memory_done()": to indicate that 
kmalloc() and all the other memory allocators are up and running and 
usable.

	Ingo
