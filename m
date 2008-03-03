Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYCCJRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYCCJRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYCCJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:17:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYCCJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:17:30 -0500
Date: Mon, 3 Mar 2008 10:17:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303091714.GA18250@elte.hu>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303091314.GC4457@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Mar 03, 2008 at 09:57:20AM +0100, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
> > > > May I keep them inline?
> > > 
> > > The problem with such manual inlines is that we force gcc to always 
> > > inline them - and history has shown that functions grow without the 
> > > "inline" being removed.
> > 
> > what do you mean by "we force gcc to always inline them"?
> 
> #define inline          inline          __attribute__((always_inline))
> 
> > gcc is free to decide whether to inline or to not inline.
> 
> Not with __attribute__((always_inline)).

but that wasnt used in the code you patched:

  -inline int acpi_battery_present(struct acpi_battery *battery)
  +static int acpi_battery_present(struct acpi_battery *battery)

> > (and CONFIG_FORCED_INLINING got removed from 2.6.25)
> 
> CONFIG_FORCED_INLINING never had any effect.

my experience was that it had effects. Why do you say it 'never had any 
effect'?

	Ingo
