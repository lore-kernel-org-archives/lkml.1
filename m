Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbZCONHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbZCONHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 09:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZCONHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 09:07:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60550 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZCONHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 09:07:32 -0400
Date: Sun, 15 Mar 2009 14:09:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] kconfig: improve seed in randconfig
Message-ID: <20090315130930.GA7146@uranus.ravnborg.org>
References: <20090315102341.GA6051@uranus.ravnborg.org> <20090315102856.GB6292@uranus.ravnborg.org> <10f740e80903150353i233d0da5rabde6e97607e3435@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e80903150353i233d0da5rabde6e97607e3435@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 11:53:03AM +0100, Geert Uytterhoeven wrote:
> On Sun, Mar 15, 2009 at 11:28, Sam Ravnborg <sam@ravnborg.org> wrote:
> > 'make randconfig' uses glibc's rand function, and the seed of
> > that PRNG is set via:
> >
> >                        srand(time(NULL));
> >
> > But 'time()' only increases once every second - freezing the
> > randconfig result within a single second.
> >
> > My Nehalem testbox does randconfig much faster than 1 second
> >  and i have a few scripts that do 'randconfig until condition X'
> > loops.
> >
> > Those scripts currently waste a lot of CPU time due to randconfig
> > changing its seed only once per second currently.
> >
> > Change the seed to be micrseconds based. (I checked the statistical
> > spread of the seed - the now.tv_sec*now.tv_usec multiplication
> > there further improves it.)
> 
> > +                       gettimeofday(&now, NULL);
> > +
> > +                       seed = (unsigned int)(now.tv_sec*now.tv_usec);
> 
> Just wondering: may there be some platforms that don't offer microsecond
> resolution, and tv_usec is always zero?
That would indeed be bad for the seed.
Googling did not turn up anything.

	Sam
