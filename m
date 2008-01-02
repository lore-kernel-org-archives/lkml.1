Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYABPsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYABPsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYABPsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:48:02 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60070 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbYABPsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:48:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch] linux/{socket,stat}.h: change __GLIBC__ cruft to __KLIBC__
Date: Wed, 2 Jan 2008 10:47:58 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200801020937.50770.vapier@gentoo.org> <20080102151335.GA15898@does.not.exist>
In-Reply-To: <20080102151335.GA15898@does.not.exist>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1224319.mnmk7AFgc0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801021047.59006.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1224319.mnmk7AFgc0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 02 January 2008, Adrian Bunk wrote:
> On Wed, Jan 02, 2008 at 09:37:50AM -0500, Mike Frysinger wrote:
> > The __GLIBC__ hacks were re-added to the headers because the klibc peeps
> > want to be lazy.  But rather than properly address things, they just
> > wrongly left it as __GLIBC__.  This patch changes the __GLIBC__ cruft to
> > __KLIBC__ so real libcs don't get screwed due to kilbc's laziness.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index c22ef1c..90af15b 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -16,7 +16,7 @@ struct __kernel_sockaddr_storage {
> >  				/* _SS_MAXSIZE value minus size of ss_family */
> >  } __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignme=
nt
> > */
> >
> > -#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
> > +#if defined(__KERNEL__) || defined(__KLIBC__)
> >...
>
> This changes the semantics from "!glibc" to "klibc".

that's the point

> I'm a bit worried that such changes might break some of the other
> libc's people use on Linux.

such libc's are broken and it isnt the kernel's problem to cater to broken=
=20
libc's.  the problem is that these headers are breaking things *now* for=20
valid libc's that are not glibc.  removal of __GBLIC__ was already accepted=
=20
once but reverted for klibc.
=2Dmike

--nextPart1224319.mnmk7AFgc0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iQIcBAABAgAGBQJHe7IuAAoJEEFjO5/oN/WB/TYQAJffFphbYb+U2iEwbcQwx9EI
0OVPaRfkfItHImVcv471YNCA/vjLb84fbb2H045YHUYhl5uuohfMB2QKKeSayT2s
si9Ja+HOnWXwITh3JzKblj9sleweKRbaKpEKDQZVIrmk5+JXjCboTFMRcKD52jLa
25xSeBdZVb0pfwB1QrdvMhZgnvEKr5RlacL0n58lYC5jVNNk8zvUQSNv05GR8YgB
awkdc+3oa3jwcbu5woVHBjVcgsCJZF+5pSX/HaHhBOsFY6uKLdw/pJolSDqcOcML
9Ds/mUZX44SJPKUtPIC2nXyZwRO6JR6nP/6eFi59tlwhuCKPb0qtM5gwRcc2wfYy
y0P7rj8jStZKhvkOefQrMnkr728eTlnqs1bR6UFn7EL0YFWAct8u8ItTUnhCKS4B
a/nqJxYHir+loTNvFSOy+G8Dp5OB7JAEzI9gxXAF6A+HZlsv/RsP1QZHNj4Smq/O
gMEh7s8/jxxHDSdGl5vpDRakV1dLwy+EGQcCXepX4rgYR1ztOW8fi9W8pf2Nq3c8
MDAR3bjlMkjK4V9pW7ZXTTwvAQC3bYcEGekcogvtgN6TP9GFvD8d93J9KW/oswS5
U9IZw5ntS6DJyyBQKhBpc897i72Fd1d7kJD9ViydzbcEW8XDnkv2V8uKhOPywvHN
4bidXtY3gEY73ZRiZcW6
=k8/9
-----END PGP SIGNATURE-----

--nextPart1224319.mnmk7AFgc0--
