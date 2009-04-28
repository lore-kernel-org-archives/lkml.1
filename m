Return-Path: <linux-kernel-owner+w=401wt.eu-S1762358AbZD1POc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762358AbZD1POc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761909AbZD1PIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:08:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47117 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761895AbZD1PII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:08:08 -0400
Date: Wed, 29 Apr 2009 01:07:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 11/14] powerpc: Use macros for .data.page_aligned
 section.
Message-Id: <20090429010753.851e0f59.sfr@canb.auug.org.au>
In-Reply-To: <1240864388-26315-12-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
	<1240864388-26315-2-git-send-email-tabbott@mit.edu>
	<1240864388-26315-3-git-send-email-tabbott@mit.edu>
	<1240864388-26315-4-git-send-email-tabbott@mit.edu>
	<1240864388-26315-5-git-send-email-tabbott@mit.edu>
	<1240864388-26315-6-git-send-email-tabbott@mit.edu>
	<1240864388-26315-7-git-send-email-tabbott@mit.edu>
	<1240864388-26315-8-git-send-email-tabbott@mit.edu>
	<1240864388-26315-9-git-send-email-tabbott@mit.edu>
	<1240864388-26315-10-git-send-email-tabbott@mit.edu>
	<1240864388-26315-11-git-send-email-tabbott@mit.edu>
	<1240864388-26315-12-git-send-email-tabbott@mit.edu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Apr_2009_01_07_53_+1000_iaD9/.Vhwwp9qaES"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Apr_2009_01_07_53_+1000_iaD9/.Vhwwp9qaES
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tim,

Firstly, patches for a particular architecture should really be cc'd to
the list associated with that architecture.  In this case,
linuxppc-dev@ozlabs.org (cc'd).

On Mon, 27 Apr 2009 16:33:05 -0400 Tim Abbott <tabbott@MIT.EDU> wrote:
>
> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -222,6 +222,7 @@ SECTIONS
> =20
>  #ifdef CONFIG_PPC32
>  	.data : AT(ADDR(.data) - LOAD_OFFSET) {
> +		PAGE_ALIGNED_DATA
>  		DATA_DATA
>  		*(.sdata)
>  		*(.got.plt) *(.got)
> @@ -259,11 +260,6 @@ SECTIONS
>  		*(.data.init_task)
>  	}
> =20
> -	. =3D ALIGN(PAGE_SIZE);
> -	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
> -		*(.data.page_aligned)
> -	}
> -

This moves the page_aligned section from a common part of the
vmlinux.lds to a 32 bit only part.  Was that intentional?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Apr_2009_01_07_53_+1000_iaD9/.Vhwwp9qaES
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn3G8kACgkQjjKRsyhoI8w3FgCfb8JFX/KnkIXLvseIwHQEDQWq
cJwAniqdZMkUcyCnxdU3lIZbIUenyPqQ
=yCB6
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Apr_2009_01_07_53_+1000_iaD9/.Vhwwp9qaES--
