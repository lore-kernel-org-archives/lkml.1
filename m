Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbYAaO5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbYAaO5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbYAaO4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:56:41 -0500
Received: from hydra.gt.owl.de ([195.71.99.218]:33274 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbYAaO4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:56:39 -0500
Date: Thu, 31 Jan 2008 15:53:41 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nai Xia <nai.xia@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       bbpetkov@yahoo.de, linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       linux-ide@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Message-ID: <20080131145341.GA32687@paradigm.rfc822.org>
References: <20080129.151353.48534987.k-ueda@ct.jp.nec.com> <adar6g0e0g2.fsf@cisco.com> <20080129.182356.70224412.k-ueda@ct.jp.nec.com> <20080130.202659.104027826.k-ueda@ct.jp.nec.com> <adamyqmafl3.fsf@cisco.com> <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com> <20080131130558.GV15220@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20080131130558.GV15220@kernel.dk>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200801311459@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2008 at 02:05:58PM +0100, Jens Axboe wrote:
> The below fix should be enough. It's perfectly legal to have leftover
> byte counts when the drive signals completion, happens all the time for
> eg user issued commands where you don't know an exact byte count.
>=20
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 74c6087..bee05a3 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1722,7 +1722,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t=
 *drive)
>  	 */
>  	if ((stat & DRQ_STAT) =3D=3D 0) {
>  		spin_lock_irqsave(&ide_lock, flags);
> -		if (__blk_end_request(rq, 0, 0))
> +		if (__blk_end_request(rq, 0, rq->data_len))
>  			BUG();
>  		HWGROUP(drive)->rq =3D NULL;
>  		spin_unlock_irqrestore(&ide_lock, flags);
>=20

Fixes the crash on boot for me ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHoeD1Uaz2rXW+gJcRAnCUAJ90L1cKLdbI0LcHb+BHrU011oUlGACgjPRg
ajBui8diuV6X6LqiuHXQxyA=
=pQEW
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
