Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbYBKNd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbYBKNd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBKNdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:33:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYBKNds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:33:48 -0500
Date: Mon, 11 Feb 2008 14:33:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Message-ID: <20080211133333.GA5842@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093433.DE4961B41CE@basil.firstfloor.org> <20080211124625.GB23733@elte.hu> <200802111405.04423.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111405.04423.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > Also, your fix, while it solves a real bug we want to fix, is not quite 
> > right for upstream integration yet. I can see 3 immediate problems with 
> > it:
> > 
> > > +			if (!pud_present(*pud)) {
> > > +				pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
> > 
> > the GFP_ATOMIC here can fail.
> 
> The memory hotplug code already uses GFP_ATOMIC elsewhere 
> (spp_getpage)

wrong. The _x86_ memory hotplug code uses GFP_ATOMIC elsewhere.
The generic memory hotplug code does not.

and the x86 memory hotplug code uses GFP_ATOMIC and panic() elsewhere 
because:

> The existing code already panics elsewhere (spp_getpage); i just 
> copied that.

and you had nothing to do with that "existing code"? git-log reveals 
that the GFP_ATOMIC and panic()-ing patch was added 2 years ago and was 
signed off by you:

  commit 44df75e629106efcada087cead6c3f33ed6bcc60
  Author: Matt Tolentino <metolent@cs.vt.edu>
  Date:   Tue Jan 17 07:03:41 2006 +0100

    [PATCH] x86_64: add x86-64 support for memory hot-add

  [...]
  Signed-off-by: Andi Kleen <ak@suse.de>

We (like most upstream kernel subsystems) generally do not accept 
patches into arch/x86 that spreads a buggy implementation detail 
further. Please submit a patch that cleans up the mess. Thanks,

	Ingo
