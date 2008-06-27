Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbYF0QaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbYF0QaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYF0Q3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:29:52 -0400
Received: from server.drzeus.cx ([85.8.24.28]:59604 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751476AbYF0Q3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:29:51 -0400
Date: Fri, 27 Jun 2008 18:29:45 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Andres Salomon <dilinger@queued.net>
Cc: akpm@linux-foundation.org, drzeus-sdhci@drzeus.cx,
       sdhci-devel@lists.drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [OLPC] sdhci: add quirk for the Marvell CaFe's vdd/powerup
 issue
Message-ID: <20080627182945.615d5adf@mjolnir.drzeus.cx>
In-Reply-To: <20080621211516.0645a46f@xo-debian>
References: <20080621211516.0645a46f@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-26890-1214583595-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-26890-1214583595-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jun 2008 21:15:16 -0400
Andres Salomon <dilinger@queued.net> wrote:

> This has been sitting around unloved for way too long..
>=20
> The Marvell CaFe chip's SD implementation chokes during card insertion
> if one attempts to set the voltage and power up in the same
> SDHCI_POWER_CONTROL register write.  This adds a quirk that does
> that particular dance in two steps.
>=20
> It also adds an entry to pci_ids.h for the CaFe chip's SD device.
>=20
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Looks ok, but please try to diff against my -next branch. The sdhci
driver has been split up into a core and PCI part.

> @@ -774,6 +784,14 @@ static void sdhci_set_power(struct sdhci_host *host,=
 unsigned short power)
>  		BUG();
>  	}
> =20
> +	/*
> +	 * At least the CaFe chip gets confused if we set the voltage
> +	 * and set turn on power at the same time, so set the voltage first.
> +	 */

This comment should probably say "Marvell controller" or something like
that. Few know of the CaFE name.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-26890-1214583595-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhlFX0ACgkQ7b8eESbyJLhYQgCg1D4Gh5rlt/xI5Ufv6LNnLfd0
l8EAoKyNktJG2ccBwB0tJ1gWRXrkU2kg
=J4UI
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-26890-1214583595-0001-2--
