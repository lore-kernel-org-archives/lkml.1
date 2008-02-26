Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbYBZUb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbYBZUb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762449AbYBZUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:31:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762394AbYBZUbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:31:08 -0500
Date: Tue, 26 Feb 2008 21:30:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080226203053.GB14350@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225190241.GA23161@uranus.ravnborg.org> <20080226094451.GL9857@elte.hu> <20080226201442.GB32685@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226201442.GB32685@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > Subarchitectures on x86 are just a shortcut for the "0.1% of systems 
> > that were lazy to be properly abstracted into the general PC code". We 
> > are discouraging additional subarches and the one that got added 
> > recently will go away soon. The rest is legacy.
>
> So you say we would waste our time doing build test of the legacy 
> sub-archs. OK.

definitely if what you want to do is to use your compilation resources 
to increase the quality of a patch as efficiently as possible. Testing 
UP/SMP 32bit/64bit defconfig and allnoconfig catches most of the 
immediate problems - allmodconfig will catch most of the rest. If you 
want to catch _all_ bugs that are possible the .config space, then 20 
randconfig builds give a higher than 99.9% confidence factor already, in 
my experience.

Sometimes, very rarely, deep down the chain of some really quirky 
Kconfig dependencies, there can be up to 1:512 chance build bugs hiding, 
which statistically need a 1000 randconfig builds to trigger. I saw a 
few in the past, but they are really rare. No amount of pre-cooked 
defconfigs would cover them - they are usually in drivers, not in 
subarch support.

what would be really useful is an automatic Kconfig tree analysis, with 
the printing out of too deep dependencies perhaps? Which might result in 
the breaking down of too deep dependencies - to increase the coverage of 
randconfig testing. Sometimes the number of "depends on" conditions are 
mind-blowing.

	Ingo
