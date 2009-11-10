Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZKJQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZKJQpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbZKJQpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:45:38 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:50413
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757132AbZKJQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:45:38 -0500
Date: Tue, 10 Nov 2009 14:45:37 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, device@lanana.org, akpm@linux-foundation.org,
       rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
	allocation
Message-ID: <20091110164536.GA3628@vespa.holoscopio.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com> <1257813017-28598-2-git-send-email-cascardo@holoscopio.com> <1257813017-28598-3-git-send-email-cascardo@holoscopio.com> <4AF8B4FF.9050405@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <4AF8B4FF.9050405@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 09, 2009 at 04:34:07PM -0800, H. Peter Anvin wrote:
> On 11/09/2009 04:30 PM, Thadeu Lima de Souza Cascardo wrote:
> > The current dynamic allocation of minor number for misc devices has some
> > drawbacks.
> >=20
> > First of all, the range for dynamic numbers include some statically
> > allocated numbers. It goes from 63 to 0, and we have numbers in the
> > range from 1 to 15 already allocated. Although, it gives priority to the
> > higher and not allocated numbers, we may end up in a situation where we
> > must reject registering a driver which got a static number because a
> > driver got its number with dynamic allocation. Considering fs/dlm/user.c
> > allocates as many misc devices as lockspaces are created, and that we
> > have more than 50 users around, it's not unreasonable to reach that
> > situation.
> >=20
> > The proposed solution uses the not yet reserved range from 64 to 127. If
> > more devices are needed, we may push 64 to 16.
> >=20
>=20
> Again, why not push these up above 256?
>=20
> 	-hpa

I don't have a problem with this. However, as Alan has pointed out,
there may be old setups that rely on minor numbers below 256. I have
thought of that, but I'm sure there's argument against it. I've decided
to submit it more closely to what is done today, that is, 64 devices. As
I said, there's still space for 48 more devices, and, besides DLM, I
couldn't find at first glance any other user that requests more than one
single device.

Anyway, the only thing that worries me when pushing it above 256 is
that, right now, the bitmap is statically allocated, and I think a
single page would be pretty more than we have and we need right now.
Otherwise, I would suggest using a dynamic allocation system, which
would be less simple than what we have right now, and Andrew has pointed
out.

Best Regards,
Cascardo.

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr5mLAACgkQyTpryRcqtS0EAwCfWvZLoVBF0UDOi8OmxuRJgewk
rawAoIBSlToEJlSj+vzm9W0ah/9LGbqu
=Ph8L
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
