Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZCOSyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZCOSyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZCOSy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:54:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44717 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZCOSy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:54:26 -0400
Date: Sun, 15 Mar 2009 19:54:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 2/2] kconfig: improve seed in randconfig
Message-ID: <20090315185406.GA19737@elte.hu>
References: <20090315102341.GA6051@uranus.ravnborg.org> <20090315102856.GB6292@uranus.ravnborg.org> <10f740e80903150353i233d0da5rabde6e97607e3435@mail.gmail.com> <20090315130930.GA7146@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090315130930.GA7146@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Mar 15, 2009 at 11:53:03AM +0100, Geert Uytterhoeven wrote:
> > On Sun, Mar 15, 2009 at 11:28, Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 'make randconfig' uses glibc's rand function, and the seed of
> > > that PRNG is set via:
> > >
> > >                        srand(time(NULL));
> > >
> > > But 'time()' only increases once every second - freezing the
> > > randconfig result within a single second.
> > >
> > > My Nehalem testbox does randconfig much faster than 1 second
> > >  and i have a few scripts that do 'randconfig until condition X'
> > > loops.
> > >
> > > Those scripts currently waste a lot of CPU time due to randconfig
> > > changing its seed only once per second currently.
> > >
> > > Change the seed to be micrseconds based. (I checked the statistical
> > > spread of the seed - the now.tv_sec*now.tv_usec multiplication
> > > there further improves it.)
> > 
> > > +                       gettimeofday(&now, NULL);
> > > +
> > > +                       seed = (unsigned int)(now.tv_sec*now.tv_usec);
> > 
> > Just wondering: may there be some platforms that don't offer microsecond
> > resolution, and tv_usec is always zero?
> That would indeed be bad for the seed.
> Googling did not turn up anything.

doing:

         seed = (unsigned int)((now.tv_sec+1)*(now.tv_usec+1));

ought to settle any practical doubts.

	Ing
