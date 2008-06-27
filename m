Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYF0RaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYF0RaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYF0RaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:30:09 -0400
Received: from server.drzeus.cx ([85.8.24.28]:43276 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752277AbYF0RaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:30:08 -0400
Date: Fri, 27 Jun 2008 19:30:01 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Andres Salomon <dilinger@queued.net>
Cc: akpm@linux-foundation.org, drzeus-sdhci@drzeus.cx,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [OLPC] sdhci: add quirk for the Marvell CaFe's
 interrupt timeout
Message-ID: <20080627193001.5925f664@mjolnir.drzeus.cx>
In-Reply-To: <20080623101352.3bbaf5b0@xo-debian>
References: <20080623101352.3bbaf5b0@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-27365-1214587209-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-27365-1214587209-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2008 10:13:52 -0400
Andres Salomon <dilinger@queued.net> wrote:

>=20
> The CaFe chip has a hardware bug that ends up with us getting a timeout
> value that's too small, causing the following sorts of problems:
>=20
> [   60.525138] mmcblk0: error -110 transferring data
> [   60.531477] end_request: I/O error, dev mmcblk0, sector 1484353
> [   60.533371] Buffer I/O error on device mmcblk0p2, logical block 181632
> [   60.533371] lost page write due to I/O error on mmcblk0p2
>=20
> Presumably this is an off-by-one error in the hardware.  Incrementing
> the timeout count value that we stuff into the TIMEOUT_CONTROL register
> gets us a value that works.  This bug was originally discovered by
> Pierre Ossman, I believe.
>=20
> [thanks to Robert Millan for proving that this was still a problem]
>=20
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Hmm... I'm not entirely sure about the specifics of the workaround
here. It's likely that we'll have an off-by-minus-one in another
controller, and off-by-two in a third.

Perhaps we should just have "broken timeout" and set the timeout to
0xE. It doesn't cause any side-effects except that the user will have
to wait slightly longer for requests to fail if the card has decided to
crap out.

> @@ -479,6 +482,13 @@ static void sdhci_prepare_data(struct sdhci_host *ho=
st, struct mmc_data *data)
>  			break;
>  	}
> =20
> +	/*
> +	 * Compensate for an off-by-one error in the CaFe hardware; otherwise,
> +	 * a too-small count gives us interrupt timeouts.
> +	 */

Same issue with "CaFE" as the previous patch.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-27365-1214587209-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhlI5wACgkQ7b8eESbyJLhnUwCgyrED06jqUvlx+zJkaaGZ5EAX
Vl8AnA5hpKuil8LHOcpqtVOBHmZcGMw/
=rlgs
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-27365-1214587209-0001-2--
