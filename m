Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZKDXMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZKDXMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933060AbZKDXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:12:09 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:57266 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbZKDXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:12:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Martin Nybo Andersen <tweek@tweek.dk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: Your message of "Wed, 04 Nov 2009 22:11:47 +0100."
             <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <20091104165407.1481bc29@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz> <200911041848.48721.tweek@tweek.dk> <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz> <22108.1257364949@turing-police.cc.vt.edu> <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz> <23950.1257367315@turing-police.cc.vt.edu>
            <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257376315_3622P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 18:11:55 -0500
Message-ID: <31644.1257376315@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4AF20A3C.0082,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257376315_3622P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Nov 2009 22:11:47 +0100, Mikulas Patocka said:

> Another example: I needed new binutils because it had some bugs fixed over 
> standard Debian binutils. So I downloaded .tar.gz from ftp.gnu.org, 
> compiled it, then issued a command to remove the old package, passed it a 
> flag to ignore broken dependencies and then typed make install to install 
> new binaries. --- guess what --- on any further invocation of dselect it 
> complained that there are broken dependencies (the compiler needs 
> binutils) and tried to install the old binutils package!

> Why is the package management so stupid? Why can't it check $PATH for "ld" 
> and if there is one, don't try to install it again?

Because it has no way to tell what version of /usr/bin/foobar you installed
behind its back, if it's GNU Foobar or some other foobar, what its flags are,
whether it's bug-compatible with the foobar other things on the system are
expecting, and so on. (And go look at the scripts/ver_linux file in the Linux
source tree before you suggest the package manager run the program to find out
its version. That's only 10-15 binaries, and you'd need something like that for
*every single thing in /usr/bin). And it can't blindly assume you installed a
newer version - you may have intentionally installed a *backlevel* binary,
because you found a showstopper bug in the shipped version. So the only sane
thing it can do is try to re-install what it thinks is current.

Walking $PATH is even worse - if it finds a /usr/local/bin/ld, it's a pretty
damned good guess that it's there *because* it's not the /bin/ld that the
system shipped with.  So why should it use it?

--==_Exmh_1257376315_3622P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8go7cC3lWbTT17ARAvqLAKDV5dyJadb4cyAlz6wUBFM0BUn8vACfRrXN
Pi8rYMQ0QxgL3zqfFzvbojY=
=roYu
-----END PGP SIGNATURE-----

--==_Exmh_1257376315_3622P--

