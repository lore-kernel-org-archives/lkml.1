Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZBLH1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZBLH1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 02:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZBLH1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 02:27:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbZBLH1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:27:01 -0500
Date: Thu, 12 Feb 2009 08:26:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't override CONFIG_64BIT for ARCH={i386,x86_64}
	builds
Message-ID: <20090212072644.GA10253@elte.hu>
References: <1234372298.3586.23.camel@macbook.infradead.org> <20090211172258.GE13239@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211172258.GE13239@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > It is a steaming great pain in the arse when the value of CONFIG_64BIT
> > explicitly written in my .config file is overridden by the value of
> > $ARCH inferred from the environment.
> > 
> > If I have a 32-bit .config and I happen to build it without remembering
> > to put 'ARCH=i386' on the make command line, it shouldn't force
> > CONFIG_64BIT=y and reconfigure.
> > 
> > This patch should fix that, while still allowing defconfig to work as it
> > currently does for both 32-bit and 64-bit environments, and still giving
> > the default value of CONFIG_64BIT according to $ARCH. It's just that it
> > won't _force_ a change to CONFIG_64BIT when it's set to something other
> > than what $ARCH would imply.
> > 
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> Applied to tip:x86/ugent, thanks David!

i removed it again, because it regresses randconfig behavior:

 titan:~/tip> grep X86_32 .config; make ARCH=x86_64 randconfig; grep X86_32 .config
 # CONFIG_X86_32 is not set
 scripts/kconfig/conf -r arch/x86/Kconfig
 #
 # configuration written to .config
 #
 CONFIG_X86_32=y
 CONFIG_X86_32_SMP=y
 CONFIG_X86_32_LAZY_GS=y
 CONFIG_X86_32_ALWAYS_ON=y

I dont mind the change you are after, but randconfig should work as
expected too: if ARCH=x86_64 is passed it should generate a 64-bit
randconfig, not a 50% 32-bit one.

	Ingo
