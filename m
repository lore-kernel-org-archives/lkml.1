Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXBTIAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXBTIAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964886AbXBTIAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:00:21 -0500
Received: from mail.korelogic.com ([66.92.20.26]:53532 "EHLO
	mail.korelogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964949AbXBTIAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:00:19 -0500
X-Greylist: delayed 1693 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 03:00:19 EST
Date: Tue, 20 Feb 2007 02:31:30 -0500
From: Hank Leininger <hlein@korelogic.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Accessing file-offset info for fds in /proc?
Message-ID: <20070220073130.GV5752@timmy.spinoli.org>
Reply-To: Hank Leininger <hlein@korelogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pc5IaVc7IO8UaUVr"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Pc5IaVc7IO8UaUVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Is there anything provided by the kernel that would let you see the
current offset of an existing filehandle?

Sometimes when processing a very large file (grepping a log, bzip2'ing
or gpg'ing a file, or whatever), I'd really like to know how far along
it is, because I'm impatient.  lsof has an -o flag to show offsets for
file descriptors it lists, but it appears that's not supported under
Linux.  It looks like all of the information lsof and fuser print about=20
files in use, etc can be gotten from /proc/*/fd/* (and /proc/*/maps, but
I'm not really concerned with mmap'ed files, just positions on fds).
Sometimes I'll resort to strace -s4096'ing the process to see what chunk
of text it's currently reading, and try to guess from that.  Silly.

Has anybody ever developed a patch to implement this?  I realize this
could create a variety of information-leakage problems; the information
probably would need to be restricted, such as by the same rules as
dumpable.  Are there any horribly painful reasons why this couldn't be
done?

Thanks,

--=20

Hank Leininger <hlein@korelogic.com>
F980 A584 5175 1996 DD7E  C47B 1A71 105C CB44 CBF8

--Pc5IaVc7IO8UaUVr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----

iD8DBQFF2qPSGnEQXMtEy/gRAgYBAJ4zYv2nTlau/Bdt9s7hw79pRN1pZwCgnzfW
uHx8TaIJ1XFkEBMJHNygHEU=
=fL1D
-----END PGP SIGNATURE-----

--Pc5IaVc7IO8UaUVr--
