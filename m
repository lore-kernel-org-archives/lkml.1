Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYFZJbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYFZJbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:31:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYFZJb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:31:29 -0400
Date: Thu, 26 Jun 2008 11:31:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Len Brown <lenb@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let MPS support selectable
Message-ID: <20080626093103.GB20697@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806181432.57204.yhlu.kernel@gmail.com> <200806181729.31464.yhlu.kernel@gmail.com> <200806190018.45944.yhlu.kernel@gmail.com> <Pine.LNX.4.55.0806191600290.12929@cliff.in.clinika.pl> <86802c440806191039q5c6a2266p82d319a61a3bba3c@mail.gmail.com> <alpine.LFD.1.10.0806191350530.3040@localhost.localdomain> <Pine.LNX.4.55.0806191920080.12929@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806191920080.12929@cliff.in.clinika.pl>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> > However, I think that adding CONFIG_MPS before removing ACPI's 
> > depencency on mpparse.c has all risk and no value.
> 
>  Agreed.

that should be sorted out mostly in -tip/x86, Alexey Starikovskiy went 
through a marathon session decoupling them, about two months ago:

 $ git-shortlog --stat --author=astarikovskiy linus/master..tip/master

 Alexey Starikovskiy (12):
      x86: move es7000_plat out of mpparse.c
      x86: complete move ACPI from mpparse.c
      x86: make mp_ioapic_routing definition local
      x86: make struct config_ioapic not MPspec specific
      x86: make config_irqsrc not MPspec specific
      x86: fix mpparse/acpi interaction
      x86: Set pic_mode only if local apic code is present
      x86: move pic_mode to apic_32.c
      x86: move smp_found_config
      x86: mp_bus_id_to_pci_bus is not needed
      x86: move mp_bus_not_pci from mpparse.c
      x86: allow MPPARSE to be deselected in SMP configs

      22 files changed, 524 insertions(+), 501 deletions(-)

it's all in linux-next as well.

	Ingo
