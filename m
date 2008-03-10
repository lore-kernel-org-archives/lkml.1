Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYCJGaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYCJGaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 02:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYCJG37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 02:29:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59887 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYCJG36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 02:29:58 -0400
Date: Mon, 10 Mar 2008 07:29:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
Message-ID: <20080310062944.GA31542@elte.hu>
References: <20080309200103.GA895@mailshack.com> <20080309201016.GA28454@elte.hu> <1205097195.13205.1241421773@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205097195.13205.1241421773@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> > ok, that's rather convincing.
> > 
> > the generic version in lib/find_next_bit.c is open-coded C which gcc 
> > can optimize pretty nicely.
> > 
> > the hand-coded assembly versions in arch/x86/lib/bitops_32.c mostly 
> > use the special x86 'bit search forward' (BSF) instruction - which i 
> > know from the days when the scheduler relied on it has some 
> > non-trivial setup costs. So especially when there's _small_ bitmasks 
> > involved, it's more expensive.
> 
> Hi,
> 
> BSF is fine, it doesn't need any special setup. [...]

under "setup costs" i mean cycles spent by the CPU itself - the 
instruction itself is simple (of course) and needs no setup. If you look 
at BSF performance you'll see that it has nontrivial overhead.

	Ingo
