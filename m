Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbYCCLp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbYCCLp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYCCLpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:45:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYCCLpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:45:49 -0500
Date: Mon, 3 Mar 2008 12:45:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080303114533.GA4183@elte.hu>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303113451.GF4457@cs181133002.pp.htv.fi>
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

> are the result of a quick Google search of me stating this previously on 
> linux-kernel. It might have been more often, but I'm too lame too 
> search further.
> 
> http://lkml.org/lkml/2007/1/19/36

that's a side-note, not a bugreport and not a patch to fix it.

> http://lkml.org/lkml/2007/4/9/363

this second one is this very thread that i replied to.

> > no, what we should nuke is this always_inline definition. That was 
> > always the intention of FORCED_INLINE, and the removal of 
> > FORCED_INLINE was to _remove the forcing_, not to make it 
> > unconditional.
> 
> It was always unconditional, and neither adding, toggling nor removing 
> of CONFIG_FORCED_INLINING changed this invariant.
> 
> And what we should do is to attack the excessive wrong usage of 
> inlines in .c files, not messing with a global #define in a way that 
> the results on 24 architectures with 7 different releases of gcc would 
> be unpredictable.

i see, so you never properly reported and fixed it because you prefer a 
1000 small crappy changes over one change. You could have significantly 
contributed to truly making Linux smaller, but you decided not to do it.

and i disagree with your notion that flipping it around is risky in any 
unacceptable or unmanageable way. It has far less risks on the compiler 
than say CONFIG_CC_OPTIMIZE_FOR_SIZE. It has far less risks than 
changing to a new compiler version. Why you think it's "unpredictable" 
is a mystery to me.

It almost seems to me you were happy with having that bug in the kernel? 
Please tell me that i'm wrong about that impression!

i'll reinstate this .config option and let it do the right thing. Forced 
inlining was supposed to be _phased out_, not phased in.

	Ingo
