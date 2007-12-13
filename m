Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbXLMQrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbXLMQrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763463AbXLMQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:46:01 -0500
Received: from piware.de ([213.9.79.162]:51619 "EHLO box79162.elkhouse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763275AbXLMQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:46:00 -0500
X-Greylist: delayed 1273 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 11:45:59 EST
Date: Thu, 13 Dec 2007 17:24:48 +0100
From: Martin Pitt <martin.pitt@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Collins <ben.collins@ubuntu.com>
Subject: Providing an ELF flag for disabling LD_PRELOAD/ptrace()
Message-ID: <20071213162448.GG6173@piware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi kernel developers,

one thing that has bothered me for a long time already is the
complete lack of a security boundary between processes of the same
user. Things like LD_PRELOAD and ptrace() (IOW, gdb) are enabled by
default for all users, and especially for developers this is a good
thing.

However, a lot of programs that we have deal with passwords and other
secrets which deserve some protection, like passwords you type into
ssh, screensavers, seahorse, etc.

This problem has become more pressing with the advent of PolicyKit,
where even fewer processes have the in-built privilege separation
between root and users.

This concerns a scenario where you might have a rogue trojan in your
session (e. g. a malicious firefox plugin or an autostart shell
script). Admittedly, if an attacker gets that far he has almost won
the machine and can easily get more privileges with some social
engineering and spoofing, but I feel it is worth the small effort to
at least not allow reading passwords from other processes' memory
without making any noise at all. This would also greatly reduce the
potential of a local trojan spreading itself over existing ssh
connections to other hosts (provided that the ssh executable is
protected like that, which it should be anyway because it deals with
passwords).

What I want is the behaviour of suid/sgid executables (which do
something like an atomic prctl(PR_SET_DUMPABLE, 0) to disable vectors
like ptrace(), LD_PRELOAD, etc. However, making binaries setugid just
for that is less than ideal, since it requires a lot of code patching
(to reset the group) and packaging changes (to maintain the
sgid setting), as well as confusing security scanners, etc.

So I wonder whether we can define a flag in the ELF header which
triggers the same behaviour? Can we define an e_flags bit for that?

Thanks in advance for any comment or idea,

Martin

--=20
Martin Pitt        http://www.piware.de
Ubuntu Developer   http://www.ubuntu.com
Debian Developer   http://www.debian.org

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHYVzQDecnbV4Fd/IRAsjNAJ9zPD3FZK/IUzPy6JJpRiprdrGsfwCgnS+9
7zjxVmXY9CZBv7ehNGHSvO0=
=crjf
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
