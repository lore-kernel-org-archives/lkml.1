Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYFILJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYFILJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759175AbYFILJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:09:26 -0400
Received: from server.drzeus.cx ([85.8.24.28]:49484 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759536AbYFILJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:09:26 -0400
Date: Mon, 9 Jun 2008 13:08:54 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: mmc_test : some results
Message-ID: <20080609130854.2237c05a@mjolnir.drzeus.cx>
In-Reply-To: <48495843.1050902@atmel.com>
References: <48495843.1050902@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.2; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-12401-1213009409-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-12401-1213009409-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Jun 2008 17:31:15 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Hi Pierre,
>=20
> Here are the results of a mmc_test run played on at91_mci after applying=
=20
> this patch series :
> http://lkml.org/lkml/2008/5/30/201
>=20
> I skipped some of the tests just to concentrate on those ones.
>=20
> Can you tell me if the test is correct : are the errors reported for the=
=20
> xfer_size tests the normal behavior (I assume yes because a failure is=20
> simulated) ?

No. You're supposed to get an OK there as well. Basically it tests that
the driver doesn't report some unexpected error (-ETIMEDOUT is the
desired one) or overreports the number of written bytes.
>=20
> ~ # echo 1  > /sys/class/mmc_host/mmc0/mmc0\:e624/test

FYI, I've added some changes that will make that invocation only run
test 1. Do echo "" for all tests in the future.

Rgds
Pierre

--=_freyr.drzeus.cx-12401-1213009409-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhND0sACgkQ7b8eESbyJLjuEwCfeZfk78YomXTtMF5hej5hZffO
Qo8AnjrGdgcC75XI8gAK2OlhPxZKnxDj
=z4BM
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-12401-1213009409-0001-2--
