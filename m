Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYLDV4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYLDV4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYLDV41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:56:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49759 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYLDV40 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:56:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: Peter Teoh <htmldeveloper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
In-Reply-To: Your message of "Thu, 04 Dec 2008 10:40:56 +1100."
             <1228347656.6993.31.camel@lappy.spacevs.com>
From: Valdis.Kletnieks@vt.edu
References: <1228260494.24232.21.camel@compy.ivent.com.au> <20081203005338.6472db7a@lxorguk.ukuu.org.uk> <1228268657.6679.4.camel@lappy.spacevs.com> <20081203124252.GD11807@mail.local.tull.net> <1228344292.6993.27.camel@lappy.spacevs.com> <20081203230820.4473a162@lxorguk.ukuu.org.uk> <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com>
            <1228347656.6993.31.camel@lappy.spacevs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228427770_3727P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 16:56:10 -0500
Message-ID: <80413.1228427770@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228427770_3727P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Dec 2008 10:40:56 +1100, Geoffrey McRae said:

> Ok, so this is a pretty major flaw of the idea, thats why I put this
> concept out there, any suggestions as to how to get around this?
> Possibly add some checking to disable certain functions in the child
> when the enable_setpresuid function has been called?.

Or just deploy SELinux instead.

> Or save the signal handlers the first time setpresuid is called, and the
> next time, restore them so if the child has changed them, they get
> re-set back to their initial state?

It's not just signal handlers.

	while (getpid()) msleep(1);
	/* malicious code here */

Just loop, pop up every few milliseconds and check if you're root,
and fall out of the loop and go into attack mode if you are.

If you're using it to toggle between various non-root userids, just adjust
the while accordingly: 'while ((me = getpid()) != 497) ...'  or whatever
you need.

And if you try to disable getpid to prevent that attack, consider something
that does this:

	while (open("only_creatable_by_target_uid",O_CREAT) < 0)

You can hardly take open() away from processes. ;)

> I know many people are against the idea of adding new functions at will
> to the kernel, thats why I am trying to flesh out all the potential
> problems and find solutions to them first.

We don't mind adding functions.  We just hate broken-by-design functions.

--==_Exmh_1228427770_3727P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOFH6cC3lWbTT17ARAvolAJkBxPPcGSvgW0kkMqDizPbNIPWH0wCcDN3+
4whkVXOcs9ff8jaiPuarMEM=
=jD1p
-----END PGP SIGNATURE-----

--==_Exmh_1228427770_3727P--
