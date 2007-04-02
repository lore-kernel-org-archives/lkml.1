Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbXDBLyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbXDBLyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933975AbXDBLyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:54:14 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:2520 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933974AbXDBLyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:54:13 -0400
Date: Mon, 2 Apr 2007 12:54:12 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Daniel Jacobowitz <dan@debian.org>
Subject: Re: [PATCH 17/16] Do not reset UTF8 on terminal reset
Message-ID: <20070402115411.GL26707@cel.leo>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr> <1175496595.4614.11.camel@daplas> <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr> <20070402112607.GK26707@cel.leo> <1175514253.4431.7.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <1175514253.4431.7.camel@daplas>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 02, 2007 at 07:44:13PM +0800, Antonino A. Daplas wrote:
> > Is it OK to do that? I recall when I was originally looking at the code
> > I didn't want to just remove that line, because it looked like that was
> > being used to first initialise the vc* structure when it is created, as
> > well as reset it every time. Doesn't this leave vc->vc_utf uninitialised
> > when a new VC is allocated?
>=20
> That's true.  We can move the line vc->vc_utf =3D 0; in vc_init()
> instead.=20

=2E..

> @@ -2590,6 +2589,7 @@ static void vc_init(struct vc_data *vc,=20
>  	vc->vc_rows =3D rows;
>  	vc->vc_size_row =3D cols << 1;
>  	vc->vc_screenbuf_size =3D vc->vc_rows * vc->vc_size_row;
> +	vc->vc_utf =3D 0;
> =20
>  	set_origin(vc);
>  	vc->vc_pos =3D vc->vc_origin;

While we're on that subject, did you take a look at my original mail?
The intent with that patch was to allow system policy to state all new
VCs are UTF-8-enabled by default. I feel that in 2007 this should be the
default setting.

Would it therefore be possible to have

   vc->vc_utf =3D some_default;

where some_default comes maybe from a sysctl or some other configurable
source? Or maybe even have a compiletime option?

This would get around many bugs. For example, on boot, "unicode_start"
can only set utf8 mode on the existing VCs 1 to 6. If X11 fails to
start, debian nicely runs me the XKeepsCrashing program, which offers to
show me logs and the like. It reads the locale, en_GB.UTF-8 and
determines we're in UTF-8 mode, so outputs Unicode linedrawing
characters for dialogs. Unfortunately, we're on VC7 which doesn't have
UTF-8 mode turned on, so much mess results.

It would be nice if the kernel's default UTF-8 mode for new VCs could be
synched to whatever local policy was regarding locale.

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEO7j7eTlovtaLtYRAjzVAKCBAljOKuRCZ7MQB6mWTQ/QlUuSPgCfY3AJ
L/HoK9JPtfPn85um0e8Trug=
=CU9A
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
