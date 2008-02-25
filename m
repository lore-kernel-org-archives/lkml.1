Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYBYM0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYBYM0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYBYM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:26:25 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55261 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbYBYM0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:26:24 -0500
Date: Mon, 25 Feb 2008 14:25:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225122526.GE32450@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225113235.GC32450@cs181133002.pp.htv.fi> <20080225115022.GA16376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225115022.GA16376@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 12:50:22PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > What i do against build breakage is randconfig testing. That catches 
> > > far more build breakage than a few limited number of defconfigs 
> > > would ever.
> > 
> > How do you test whether a x86 merge might break the compilation of 
> > e.g. some ARM platform without using any defconfig?
> 
> yes, we do test that too. (we added this recently)

Really "without using any defconfig"?

> > And building all defconfigs is the trivial way of having most 
> > reasonable configurations covered with only one day of compile time.
> 
> the existing 32-bit and 64-bit defconfigs should be enough for that. For 
> better/full coverage, randconfig should be used.

The two big problems with randconfigs are:
- either you build each .config both with and without your patch or you
  have to manually check which of the failures are caused by your patch
- you require at least an order of magnitude more builds for having the
  same amount of common configurations covered

And any solution that only works on x86 (e.g. based on the expectation 
that all randconfig configurations normally build) is of zero value
for me since x86 is only one out of 23 architectures.

> > > More defconfigs would just be a constant maintenance drag, they are 
> > > rather pointless on PC hardware anyway (we'd have to have at least a 
> > > few hundred of them for it to be meaningful as a "default config") 
> > > and it does not really solve the problem either.
> > 
> > My goal was "one per subarchitecture" which is not such a big number.
> 
> at least on x86 subarchitectures are not at all that important (they are 
> a rather inflexible build-time concept), and as you have seen it in this 
> thread, we are working on reducing their count. 99% of the real hardware 
> is covered under the generic subarchitecture.
> 
> they are more important on other (mostly embedded) platforms, with ARM 
> having 75 defconfigs.

In my workflow defconfigs are an important part of testing my patches. 
But that noone cares whether I break other x86 subarchitectures is not 
really a problem for me.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

