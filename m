Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXGAKCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXGAKCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 06:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbXGAKCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 06:02:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36514 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbXGAKCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 06:02:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sun, 1 Jul 2007 12:09:28 +0200
User-Agent: KMail/1.9.5
Cc: michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200706302237.50567.rjw@sisk.pl> <200707010134.30843.arvidjaar@mail.ru>
In-Reply-To: <200707010134.30843.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707011209.29250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 June 2007 23:34, Andrey Borzenkov wrote:
> On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> > On Saturday, 30 June 2007 06:59, Andrey Borzenkov wrote:
> > > Since 2.6.18 I do not have suspend to RAM; now I am starting to lose
> > > suspend to disk :)
> > >
> > > Environment - vanilla kernel (2.6.22-rc6 currently + squashfs + single
> > > pata_ali patch to switch off DMA on CD-ROM), single root on reiserfs,
> > > libata with pata_ali driver.
> > >
> > > Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-rc
> > > system hung at least once in every rcX. Up to rc6 those lockups were
> > > absolutely silent (black screen without reaction to any key). In rc6 I
> > > just got something different. After resume I got on screem:
> > >
> > > swsusp: Marking nosave pages: 000000000009f000-0000000000100000
> > > swsusp: Basic memory bitmaps created
> > > swsusp: Basic memory bitmaps freed
> > >
> > > After that it just sits there doing nothing. Ther was brief sound of HDD
> > > but I suspect it was related more to power-on. System was responding to
> > > power-on button press:
> > >
> > > ACPI Error (event-0305): No installed handler for fixed event [00000002
> > > 20070125]
> > >
> > > And SysRq was functioning.
> >
> > That probably means that there's a deadlock somewhere in there.
> >
> > > Unfortunately I do not have serial console so I
> > > copy manually stacks from several last screens of output; I have tried to
> > > make a photo but right now my kbluetooth is refusing to work at all so I
> > > cannot transfer them :( (but I suspect quality would be too bad anyway)
> > >
> > > laptop_mode D
> > > 	io_schedule+0xe/0x20
> >
> > Looks suspicious to me.  Can you identify what line of code this points to?
> >
> 
> If you could explain how to ... 

Michal has already done that. :-)

[--snip--]
> >
> > I see you're using CFQ as the default IO scheduler.  Can you please switch
> > to AS and see if that changes anything?
> >
> 
> Sure, but given that I have no idea how to reproduce the lockup, we may never 
> know whether it actually helped.

Well, if the lockup never happens with AS, that will indicate something ...

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
