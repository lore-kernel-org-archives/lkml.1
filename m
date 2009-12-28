Return-Path: <linux-kernel-owner+w=401wt.eu-S1751166AbZL1BLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbZL1BLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZL1BLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:11:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42141 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZL1BLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:11:30 -0500
Date: Mon, 28 Dec 2009 12:11:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] core, x86: make LIST_POISON less deadly
Message-Id: <20091228121122.b1c86049.sfr@canb.auug.org.au>
In-Reply-To: <1261315350-23407-1-git-send-email-avi@redhat.com>
References: <1261315350-23407-1-git-send-email-avi@redhat.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Dec_2009_12_11_22_+1100_h3FnnYpdoyQX09sn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Dec_2009_12_11_22_+1100_h3FnnYpdoyQX09sn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sun, 20 Dec 2009 15:22:30 +0200 Avi Kivity <avi@redhat.com> wrote:
>
> From: Avi Kivity <avi@qumranet.com>
>=20
> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
> pointers in order to trap erronous use of freed list_heads.  Unfortunately
> userspace can arrange for those pointers to actually be dereferencable,
> potentially turning an oops to an expolit.
>=20
> To avoid this allow architectures (currently x86_64 only) to override
> the default values for these pointers with truly-undereferencable values.
> This is easy on x86_64 as the virtual address space is large and contains
> areas that cannot be mapped.
>=20
> Other 64-bit architectures will likely find similar unmapped ranges.
>=20
> [ingo: switch to 0xdead000000000000 as the unmapped area]
> [ingo: add comments, cleanup]
> [jaswinder: eliminate sparse warnings]
>=20
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Avi Kivity <avi@redhat.com>

The above fixed version of this patch has been in linux-next (via the tip
tree) for one year minus one day.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Dec_2009_12_11_22_+1100_h3FnnYpdoyQX09sn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks4BboACgkQjjKRsyhoI8z9WwCcDLEfHWQSp68hM2qJYtNR+NyE
rZsAn3mhFoTQDe/XW/VWFoRKaS8uMAYH
=ktrx
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Dec_2009_12_11_22_+1100_h3FnnYpdoyQX09sn--
