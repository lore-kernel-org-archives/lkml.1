Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYJIQOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYJIQOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYJIQOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:14:46 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:58532 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753358AbYJIQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:14:45 -0400
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Date: Thu, 9 Oct 2008 20:13:54 +0400
User-Agent: KMail/1.9.10
Cc: Matthew Wilcox <matthew@wil.cx>, orinoco-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810091722.56812.arvidjaar@newmail.ru> <200810091959.54987.arvidjaar@newmail.ru> <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com>
In-Reply-To: <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1768242.paeJi4inQf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810092013.55476.arvidjaar@newmail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1768242.paeJi4inQf
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 09 October 2008, Dan Williams wrote:
>=20
> On Thu, 2008-10-09 at 19:59 +0400, Andrey Borzenkov wrote:
> > On Thursday 09 October 2008, Matthew Wilcox wrote:
> > >=20
> > > On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> > > > After loading orinoco and "inserting" adapter I get either BUG with
> > > > endless loop (attached) or kernel panic on NULL pointer dereference
> > > > (was not able capture). Adapter works fine with wlags49 driver.
> > >=20
> > > It looks like you've fallen off the bottom of the kernel stack.  Do y=
ou
> > > have 4k stacks enabled in your config?
> > >=20
> >=20
> > You are right. Using 8K stacks load and runs fine. Hmm ... not nice
> > from it :p
>=20
> =3D=3D driver bug; the driver should not require large stacks and this
> should get fixed.
>=20
I'll check for obvious places, still ...

/* Download either STA or AP firmware into the card. */
static int
orinoco_dl_firmware(struct orinoco_private *priv,
                    const struct fw_info *fw,
                    int ap)
{
        /* Plug Data Area (PDA) */
        __le16 pda[512] =3D { 0 };

allocating 1K on stack is not nice; but what has eaten 3K more?

Is there any instrumentation to analyze stack usage?

--nextPart1768242.paeJi4inQf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjuLcMACgkQR6LMutpd94wEzgCfdnCSg50PpgyoouccgUv17QpD
55YAoKyuMWgzTLLjbGXPcyw/XsfoSjlg
=IMWe
-----END PGP SIGNATURE-----

--nextPart1768242.paeJi4inQf--
