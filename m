Return-Path: <linux-kernel-owner+w=401wt.eu-S965214AbXIBLaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965214AbXIBLaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964854AbXIBL34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:29:56 -0400
Received: from mx27.mail.ru ([194.67.23.64]:6554 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964836AbXIBL3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:29:55 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sun, 2 Sep 2007 15:29:50 +0400
User-Agent: KMail/1.9.7
Cc: michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200707010134.30843.arvidjaar@mail.ru> <200707011209.29250.rjw@sisk.pl>
In-Reply-To: <200707011209.29250.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1236269.23AoJL6L5z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709021529.51165.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1236269.23AoJL6L5z
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> On Saturday, 30 June 2007 23:34, Andrey Borzenkov wrote:
> > On Sunday 01 July 2007, Rafael J. Wysocki wrote:
> > > On Saturday, 30 June 2007 06:59, Andrey Borzenkov wrote:
> > > > Since 2.6.18 I do not have suspend to RAM; now I am starting to lose
> > > > suspend to disk :)
> > > >
> > > > Environment - vanilla kernel (2.6.22-rc6 currently + squashfs +
> > > > single pata_ali patch to switch off DMA on CD-ROM), single root on
> > > > reiserfs, libata with pata_ali driver.
> > > >
> > > > Until 2.6.22-rc I never had problems with hibernation. With 2.6.22-=
rc
> > > > system hung at least once in every rcX. Up to rc6 those lockups were
> > > > absolutely silent (black screen without reaction to any key). In rc6
> > > > I just got something different. After resume I got on screem:
> > > >
> > > > swsusp: Marking nosave pages: 000000000009f000-0000000000100000
> > > > swsusp: Basic memory bitmaps created
> > > > swsusp: Basic memory bitmaps freed
> > > >
> > > > After that it just sits there doing nothing. Ther was brief sound of
> > > > HDD but I suspect it was related more to power-on. System was
> > > > responding to power-on button press:
> > > >
> > > > ACPI Error (event-0305): No installed handler for fixed event
> > > > [00000002 20070125]
> > > >
> > > > And SysRq was functioning.
> > >
> > > That probably means that there's a deadlock somewhere in there.
> > >
> > > > Unfortunately I do not have serial console so I
> > > > copy manually stacks from several last screens of output; I have
> > > > tried to make a photo but right now my kbluetooth is refusing to wo=
rk
> > > > at all so I cannot transfer them :( (but I suspect quality would be
> > > > too bad anyway)
> > > >
> > > > laptop_mode D
> > > > 	io_schedule+0xe/0x20
> > >
> > > Looks suspicious to me.  Can you identify what line of code this poin=
ts
> > > to?
> >
> > If you could explain how to ...
>
> Michal has already done that. :-)
>
> [--snip--]
>
> > > I see you're using CFQ as the default IO scheduler.  Can you please
> > > switch to AS and see if that changes anything?
> >
> > Sure, but given that I have no idea how to reproduce the lockup, we may
> > never know whether it actually helped.
>
> Well, if the lockup never happens with AS, that will indicate something .=
=2E.
>

I thought it is gone but it just happened again with 2.6.23-rc5. I thought =
I=20
have been running AS but no, I did use CFQ. Now I definitely switched to AS=
=20
default; let's see ...

--nextPart1236269.23AoJL6L5z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBG2p6vR6LMutpd94wRAiAuAKDMUxWhjpPCIEu8UfZ5YJqQ4cS+tACeJwk4
3OVbOadH/lHLPUtZNMYnZAg=
=1gT1
-----END PGP SIGNATURE-----

--nextPart1236269.23AoJL6L5z--
