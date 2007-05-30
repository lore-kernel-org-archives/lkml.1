Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXE3S5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXE3S5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXE3S52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:57:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52919 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbXE3S52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:57:28 -0400
X-Sasl-enc: CDiQVsRy6Abej6UXlNkLRmimyNZ23rRSvDUDElzOKT6k 1180551446
Message-ID: <465DC9E9.3040904@imap.cc>
Date: Wed, 30 May 2007 21:00:57 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Roland Dreier <rdreier@cisco.com>, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: Re: dealing with gcc 'comparison is always false' warnings
References: <20070530080518.GA29195@nostromo.devel.redhat.com>	 <adazm3mqqh3.fsf@cisco.com> <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
In-Reply-To: <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDBFF489A47295B335CBA868"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDBFF489A47295B335CBA868
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 30.05.2007 17:41 schrieb Satyam Sharma:
> On 5/30/07, Roland Dreier <rdreier@cisco.com> wrote:
>> thanks... I'm wondering if there's a consensus among kernel hackers
>> about changes like:
>>
>>  > -    if (hdr.cmd < 0 || hdr.cmd >=3D ARRAY_SIZE(ucma_cmd_table))
>>  > +    if (hdr.cmd >=3D ARRAY_SIZE(ucma_cmd_table))
>>  >              return -EINVAL;
>>
>> I understand that new gcc sees that hdr.cmd is unsigned and hence
>> can't be < 0, and generates a warning for that, and having a build
>> cluttered with warnings hides bugs and so on.  However the code here
>> looks quite sensible to me -- otherwise we end up with missing range
>> checking if hdr.cmd ever changes to a signed type.  This seems like a
>> good way to introduce bugs: delete valid range checking code to shut
>> up a silly gcc warning, and then change the type of a variable.
>=20
> You're *absolutely* correct about the issue that these "fixes" that rem=
ove
> such conditions end up remove range-checking making the code more
> flakey / less readable.

I disagree. Changing the type of a variable is a significant
modification. If someone does that, he or she *must* check every
use of that variable, at which point he or she will also modify
any range checks accordingly. Having checks that don't fit with
the previous type *distracts* from that job. "Oh, did I modify
that part already? Guess I can skip checking the rest of that
function then." Oops.

Nor is readability a suitable argument. Checking if hdr.cmd is
less than zero gives the misleading impression that it *could*
be less than zero, thus *impairing* readability.

jm2c
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigEDBFF489A47295B335CBA868
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGXcnpMdB4Whm86/kRAsc2AJ4pKSMsIGebEb4JUocKrSPe6zP9UgCfVbe2
MlSfeNc91Szl/A2EGbJJmZI=
=EWUz
-----END PGP SIGNATURE-----

--------------enigEDBFF489A47295B335CBA868--
