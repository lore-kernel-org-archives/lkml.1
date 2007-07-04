Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbXGDVg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbXGDVg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXGDVgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:36:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbXGDVgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:36:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
Date: Wed, 4 Jul 2007 23:44:24 +0200
User-Agent: KMail/1.9.5
Cc: seife@suse.de, nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       suspend-devel@lists.sourceforge.net
References: <20070628135108.GA1810@elf.ucw.cz> <200706281734.54642.rjw@sisk.pl> <20070704193313.GF2728@elf.ucw.cz>
In-Reply-To: <20070704193313.GF2728@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707042344.25207.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 21:33, Pavel Machek wrote:
> Hi!
> 
> > > What about this? (Only compile tested, but looks pretty obvious to
> > > me). Something like this should get us rid of ugly option, and still
> > > solve debugging problems... Hmmm?
> > > 								Pavel
> > > 
> > > Kill CONFIG_DISABLE_CONSOLE_SUSPEND; it should not be configurable at
> > > all, instead, we should automatically keep console alive when
> > > possible.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > > 
> > > diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> > > index 62051f8..8267ff8 100644
> > > --- a/drivers/char/lp.c
> > > +++ b/drivers/char/lp.c
> > > @@ -144,7 +144,7 @@ static unsigned int lp_count = 0;
> > >  static struct class *lp_class;
> > >  
> > >  #ifdef CONFIG_LP_CONSOLE
> > > -static struct parport *console_registered; // initially NULL
> > > +static struct parport *console_registered;
> > >  #endif /* CONFIG_LP_CONSOLE */
> > 
> > Could you please avoid fixing things like this, white space etc. in this patch?
> > It would be easier to read ...
> 
> Yep, sorry, it should be separate patch. I hope the idea is still
> simple enough.

Yes, but I'm not sure if netconsole is the only one that we will want to have
disabled.  Moreover, what if someone wants to use the netconsole regardless
of the fact that it can crash the box?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
