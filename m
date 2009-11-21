Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZKUTgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZKUTgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZKUTgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:36:48 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:43537 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbZKUTgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:36:47 -0500
Date: Sat, 21 Nov 2009 20:36:45 +0100
From: Pierre Ossman <pierre-list@ossman.eu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Raid not shutting down when disks are lost?
Message-ID: <20091121203645.60d68d11@mjolnir.ossman.eu>
In-Reply-To: <e9c3a7c20911211121l517837f9s17283dd37e0dd865@mail.gmail.com>
References: <20091008163952.679572b5@mjolnir.ossman.eu>
	<20091121170355.7540d169@mjolnir.ossman.eu>
	<e9c3a7c20911211121l517837f9s17283dd37e0dd865@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-12049-1258832215-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-12049-1258832215-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Nov 2009 12:21:58 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sat, Nov 21, 2009 at 9:03 AM, Pierre Ossman <pierre-list@ossman.eu> wr=
ote:
> > Neil?
> >
> > On Thu, 8 Oct 2009 16:39:52 +0200
> > Pierre Ossman <pierre-list@ossman.eu> wrote:
> >
> >> Today one RAID6 array I manage decided to lose four out of eight disks.
> >> Oddly enough, the array did not shut down but instead I got
> >> intermittent read and writer errors from the filesystem.
>=20
> This is expected.
>=20
> The array can't shutdown when there is a mounted filesystem.  Reads
> may still be serviced from the survivors, all writes should be aborted
> with an error.
>=20

It could "shut down" in the sense that it refuses to touch the
underlying hardware and just report errors to upper layers. I.e. don't
update the md superblock marking more disks as failed.

> >>
> >> It's been some time since I had a failure of this magnitude, but I seem
> >> to recall that once the array lost too many disks, it would shut down
> >> and refuse to write a single byte. The nice effect of this was that if
> >> it was a temporary error, you could just reboot and the array would
> >> start nicely (albeit in degraded mode).
> >>
> >> Has something changed? Is this perhaps an effect of using RAID6 (I used
> >> to run RAID5 arrays)? Or was I simply lucky the previous instances I've
> >> had?
>=20
> It should not come back up nicely in this scenario.  You need
> "--force" to attempt to reassemble a failed array.
>=20

If the last disk is thrown out either because of a read error, or
because of the first write of a stripe (i.e. what's on the platters is
still in sync) then a force would not be needed. This requires the md
code to not mark that last disk as failed in the superblocks of the
remaining disks though.

> >>
> >> Related, it would be nice if you could control how it handles lost
> >> disks. E.g. I'd like it to go read-only when it goes in to fully
> >> degraded mode. In case the last disk lost was only a temporary glitch,
> >> the array could be made to recover without a lengthy resync.
> >>
>=20
> When you say "fully-degraded" do you mean "failed"?  In general the
> bitmap mechanism provides fast resync after temporary disk outages.
>=20

Fully degraded means still working but without any redundancy. I.e. one
lost disk with RAID 5 or two with RAID 6. And the bitmap mechanism
seems to be broken in that case since I always experience full,
multi-hour resyncs whenever a disk is lost.

Or is there perhaps some magic mdadm command to add a lost disk and get
it up to speed without a complete sync?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-12049-1258832215-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksIQVMACgkQ7b8eESbyJLgpoACeKrSLm4gwjU0Fst6XBb3eeadB
r7oAoLjNScEn/8SUErkvMwC2h6WPsDJ3
=IQ9Y
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-12049-1258832215-0001-2--
