Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXDQRxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXDQRxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030818AbXDQRxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:53:12 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55112 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030811AbXDQRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:53:11 -0400
X-Sasl-enc: I5R++QqzV6m9wI1PKsl4NbgdG6N0tJQ+HWl9pPz4fN70 1176832390
Message-ID: <46250A15.2010705@imap.cc>
Date: Tue, 17 Apr 2007 19:55:33 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>	<4623FB0E.4080602@imap.cc>	<20070416161337.d59f2ea3.randy.dunlap@oracle.com>	<4624C320.3050206@imap.cc>	<20070417144054.24c104bf@the-village.bc.nu>	<4624E1DE.2040300@imap.cc> <20070417163337.3b62b8f5@the-village.bc.nu>
In-Reply-To: <20070417163337.3b62b8f5@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig40569255D857772FEB7F1B31"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig40569255D857772FEB7F1B31
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 17.04.2007 17:33 schrieb Alan Cox:
> On Tue, 17 Apr 2007 17:03:58 +0200
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> On Tue, 17 Apr 2007 14:40:54 +0100, Alan Cox wrote:
>>> If the obsolete tag is to be removed then it needs a formal maintaine=
r,
>>> all the obsolete interface usage cleaning up and the like otherwise a=
t
>>> some point in a clean up it is going to end up breaking and migrating=
 to
>>> && BROKEN as well.
>> I'm not sure I understand. What do you mean by "obsolete interface
>> usage"? What sort of cleaning up needs to be done? What sort of
>> breakage do you anticipate in the event of a clean up?
>=20
> Things like:
>=20
> 	pci_find_device
> 	pci_find_bus
>=20
> 	interruptible_sleep_on
> 	sleep_on
>=20
> 	lock_kernel
> 	unlock_kernel
>=20
> and the drivers that i4l uses (eg hisax) need switching to the proper
> pci_module interfaces to handle hot plug.

I was afraid you meant that. You are confirming my worst fears.
So it's already too late, and that incorrect obsolete tag is on its
way to becoming a self-fulfilling prophecy. Whatever happened to the
promise in Documentation/stable_api_nonsense.txt:

| <insert link to leech comment from Andrew and Linus here>.)  If your
| driver is in the tree, and a kernel interface changes, it will be fixed=

| up by the person who did the kernel change in the first place.  This
| ensures that your driver is always buildable, and works over time, with=

| very little effort on your part.

?

Let me guess: the person who did the kernel change in the first place
saw that I4L was marked as obsolete anyway, and therefore didn't bother
fixing it up. And now that very fact constitutes a reason to keep that
label, ensuring that future people doing kernel changes will do
likewise. So the cat is biting its own tail, as we say in German.

Well, end of rant. So the situation now is:
- A discussion on LKML concluded that the isdn4linux subsystem is not
  obsolete today, given that a complete replacement does not yet exist.
- The "obsolete" tag on the ISDN_I4L Kconfig entry is therefore
  incorrect.
- In order to remove it, you ask that the code of the isdn4linux
  subsystem be modified to conform to certain changes that have been
  made to the kernel API but not extended to isdn4linux.
- The people best qualified to make these modifications are
  (a) those who introduced the kernel API changes in the first place or
  (b) the isdn4linux maintainers.
- The isdn4linux maintainers are busy working on the new CAPI subsystem
  and mISDN driver which should replace isdn4linux eventually but are
  not quite there yet. (mISDN not even being in the kernel so far.)
- That leaves those who introduced the kernel API changes in question
  to finish what is, according to stable_api_nonsense.txt, their job.
- In the meantime, we'll have to live with the recurring question
  whether the isdn4linux subsystem can finally be scheduled for removal.
- At least we are safe against an actual removal, because that would
  constitute a regression (break existing functionality that is in
  actual use), and Linus says we don't do regressions.

Did I sum that up correctly?

Thanks
Tilman

--=20
Tilman Schmidt                                  E-Mail: tilman@imap.cc
Wehrhausweg 66                                  Fax: +49 228 4299019
53227 Bonn
Germany


--------------enig40569255D857772FEB7F1B31
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGJQocMdB4Whm86/kRArOlAJ9eiPCZ3iSVjVUEqEyfljpKqF1F9ACfWByA
TtQjPCcSWpxxvAOUHGv/ogM=
=BirH
-----END PGP SIGNATURE-----

--------------enig40569255D857772FEB7F1B31--
