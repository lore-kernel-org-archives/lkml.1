Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbYFHMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbYFHMl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYFHMlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:41:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:58103 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755482AbYFHMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:41:51 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX19XQ1tQ24lXv4JvGTVT54RbNFZqvu56rVO5rA2bc4
	qpCpYdW4F+ckr5
Date: Sun, 8 Jun 2008 14:41:12 +0200
From: Mirco Tischler <mt-ml@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080608144112.1d623ed4@mtlp.tischlernetz>
In-Reply-To: <20080527235619.GI11310@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz>
 <20080525181118.GG1791@cs181133002.pp.htv.fi>
 <1211742202.14556.25.camel@mtlp.tischlernetz>
 <20080525201807.GK1791@cs181133002.pp.htv.fi>
 <1211749036.16921.16.camel@mtlp.tischlernetz>
 <20080525210329.GN1791@cs181133002.pp.htv.fi>
 <1211752151.16921.25.camel@mtlp.tischlernetz>
 <1211836606.10718.18.camel@mtlp.tischlernetz>
 <20080527235619.GI11310@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VZPAWRdt_QR1slzy9.=rPEX";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VZPAWRdt_QR1slzy9.=rPEX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Here's an update:
I've contacted the gcc folks. Here is the bugzilla entry:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D36359
We were able to trace the error down to usb_submit_urb() in
drivers/usb/core/urb.c which calls ilog2() and the gcc falsely assumes its
argument (urb->interval) to be zero. But as I understood they say it's the
kernel's fault because the code depends on correct optimization what seems a
little weird for me as incorrect optimization is a gcc bug IMHO. But I am n=
ot
an expert and maybe I've just understood something wrong because I'm not a
native speaker.

Thanks
Mirco

--Sig_/VZPAWRdt_QR1slzy9.=rPEX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIS9Ntz+diZ7c2xfgRAv8/AJ4tZjTQwfyUsR1aEeS1+rhN0Ab3kwCdFKql
zNtaMJGu4BUAERwU/ZMAvS0=
=y+Xz
-----END PGP SIGNATURE-----

--Sig_/VZPAWRdt_QR1slzy9.=rPEX--
