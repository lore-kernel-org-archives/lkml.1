Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZAVGmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZAVGmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZAVGmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:42:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36209 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZAVGmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:42:05 -0500
Date: Thu, 22 Jan 2009 17:41:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] debugfs: introduce stub for debugfs_create_size_t()
 when DEBUG_FS=n
Message-Id: <20090122174152.de6cc08e.sfr@canb.auug.org.au>
In-Reply-To: <1232515197-3974-4-git-send-email-gregkh@suse.de>
References: <20090121051855.GA3665@kroah.com>
	<1232515197-3974-4-git-send-email-gregkh@suse.de>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jan_2009_17_41_52_+1100_C_MCAO/JIixzSZ=q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jan_2009_17_41_52_+1100_C_MCAO/JIixzSZ=q
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 20 Jan 2009 21:19:56 -0800 Greg Kroah-Hartman <gregkh@suse.de> wrot=
e:
>
> From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
>=20
> Toralf F=C3=B6rster <toralf.foerster@gmx.de> reported a build failure in
> the WiMAX stack when CONFIG_DEBUG_FS=3Dn
>=20
> http://linuxwimax.org/pipermail/wimax/2009-January/000449.html
>=20
> This is due to debugfs_create_size_t() missing an stub that returns
> -ENODEV when the DEBUGFS subsystem is not configured in (like the rest
> of the debugfs API).
>=20
> This patch adds said stub.
>=20
> Reported-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  include/linux/debugfs.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> index 23936b1..0f5c33b 100644
> --- a/include/linux/debugfs.h
> +++ b/include/linux/debugfs.h
> @@ -162,6 +162,13 @@ static inline struct dentry *debugfs_create_x32(cons=
t char *name, mode_t mode,
>  	return ERR_PTR(-ENODEV);
>  }
> =20
> +struct dentry *debugfs_create_size_t(const char *name, mode_t mode,

This needs to be "static inline".  See my other email about linux-next
breakage due to this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jan_2009_17_41_52_+1100_C_MCAO/JIixzSZ=q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl4FTAACgkQjjKRsyhoI8yiSQCeLQ+a17FBs+119+n0QURoY4RA
JKcAn0uyT8sJomNA5xWrOS5Ighf+wR/g
=hovZ
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jan_2009_17_41_52_+1100_C_MCAO/JIixzSZ=q--
