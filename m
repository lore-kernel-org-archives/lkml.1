Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbXIBOvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbXIBOvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXIBOv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 10:51:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:52013 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbXIBOv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 10:51:27 -0400
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically
	hangs on resume from hibernation
From: Kasper Sandberg <lkml@metanurb.dk>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, michal.k.k.piotrowski@gmail.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200709021529.51165.arvidjaar@mail.ru>
References: <200706300859.47133.arvidjaar@mail.ru>
	 <200707010134.30843.arvidjaar@mail.ru> <200707011209.29250.rjw@sisk.pl>
	 <200709021529.51165.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 16:49:49 +0200
Message-Id: <1188744589.11644.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top posting, but this is MAYBE a related matter, i am not
sure.

the thing is, i am running with libata and reiserfs on a raid5 with 6
disks, and after i changed to libata it has worked excellently (before
it used to give DMA errors and then go boom).

however now i sometimes, if theres some load on the array, see that the
hdd leds go fully on, and for ~10sec to 1 min, all IO just stops
complete, and after the time, it resumes and works perfectly.

any ideas? and i also bring this up as it may give a clue as to what
causes this. - I also use CFQ

On Sun, 2007-09-02 at 15:29 +0400, Andrey Borzenkov wrote:
> On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> > On Saturday, 30 June 2007 23:34, Andrey Borzenkov wrote:
> > > On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> > > > On Saturday, 30 June 2007 06:59, Andrey Borzenkov wrote:
> > > > > Since 2.6.18 I do not have suspend to RAM; now I am starting to lose
> > > > > suspend to disk :)
> > > > >
> > > > > Environment - vanilla kernel (2.6.22-rc6 currently + squashfs +
> > > > > single pata_ali patch to switch off DMA on CD-ROM), single root on
> > > > > reiserfs, libata with pata_ali driver.
> > > > >
> > > > > Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-rc
> > > > > system hung at least once in every rcX. Up to rc6 those lockups were
> > > > > absolutely silent (black screen without reaction to any key). In rc6
> > > > > I just got something different. After resume I got on screem:
> > > > >
> > > > > swsusp: Marking nosave pages: 000000000009f000-0000000000100000
> > > > > swsusp: Basic memory bitmaps created
> > > > > swsusp: Basic memory bitmaps freed
> > > > >
> > > > > After that it just sits there doing nothing. Ther was brief sound of
> > > > > HDD but I suspect it was related more to power-on. System was
> > > > > responding to power-on button press:
> > > > >
> > > > > ACPI Error (event-0305): No installed handler for fixed event
> > > > > [00000002 20070125]
> > > > >
> > > > > And SysRq was functioning.
> > > >
> > > > That probably means that there's a deadlock somewhere in there.
> > > >
> > > > > Unfortunately I do not have serial console so I
> > > > > copy manually stacks from several last screens of output; I have
> > > > > tried to make a photo but right now my kbluetooth is refusing to work
> > > > > at all so I cannot transfer them :( (but I suspect quality would be
> > > > > too bad anyway)
> > > > >
> > > > > laptop_mode D
> > > > > 	io_schedule+0xe/0x20
> > > >
> > > > Looks suspicious to me.  Can you identify what line of code this points
> > > > to?
> > >
> > > If you could explain how to ...
> >
> > Michal has already done that. :-)
> >
> > [--snip--]
> >
> > > > I see you're using CFQ as the default IO scheduler.  Can you please
> > > > switch to AS and see if that changes anything?
> > >
> > > Sure, but given that I have no idea how to reproduce the lockup, we may
> > > never know whether it actually helped.
> >
> > Well, if the lockup never happens with AS, that will indicate something ...
> >
> 
> I thought it is gone but it just happened again with 2.6.23-rc5. I thought I 
> have been running AS but no, I did use CFQ. Now I definitely switched to AS 
> default; let's see ...

