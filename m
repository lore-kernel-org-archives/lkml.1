Return-Path: <linux-kernel-owner+w=401wt.eu-S1765549AbXF1TFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765549AbXF1TFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764437AbXF1TFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:05:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760821AbXF1TFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:05:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
Date: Thu, 28 Jun 2007 21:12:44 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org, suspend-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070628135108.GA1810@elf.ucw.cz> <200706281734.54642.rjw@sisk.pl> <20070628172514.GA12770@suse.de>
In-Reply-To: <20070628172514.GA12770@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706282112.45378.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 28 June 2007 19:25, Stefan Seyfried wrote:
> (CC'ing Linus, since disabling consoles during suspend was his idea IIRC)
> 
> On Thu, Jun 28, 2007 at 05:34:54PM +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Thursday, 28 June 2007 15:51, Pavel Machek wrote:
> > > Hi!
> > > 
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
> Yes.
> 
> > I generally agree with the idea, but the patch needs a clean up, IMHO.
> 
> However, we don't know which consoles are safe to stay alive during suspend.
> Generally, defaulting to suspending them all is not a bad idea IMHO.
> And IIRC it is plain luck if a serial console survives the suspend (or was
> the serial code fixed recently?)

Well, I don't think so, but I'm not sure.

The VGA/fb console also should be off during suspend (not necessarily during
hibernation, though).  IIRC, that's what caused Linus to introduce the
suspending of consoles after all.

> So i do not care too much, but my / Frank's patch was shorter :-) and safer.

I'm not sure which way to go.  On the one hand, I agree that we should rather
fix the consoles so that we know which one is suspend-safe and which is not
and disable the unsafe ones, but on the other hand we are not there yet and it
_sometimes_ is useful not to suspend a console even if we know that it will
break things.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
