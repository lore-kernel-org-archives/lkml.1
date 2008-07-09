Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYGIJmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYGIJmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 05:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYGIJmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 05:42:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYGIJmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 05:42:12 -0400
Date: Wed, 9 Jul 2008 11:41:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/11] x86/pci 32/64 bit merge
Message-ID: <20080709094151.GA22641@elte.hu>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
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

> This patch series merges the x86/pci code. It's relative to 
> tip/x86/cpu since there are already changes that touch pci code.
> 
> I reworked parts of the subsys_initcalls to remove Makefile object 
> order dependencies. The kernel reboots for acpi/noacpi, smp/nosmp, 
> 32/64 bit. It compiles for numaq and visws (I don't have hardware 
> available for this configurations, so please test these configs if you 
> have hardware available).
> 
> There is still some work to do in arch/x86/pci/amd_bus.c and for 
> mmconfig.

Robert, since this series interacts quite a bit with other bits in 
tip/x86/* i've merged it up into a new topic: tip/x86/unify-pci and 
started testing it:

 Robert Richter (11):
      x86/pci: Makefile merge: Removing Makefile_*
      x86/pci: Makefile merge: removing include dir flag
      x86/pci: Makefile merge: whitespace changes only
      x86/pci: Makefile merge: decoupling options for mp_bus_to_node.o
      x86/pci: Makefile merge: changing 64bit ordering
      x86/pci: Makefile merge: creating pci-y for 64 bit
      x86/pci: mp_bus_to_node merge: moving code in amd_bus.c
      x86/pci: merge: moving mp_bus_to_node.c to amd_bus.c
      x86/pci: Makefile merge: coalescing 32 and 64 bit
      x86/pci: visws: renaming pcibios_init()
      x86/pci: removing subsys_initcall ordering dependencies

You can have a look by pulling this branch into a -git based tree:

   git-pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/unify-pci

	Ingo
