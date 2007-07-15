Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXGOVts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXGOVts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXGOVtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:49:40 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:51847 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXGOVtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:49:39 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Hibernation considerations
Date: Sun, 15 Jul 2007 22:51:35 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
References: <200707151433.34625.rjw@sisk.pl>
In-Reply-To: <200707151433.34625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6512583.cSVfYftztS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707152251.38713.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6512583.cSVfYftztS
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Sunday 15 July 2007 22:33:32 Rafael J. Wysocki wrote:
> Hi,
>=20
> Since many alternative approaches to hibernation are now being considered=
=20
and
> discussed, I thought it might be a good idea to list some things that in =
my=20
not
> so humble opinion should be taken care of by any hibernation framework. =
=20
They
> are listed below, not in any particular order, because I think they all a=
re
> important.  Still, I might have forgotten something, so everyone with
> experience in implementing hibernation, especially Pavel and Nigel, please
> check if the list is complete.
>=20
> (1) Filesystems mounted before the hibernation are untouchable
>=20
>     When there's a memory snapshot, either in the form of a hibernation=20
image,
>     or in the form of the "old" kernel and processes available to the "ne=
w"
>     kexeced kernel responsible for saving their memory, the filesystems=20
mounted
>     before the hibernation should not be accessed, even for reading, beca=
use
>     that would cause their on-disk state to be inconsistent with the=20
snapshot
>     and might lead to a filesystem corruption.
>=20
> (2) Swap space in use before the hibernation must be handled with care
>=20
>     If swap space is used for saving the memory snapshot, the=20
snapshot-saving
>     application (or kernel) must be careful enough not to overwrite swap=
=20
pages
>     that contain valid memory contents stored in there before the=20
hibernation.
>=20
> (3) There are memory regions that must not be saved or restored
>=20
>     Some memory regions contain data that shouldn't be overwritten during=
=20
the
>     restore, because that might lead to the system not working correctly
>     afterwards.  Also, on some systems there are valid 'struct pages'
>     structures that in fact corresond to memory holes and we should not=20
attempt
>     to save those pages.
>=20
> (4) The user should be able to limit the size of a hibernation image
>=20
>     There are a couple of reasons of that.  For example, the storage space
>     used for saving the image may be smaller than the entire RAM or the u=
ser
>     may want the image to be saved quickier.
>=20
> (5) Hibernation should be transparent from the applications' point of view
>=20
>     Generally, applications should not notice that hibernation took place.
>     [Note that I don't regard all processes as applications and I think t=
hat
>     there may be processes which need to handle the hibernation in a spec=
ial
>     way.]  Ideally, for example, if some audio is being played when a
>     hibernation starts, the audio player should be able to continue playi=
ng=20
the
>     same audio after the restore from the point in which it has been
>     interrupted by the hibernation.  Also, the CPU affinities and similar
>     settings requested by the applications before a hibernation should be
>     binding after the restore.
>=20
> (6) State of devices from before hibernation should be restored, if possi=
ble
>=20
>     If possible, during a restore devices should be brought back to the s=
ame
>     state in which they were before the corresponding hibernation.  Of=20
course
>     in some situations it might be impossible to do that (eg. the user
>     connected the hibernated system to a different IP subnet and then
>     restored), but as a general rule, we should do our best to restore the
>     state of devices, which is directly related to point (5) above.
>=20
> (7) On ACPI systems special platform-related actions have to be carried o=
ut=20
at
>     the right points, so that the platform works correctly after the rest=
ore
>=20
>     The ACPI specification requires us to invoke some global ACPI methods
>     during the hibernation and during the restore.  Moreover, the orderin=
g=20
of
>     code related to these ACPI methods may not be arbitrary (eg. some of
>     them have to be executed after devices are put into low power states=
=20
etc.).
>=20
> (8) Hibernation and restore should not be too slow
>=20
>     In my opinion, if more than one minute is needed to hibernate the sys=
tem
>     with the help of certain hibernation framework, then this framework i=
s=20
not
>     very useful in practice.  It might be useful to perform some special=
=20
tasks
>     (eg. moving a server to another place without taking it down), but it=
 is
>     not very useful, for example, to notebook users.
>=20
> (9) Hibernation framework should not be too difficult to set up
>=20
>     It follows from my experience that if the users are required to do to=
o=20
much
>     work to set up a hibernation framework, they will not use it as long =
as
>     there are simpler alternatives (some of them will not use hibernation=
 at
>     all if it's too difficult to get to work).  On the other hand, if the=
=20
users
>     are provided with a working hibernation framework by their distributi=
on
>     and they find it useful, they are not likely to use kernel.org kernel=
s=20
if
>     t's too difficult to replace the distribution kernel with a generic o=
ne=20
due
>     to the hibernation framework's requirements.
>=20
> All of the existing hibernation frameworks have been written with the abo=
ve
> points in mind and that's why they are what they are.  In particular, the
> existence of the tasks freezer, hated by some people to the point of=20
insanity,
> follows directly from points (1), (4) and (5).
>=20
> In my opinion any hibernation framework that doesn't take the above
> requirements into account in any way will be a failure.  Moreover, the=20
existing
> frameworks fail to follow some of them too, so I consider all of these
> frameworks as a work in progress.  For this reason, I will much more=20
appreciate
> ideas allowing us to improve the existing frameworks in a more or less
> evolutionary way, then attempts to replace them all with something entire=
ly
> new.

Sounds good to me. Nothing extra occurs immediately.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart6512583.cSVfYftztS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGmhhaN0y+n1M3mo0RAqJmAJ0Xtwopyk6k1c/AAIdy1EmwjpHYlACg6z+P
bzXbGQIEYXEJ5t8gdV1I5ww=
=nC7d
-----END PGP SIGNATURE-----

--nextPart6512583.cSVfYftztS--
