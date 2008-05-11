Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbYEKSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbYEKSwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbYEKSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:52:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39156 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbYEKSwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:52:08 -0400
Date: Sun, 11 May 2008 20:52:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpe@it.uu.se>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before
	`.text'
Message-ID: <20080511185247.GA5599@elf.ucw.cz>
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com> <200805102256.09519.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805102256.09519.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The resulting kernel hasn't broken on me yet, however.
> > > 
> > > A search through the LKML archives showed that this was reported
> > > for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
> > > after that:
> > > 
> > > <http://marc.info/?l=linux-kernel&m=120470303728010&w=2>
> > > 
> > > The .config causing this warning is available in
> > > <http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>
> > > 
> > 
> > This is because the organization of the file was changed, and the linker 
> > script wasn't changed to match:
> > 
> > SECTIONS
> > {
> >          . = HEADER_OFFSET;
> >          .header : {
> >                   *(.header)
> >          }
> > 
> >          . = 0;
> >          .text : {
> >                   *(.text*)
> >          }
> > 
> > This is crap; the sections should be listed *in order* so the linker can 
> > warn properly when something bad happens.
> > 
> > The code should be correct; reorganizing the linker script correctly 
> > should fix the problem.

I'm not good at linker magic. I needed to put code from offset zero,
while still having header at known address...

> Hm.  The above is from Pavel and Sam.

Sorry about that. Plus, I'm on holidays just now...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
