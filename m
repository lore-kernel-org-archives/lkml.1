Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbZC0Q24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbZC0Q24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbZC0Q2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:28:46 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:4319 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZC0Q2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:28:46 -0400
Message-ID: <49CCFEBA.6060009@imap.cc>
Date: Fri, 27 Mar 2009 18:28:42 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Help: tasklet blocked for >8msec
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2B53C522A24EF27745B40F78"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2B53C522A24EF27745B40F78
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

A user of the Gigaset base driver (drivers/isdn/gigaset/bas-gigaset.c)
reports his connection being dropped exactly every 30 seconds.
Analysis of his dmesg indicates that when the error occurs, both the
tasklets read_iso_tasklet and write_iso_tasklet handling the B channel
data stream (125 USB isochronous packets per second in each direction)
are at the same time not executed for an entire inter-packet interval,
ie. 8 msecs.

The machine in question, an Intel Core2 Duo E8600 with 4 GB RAM and
SATA hard disks, should really be fast enough. CPU load is negligible.
I have asked the user to recompile the kernel with CONFIG_PREEMPT=3Dy
and to replace the calls to schedule_tasklet() for the two tasklets
by schedule_hi_tasklet(). That had no noticeable effect on the problem.

I would be grateful for any hint on what could be the cause for that
blockage and how to prevent it.

aTdHvAaNnKcSe
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2B53C522A24EF27745B40F78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJzP66Q3+did9BuFsRAni6AJwM+JV2MfPhD60ptpqE+8MbhhxLEACfaLMT
QhkhBUlOaLKnWPmVm76tBoM=
=3Kj4
-----END PGP SIGNATURE-----

--------------enig2B53C522A24EF27745B40F78--
