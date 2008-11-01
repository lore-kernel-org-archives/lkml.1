Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYKALqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYKALqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYKALpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:45:54 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:9625 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbYKALpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:45:53 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1224484046.23068.14.camel@localhost.localdomain>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9qYq4ITw/WarMglCqsy1"
Date: Sat, 01 Nov 2008 11:45:27 +0000
Message-Id: <1225539927.2221.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=4fGbTU7hGDYZjGbuzdYA:9 a=GNJKWRz-eLsIR9uMHof3lJJagTwA:4 a=LY0hPdMaydYA:10 a=4jo5AmTwbNOTfM1ua-YA:9 a=Y2sS3Fy1pZop1sd1ThGv9c3uXc4A:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9qYq4ITw/WarMglCqsy1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 07:27 +0100, Ian Campbell wrote:
> So far I have bisected down to this range and am currently testing
> acee478 which has been up for >4days.

Another update. It has now bisected down to a small range=20

7272dcd31d56580dee7693c21e369fd167e137fe SUNRPC: xprt_autoclose() should no=
t call xprt_disconnect()
e06799f958bf7f9f8fae15f0c6f519953fb0257c SUNRPC: Use shutdown() instead of =
close() when disconnecting a TCP socket
ef80367071dce7d2533e79ae8f3c84ec42708dc8 SUNRPC: TCP clear XPRT_CLOSE_WAIT =
when the socket is closed for writes
3b948ae5be5e22532584113e2e02029519bbad8f SUNRPC: Allow the client to detect=
 if the TCP connection is closed
67a391d72ca7efb387c30ec761a487e50a3ff085 SUNRPC: Fix TCP rebinding logic
66af1e558538137080615e7ad6d1f2f80862de01 SUNRPC: Fix a race in xs_tcp_state=
_change()

I'm currently testing 3b948ae5be5e22532584113e2e02029519bbad8f.

7272dcd31d56580dee7693c21e369fd167e137fe repro'd in half a day while
ef818a28fac9bd214e676986d8301db0582b92a9 (parent of
66af1e558538137080615e7ad6d1f2f80862de01) survived for 7 days.

Ian.
--=20
Ian Campbell

There is no delight the equal of dread.  As long as it is somebody
else's.
		-- Clive Barker

--=-9qYq4ITw/WarMglCqsy1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkMQVQACgkQM0+0qS9rzVmihwCg1DEN9SQZQ0aMXnu/yuAc56h0
zNoAn1KKxI82PbrrhYu27WOEzQZd2u+5
=D9KJ
-----END PGP SIGNATURE-----

--=-9qYq4ITw/WarMglCqsy1--

