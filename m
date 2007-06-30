Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXF3KIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXF3KIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXF3KIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:08:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33799 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbXF3KIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:08:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Sat, 30 Jun 2007 12:15:19 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200706290827.13024.nigel@nigel.suspend2.net> <20070629223505.GB6732@elf.ucw.cz>
In-Reply-To: <20070629223505.GB6732@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706301215.20334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 30 June 2007 00:35, Pavel Machek wrote:
> Hi!
> 
> > > >  ALIGN
> > > >  	.align	4096
> > > > @@ -31,6 +46,11 @@ wakeup_code:
> > > >  	movw	%cs, %ax
> > > >  	movw	%ax, %ds					# Make ds:0 point to wakeup_start
> > > >  	movw	%ax, %ss
> > > > +
> > > > +	testl   $1, beep_flags - wakeup_code
> > > > +	jz      1f
> > > > +	BEEP
> > > > +1:
> > > 
> > > Can we rename/reuse existing flag variable?
> > 
> > Sorry, but I can't resist the opportunity to say "Send a patch!" :)
> > 
> > Seriously, though, I'd prefer not to. If we rename that acpi video flags 
> > variable (I assume this is what you're thinking of), we only create cause for 
> > confusion. A variable should for debugging or for controlling quirks, not for 
> > both at the same time.
> 
> Cause for confusion? We are currently using 2 bits of that variable,
> and we want to add one more bit. I seriously doubt that can confuse
> anyone.

Well, indeed it would be more elegant to rename the existing flags variable
and use another bit out of it, but I personally don't think it's _that_
important.  At least, I don't think we should block the patch because of that.

BTW, has anyone confirmed that it works on i386?

BTW2, Nigel, please fix the formats in s2ram_beep_show()/_store(), they
cause gcc to spit ugly warnings on some architectures.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
