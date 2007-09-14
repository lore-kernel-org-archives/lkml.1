Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbXINAlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbXINAlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXINAlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:41:00 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:45326
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbXINAk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:40:59 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 20:40:58 EDT
Date: Thu, 13 Sep 2007 17:24:16 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070914002416.GD14439@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Adrian Bunk <bunk@kernel.org>,
	Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	USB development list <linux-usb-devel@lists.sourceforge.net>,
	Oliver Neukum <oneukum@suse.de>
References: <alpine.LFD.0.999.0709130912060.16478@woody.linux-foundation.org> <Pine.LNX.4.44L0.0709131421130.7406-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0709131421130.7406-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 13 Sep 2007 17:24:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 13, 2007 at 03:13:46PM -0400, Alan Stern wrote:
> On Thu, 13 Sep 2007, Linus Torvalds wrote:
>=20
> > In general, I think the USB blacklist/whitelists are generally a sign o=
f=20
> > some deeper bug.
> >=20
> > We used to have a lot of those things due to simply incorrect SCSI=20
> > probing, causing devices to lock up because Linux probed them with bad =
or=20
> > unexpected modepages etc. I suspect we still have old blacklist entries=
=20
> > from those days that just never got cleaned up, because nobody ever dar=
ed=20
> > remove the blacklist entry.
>=20
> I don't just suspect -- I know for a fact that we do.  Partly because
> of laziness and partly because of not being able to verify that an
> entry is no longer needed.

We do have some code that looks for unneeded entries.  When found by an
end-user (which confirms that the entry can be removed), it asks the user
to drop us an e-mail so we can remove it.

> > We should strive to make the default behaviour be so safe that we never=
=20
> > need a black-list (or a whitelist), and basically consider blacklists t=
o=20
> > be not a way to "fix up a device", but a way to avoid some really serio=
us=20
> > AND *RARE* error.
>=20
> In general I agree.  However there are some problems for which nobody=20
> has been able to come up with another solution.  See below.

We generally do strive for such a thing.  Over the years, we've made
several changes to the way the SCSI core works (especially in the probing
department) to allow us to remove all sorts of special-case code and quirk
entries.

> > For example, why do we have that US_FL_MAX_SECTORS_64 at all? The fact=
=20
> > that some USB device is broken with more than 64 sectors would seem to=
=20
> > indicate that Windows *never* does more than 64 sectors, and that in tu=
rn=20
> > means that pretty much *no* devices have ever been tested with anything=
=20
> > bigger.
> >=20
> > So why not make the 64 sector limit be the default? Get rid of the quir=
k:=20
> > we already allow people to override it in /sys if they really want to, =
but=20
> > realistically, it's probably not going to make any difference what-so-e=
ver=20
> > for *any* normal load. So we seem to have a quirk that really doesn't b=
uy=20
> > us anything but headache.
>=20
> That's true now, but it wasn't always.  Until the last year or so,=20
> cdrecord wouldn't work properly with USB CD drives having a 64-sector=20
> limit unless the user added a particular command-line argument.
>=20
> In fact, setting max_sectors down to 64 is probably overkill -- 120
> ought to be enough.  But there may have been one or two oddball devices
> that really did have a 32-KB limit, and better safe than sorry.  At one
> point an engineer from Genesys said their devices did, although they do
> seem to work perfectly well with 64-KB transfers (and that's what=20
> Windows gives them).

It's worth pointing out that performance drops like a stone as this number
goes down.

> > Other quirks worth looking at (but likely unfixable) are:
> >  - US_FL_IGNORE_RESIDUE:
> > 	Does this really matter? Can we not just always do the=20
> > 	US_FL_IGNORE_RESIDUE thing? Windows must not be doing what we're=20
> > 	doing.
>=20
> Windows does indeed ignore the residue field, as far as I can tell.
>=20
> But this is a rather tricky thing.  The USB mass-storage spec
> specifically says that one way a device can signal a short transfer is
> to pad the data with 0s to the requested length and then set the
> residue to indicate how much of the data is valid.  If we ignore the
> residue then we run a risk of misinterpreting the 0s as valid data.
>=20
> Now in practice this doesn't matter much because short transfers of
> block data (READ_10) generally involve other errors that would show up
> anyway, and for non-block data (MODE SENSE) the padding probably
> wouldn't matter.  Still it seems like a dangerous sort of thing to do,
> which is why I have resisted it.
>=20
> (And by the way, there _definitely_ are devices which use this
> signalling method.  In fact, Linux contains a driver that does it.)

I think this last point is key.  I'm unwilling to sacrifice error detection
on properly working devices to enable error-prone use on clearly buggy
devices.

> >  - US_FL_FIX_CAPACITY:=20
> > 	This is a generic SCSI issue, not a USB one, and maybe there are=20
> > 	better solutions to it. Are we perhaps doing something wrong? Is=20
> > 	there some patterns we haven't seen? Why do we need this, when=20
> > 	presumably Windows does not?
>=20
> This is another hard case.  No, we aren't doing anything wrong.  If
> there are any patterns we haven't seen, we aren't aware of them.  :-) =20
> You might think that if a device claims to have an odd number of
> sectors then it must be wrong, but this turns out not to be true.
>=20
> Why doesn't Windows need this?  For all we know, it does.  Has anybody
> ever tried forcing Windows to read the sector beyond the end of one of
> these buggy devices?

As far as I know, Windows doesn't need this because of the way FAT and NTFS
work.  They never use the end of the disk (by more than a few sectors, or
so I'm told).

> There's a straightforward solution: Never try to use the last sector --
> in effect, assume every device has the FIX_CAPACITY flag set.  Doing=20
> this universally could cause data loss, however, so again I have been=20
> opposed to it.

I agree here.

> >  - US_FL_SINGLE_LUN:
> > 	At least a few of these seem to indicate that the real problem=20
> > 	could be detected dynamically ("device reports Sub=3Dff") rather=20
> > 	than with a quirk. Quirks are unmaintainable (and change), but=20
> > 	noticing when devices return impossible values and going into a=20
> > 	"safe mode" is just defensive programming.
>=20
> This is almost certainly a case where lots of the entries are no longer=
=20
> needed.  But it isn't easy to tell which ones can safely be removed.

I've been meaning to start sending e-mails to see if we can get rid of
these.  Most of the devices which required it were UFI, which reports "LUN
not present" in a goofy way.  We fixed the code to detect it properly, but
there are still quite a few devices out there that don't implement the
correct (if goofy) method.

Most of those entries (which are for UFI devices) can go, if we get a
volunteer to take the e-mail addresses listed in unusual_devs.h and work
the list.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG6dSwHL9iwnUZqnkRAnkCAJ9xjSfGwNzjlmmP/ftjL9b/3Rf5dQCeNXPj
pPU2pIekCEg/XtiNoUKPUeI=
=FwgF
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
