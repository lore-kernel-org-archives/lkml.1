Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYKYFpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYKYFpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 00:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYKYFpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 00:45:33 -0500
Received: from sd-green-bigip-207.dreamhost.com ([208.97.132.207]:36023 "EHLO
	spunkymail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281AbYKYFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 00:45:32 -0500
From: Yuval Hager <yuval@avramzon.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Tue, 25 Nov 2008 07:43:22 +0200
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
References: <200811151801.02369.yuval@avramzon.net> <200811241155.47079.mb@bu3sch.de> <492AD249.3020309@lwfinger.net>
In-Reply-To: <492AD249.3020309@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1314015.9U052YQoBR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811250745.22487.yuval@avramzon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1314015.9U052YQoBR
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 24 November 2008, Larry Finger wrote:
> Michael Buesch wrote:
> > On Monday 24 November 2008 09:49:38 Yuval Hager wrote:
> >> * Now check this out - the output of lspci -d 14e4:4312 -x
> >> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g
> >> (rev ff) 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>
> >> (I double checked this)
> >>
> >> huh?
> >
> > Hah, interesting. I think your hardware may be faulty, in fact.
> > To me it really seems like the mainboard has power failures on the PCI
> > bus.
> >
> > This is a laptop, so you can't pull random hardware? Can you run some
> > hardware burn-in tests like mprime (http://mersenne.org/freesoft/) or
> > memtest? If that doesn't help, can you try with another operating syste=
m?
>
> I also think you are seeing a hardware failure. Another test to try is
> http://freshmeat.net/projects/cpuburn/?topic_id=3D146, which will exercise
> the system.
>
> Larry

I can't argue with what the bits mean, but I must say it doesn't "feel" lik=
e a=20
hardware problem. It is very consistent and deterministic.=20

I've been running mprime & burnBX & burnMMX for over 6 hours and it is all=
=20
fine (memtest not ran yet).

However, I have some few interesting findings.=20
=46irst, this is totally unrelated to b43, but to the PCI. I get the flawed=
 1's=20
read from lspci even without loading b43.

I played around with different video drivers and the results are:
* If using the 'via' driver, I lose the PCIe card immediately upon=20
initialization
* Using the 'openchrome' (trunk version), It works well in the beginning.=20
After first blanking the register reads are all 1's, and then when the scre=
en=20
is blank I get a different read (some registers are correct, some are wrong=
),=20
and when the screen is unblanked, I get 0xff's again. Very consistent and=20
predictabe (same read every time).
* Using the 'vesa' driver I could not recreate the problem. I could not get=
=20
the screen to blank for some reason, but closing the lid, going on=20
standby/hibernate, restarting X - all didn't matter much to the PCI and the=
=20
wireless card kept on working.

=2D-yuval

--nextPart1314015.9U052YQoBR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkrkPIACgkQl7qmwPqEj9+7dwCdHGvq6qzs4k0IfkfVjx5+JEVr
GSkAoMrmOEclPv9+7lYt8QK4btCwgEIn
=cjl+
-----END PGP SIGNATURE-----

--nextPart1314015.9U052YQoBR--
