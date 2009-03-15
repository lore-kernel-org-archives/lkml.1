Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZCOVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZCOVro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbZCOVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:47:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41785 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbZCOVre convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:47:34 -0400
Message-Id: <1237153649.32747.1305532855@webmail.messagingengine.com>
X-Sasl-Enc: orZjFO37Arpj5Po9iqt6fHJ+tNeANXbHX8xUbtpcWeOK 1237153649
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20090315102341.GA6051@uranus.ravnborg.org>
 <20090315102856.GB6292@uranus.ravnborg.org>
 <10f740e80903150353i233d0da5rabde6e97607e3435@mail.gmail.com>
 <20090315130930.GA7146@uranus.ravnborg.org>
 <20090315185406.GA19737@elte.hu>
Subject: Re: [PATCH 2/2] kconfig: improve seed in randconfig
In-Reply-To: <20090315185406.GA19737@elte.hu>
Date: Sun, 15 Mar 2009 22:47:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 15 Mar 2009 19:54:07 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sun, Mar 15, 2009 at 11:53:03AM +0100, Geert Uytterhoeven wrote:
> > > On Sun, Mar 15, 2009 at 11:28, Sam Ravnborg <sam@ravnborg.org> wrote:
> > > > 'make randconfig' uses glibc's rand function, and the seed of
> > > > that PRNG is set via:
> > > >
> > > >                        srand(time(NULL));
> > > >
> > > > But 'time()' only increases once every second - freezing the
> > > > randconfig result within a single second.
> > > >
> > > > My Nehalem testbox does randconfig much faster than 1 second
> > > >  and i have a few scripts that do 'randconfig until condition X'
> > > > loops.
> > > >
> > > > Those scripts currently waste a lot of CPU time due to randconfig
> > > > changing its seed only once per second currently.
> > > >
> > > > Change the seed to be micrseconds based. (I checked the statistical
> > > > spread of the seed - the now.tv_sec*now.tv_usec multiplication
> > > > there further improves it.)
> > > 
> > > > +                       gettimeofday(&now, NULL);
> > > > +
> > > > +                       seed = (unsigned int)(now.tv_sec*now.tv_usec);
> > > 
> > > Just wondering: may there be some platforms that don't offer microsecond
> > > resolution, and tv_usec is always zero?
> > That would indeed be bad for the seed.
> > Googling did not turn up anything.
> 
> doing:
> 
>          seed = (unsigned int)((now.tv_sec+1)*(now.tv_usec+1));
> 
> ought to settle any practical doubts.

Or maybe (and I think better...)

    seed = (unsigned int)(now.tv_sec ^ now.tv_usec);

Greetings,
    Alexander

> 	Ing

o :)

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
