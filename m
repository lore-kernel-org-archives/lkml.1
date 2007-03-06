Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXCFOFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXCFOFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965031AbXCFOFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:05:55 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:46016 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965034AbXCFOFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:05:54 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 09:05:54 EST
Date: Tue, 06 Mar 2007 14:05:24 +0100
From: markus reichelt <ml@mareichelt.de>
Subject: Re: encrypting jffs2 filesystem with DM-crypt or what else?
In-reply-to: <2cf1ee820703060405l1cd30bf1o896910341bb8f293@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Mail-followup-to: linux-kernel@vger.kernel.org
Message-id: <20070306130524.GG4168@tatooine.rebelbase.local>
Organization: still stuck in reorganization mode
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-disposition: inline
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
References: <2cf1ee820703060405l1cd30bf1o896910341bb8f293@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* emin ak <eminak71@gmail.com> wrote:

> I need to encrypt a jffs2/mtd formatted flash filesystem for an
> embedded device, Normally using a loopback interface (cryptoloop,
> DM-crypt or loop-aes) solves this problem but they are not well
> known on journalling file systems (like jffs2) because of cached
> write etc.. Also I could'nt find any guideline for encrypting
> fikesystem on a flash.

device-backed loops are ok, file-based once aren't. The cache issue
you talk about concerns writing caches of HDDs f.e., I haven't seen a
flash device with writing cache. However, in most cases writing cache
can be turned off.

Go with README in the loop-aes package. Don't use cryptoloop, it's
insecure.


> There is an ugly workaround to overcome this problem, I have placed
> an encrypted ext2 filesystem image on an normal jffs2 partition and
> mount this encrypted partition on a loopback, but this is not
> secure, consumes alot for disk space and not reliable (is'nt it?)
> Is there any other way to encrypt an jjffs2 partition, if not, what
> do you think about my ugly workaround?

You shouldn't do that. One more option is, in case you feel lucky and
space is not of great concern, ecryptfs in latest kernels. It's still
experimental but its roadmap looks promising. And they need testers
;-)


--=20
left blank, right bald

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF7WcULMyTO8Kj/uQRAiNeAJ9Q+gSmE6tvz4EuS3sl2SiMib0BIQCeNh4s
S0CVauK8cu3ACmCh8fI2OiY=
=Cp4N
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--

