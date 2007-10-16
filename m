Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbXJPLiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbXJPLiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbXJPLiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:38:15 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:47931 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759592AbXJPLiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:38:14 -0400
Date: Tue, 16 Oct 2007 13:38:00 +0200
From: Kristof Provost <Kristof@provost-engineering.be>
To: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [BUG] memory leak in dm
Message-ID: <20071016113800.GA4631@luggage>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Scanned: 2.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,

I'm seeing a serious memory leak whenever I use my /home partition.
It's an encrypted partition using dm-crypt. Simply running=20
'stress -d 5' is enough to exhaust the memory in a few minutes.

When I stop 'stress' the memory isn't returned.
This doesn't seem to happen when I run stress on a normal (no dm and=20
no encryption) partition.

Here's the output of 'free -m' before and after 'stress -d 1 -t 5'
Before:
             total       used       free     shared    buffers     cached
Mem:           751        584        167          0         14        235
-/+ buffers/cache:        334        416
Swap:          980          0        980

After:
             total       used       free     shared    buffers     cached
Mem:           751        619        131          0         12        169
-/+ buffers/cache:        437        313
Swap:          980          0        980

That's 100Mb of RAM gone in 5 seconds. =20

I'm using a standard x86 centrino laptop.
The log files don't reveal anything suspicious.

git bisect tells me it started in one of these commits:
d24517d793f21edab1a411da95f2c45cb88a84aa,=20
5bb23a688b2de23d7765a1dd439d89c038378978 and=20
9cc54d40b8ca01fcefc9151044b6996565061d90.=20

The bug is still present in the last version of Linus' tree
(65a6ec0d72a07f16719e9b7a96e1c4bae044b591)

Let me know if I can provide more information.

Regards,
Kristof

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHFKKYUEZ9DhGwDugRAhi3AJ9hWWWU6fOj4vdOWCpPz2eizWYiaQCdF1aj
fXBftKdoLNl3cbT9zKBaYEY=
=tno8
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
