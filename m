Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZAFJCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZAFJCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZAFJCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:02:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZAFJCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:02:03 -0500
Date: Tue, 6 Jan 2009 10:01:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Cliff Wickman <cpw@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090106090138.GD29917@elte.hu>
References: <20090106060348.GA16738@wotan.suse.de> <86802c440901052238x5ff919f1u31360163e547b306@mail.gmail.com> <20090106064433.GB16738@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106064433.GB16738@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Jan 05, 2009 at 10:38:17PM -0800, Yinghai Lu wrote:
> > On Mon, Jan 5, 2009 at 10:03 PM, Nick Piggin <npiggin@suse.de> wrote:
> > > UV is fairly rare.... and much of the support is already there to cope with
> > > 32-bit builds. So this makes sense I think.
> > >
> > > --
> > > Make X86 SGI Ultraviolet support configurable. Saves about 13K of text size
> > > on my modest config.
> > >
> > >   text    data     bss     dec     hex filename
> > > 6770537 1158680  694356 8623573  8395d5 vmlinux
> > > 6757492 1157664  694228 8609384  835e68 vmlinux.nouv
> > >
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > ---
> > >  arch/x86/Kconfig                  |    7 +++++++
> > >  arch/x86/include/asm/genapic.h    |   24 ++++++++++++++++++++++++
> > >  arch/x86/include/asm/genapic_32.h |    7 -------
> > >  arch/x86/include/asm/genapic_64.h |    9 ---------
> > >  arch/x86/kernel/Makefile          |    5 +++--
> > >  arch/x86/kernel/entry_64.S        |    2 ++
> > >  arch/x86/kernel/genapic_64.c      |    3 ++-
> > >  arch/x86/kernel/io_apic.c         |    2 +-
> > >  8 files changed, 39 insertions(+), 20 deletions(-)
> > 
> > how about
> > kernel/efi.c:                   efi.uv_systab = config_tables[i].table;
> > ?
> 
> Good point, I missed that. Will resend a patch with that ifdef'ed 
> tomorrow unless any serious objections are raised.

Looks good to me, but please also extend the Makefile changes to 
kernel/tlb_uv.c, ./kernel/uv_sysfs.c, kernel/uv_irq.c, kernel/bios_uv.c - 
UV not just the genapic bits. Perhaps do it via gradual patches.

	Ingo
