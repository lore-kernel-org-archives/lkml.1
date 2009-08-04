Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbZHDJJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbZHDJJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbZHDJJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:09:49 -0400
Received: from mail.open.by ([193.232.92.17]:55865 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbZHDJJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:09:48 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9236 [Aug 3 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 4 Aug 2009 12:12:37 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090804091237.GA3174@localdomain.by>
References: <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
 <20090804003009.GA3121@localdomain.by>
 <alpine.LFD.2.01.0908031751270.3270@localhost.localdomain>
 <20090804035319.GA7248@kroah.com>
 <20090804040834.GA16696@kroah.com>
 <alpine.LFD.2.01.0908032319290.3270@localhost.localdomain>
 <20090804072351.GA17474@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20090804072351.GA17474@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/04/09 00:23), Greg KH wrote:
> On Mon, Aug 03, 2009 at 11:19:53PM -0700, Linus Torvalds wrote:
> >=20
> >=20
> > On Mon, 3 Aug 2009, Greg KH wrote:
> > >=20
> > > Oh wait, the original problem, single user mode.  Hm, we need all of
> > > these to fix that problem?  Or just the first one?
> >=20
> > Patches 1-3 should fix that one. 4-5 are just cleanups with no semantic=
=20
> > changes.
>=20
> Ok, but due to the lateness of the release cycle, is it worth it to add
> those 3 right now?  Or do we just take the BUG_ON() out as it's pretty
> harmless while shutting down in single user mode?
>=20
> What do you think?
>=20

I don't think that take the BUG_ON out is the best we can do.=20

If I understand correctly, this one (tty_ldisc.c:209):
static void tty_ldisc_put(struct tty_ldisc *ld)
{
	[...]
	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	WARN_ON(ld->refcount);
	kfree(ld);
}

It's better to leave everything as is in that case and wait 32 (to my mind).

"there may certainly be more tty breakage there too", Linus
and WARN_ON may be quite usefull.

	Sergey

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp3+4UACgkQfKHnntdSXjQ0EQP/X1I4ArRsAcRgKgByJQsOtOMc
y5u1ApMj4+YQHN+f7gWtgZYxgQQZYVWvLJ+y3WBAE8QMpOQIUZ1KRUhClBByZwoY
UvAHYYBf5alItcE+mMAgrACVy2cj3wiywTMcM6/2EQ5VOdnjVCJi17cIS6wZzsaa
94R+nCiq8FyS5gwbEAQ=
=5i+o
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
