Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbZA1Pwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbZA1Pwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZA1Pwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:52:35 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:53799 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZA1Pwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:52:34 -0500
Date: Wed, 28 Jan 2009 13:52:59 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: Don't cold reset AC97 codecs in some ICH chipsets
Message-ID: <20090128155258.GA4646@vespa.holoscopio.com>
References: <1233153642-4882-1-git-send-email-cascardo@holoscopio.com> <s5hr62nv4nn.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <s5hr62nv4nn.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2009 at 04:20:12PM +0100, Takashi Iwai wrote:
> At Wed, 28 Jan 2009 12:40:42 -0200,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > Check in a quirk list if it should do cold reset when AC97 power saving
> > is enabled. Some devices do not resume properly when cold reset,
> > although power saving works OK.
> >=20
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>=20
> Thanks, applied now.
>=20
> ... and soon I found a build error when CONFIG_SND_AC97_POWERSAVE=3Dn.
> Fixed, too :)


Sorry for this one. I've cleaned the modules and built them again with a
changed config. Must have done something wrong in the build. Thanks for
the fix.

Regarding the warning fix in 92aab0a0, it is related to this commit:
248c982a, which was proposed by you during our previous discussion, and
didn't really fix my problem.

I've been watching your tree ever since and this patch has been in your
master branch since then, perhaps awaiting some conclusion about this
issue.

Do you think it solves any problems for other device models? In my case,
if the cold reset was done, this would simply not work.

Looking closer to the patch now, I see a point in keeping it, which may
be the reason you did so. It will make the resume faster in those cases
the init_bits are different from what the driver though would be there.

In this case, I think the log message should be more clear about that,
since it seems to indicate that the commit makes the driver wait for
more codecs (all codec slots) than before the commit.

Regards,
Cascardo.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmAf1oACgkQyTpryRcqtS2vIwCgnFk49C7PqWr7nSKLJH+iaE6X
S9gAnRw53j+yNIvBQUVm/APy8+6DzjX0
=nTbL
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
