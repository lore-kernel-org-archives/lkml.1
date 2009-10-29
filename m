Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZJ2CdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZJ2CdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZJ2CdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:33:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57687 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbZJ2CdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:33:09 -0400
Date: Thu, 29 Oct 2009 13:33:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH resend] define convenient securebits masks for prctl
 users
Message-Id: <20091029133306.0cb87521.sfr@canb.auug.org.au>
In-Reply-To: <20091028140236.GA8157@us.ibm.com>
References: <20091028140236.GA8157@us.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Serge,

On Wed, 28 Oct 2009 09:02:36 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wro=
te:
>
> [ Are there any objections to exporting securebits.h?  If not,
> can this patch be pushed to linux-next? ]

I am not sure which tree this belongs in?  Maybe security-testing (James
cc'd)?

> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index d2c5ed8..9ad109e 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -1,6 +1,13 @@
>  #ifndef _LINUX_SECUREBITS_H
>  #define _LINUX_SECUREBITS_H 1
> =20
> +/* Each securesetting is implemented using two bits. One bit specifies
> +   whether the setting is on or off. The other bit specify whether the
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
> +#define issecure_mask(X)	(1 << (X))
> +#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))

You want this second define protected by ifdef __KERNEL__ ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkro/uIACgkQjjKRsyhoI8yk8QCeOoAWptTrIocoGY3N4tFvjm8V
x6IAn1cgPDdSHCN1l5R4jjupgbkeSAyw
=9xpe
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU--
