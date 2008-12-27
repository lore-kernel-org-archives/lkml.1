Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYL0U5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYL0U5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbYL0U5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:57:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57071 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbYL0U5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:57:08 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Sat, 27 Dec 2008 15:57:05 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <200812271505.46872.vapier@gentoo.org> <495693E5.3060604@zytor.com>
In-Reply-To: <495693E5.3060604@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5757080.kjsY8z0YAf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812271557.07003.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5757080.kjsY8z0YAf
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 15:45:25 H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > On Saturday 27 December 2008 14:23:19 H. Peter Anvin wrote:
> >> Mike Frysinger wrote:
> >>> {su}{8,16,32,64} doesnt matter too much to me vs
> >>> {u,}int_t{8,16,32,64}_t. as long as people stop using
> >>> __{su}{8,16,32,64}.  using the latter though does mean headers will
> >>> more likely be "just usable" w/out needing linux/types.h include.  but
> >>> then people would be forced to include stdint.h or similar before a
> >>> linux header ... and that sucks.
> >>
> >> That is a total non-starter.  This would mean that the C library itself
> >> cannot use these headers without exporting additional symbols into the
> >> namespace, *WHICH IT IS NOT ALLOWED TO DO*.
> >
> > which is already happening today you mean.  grep the kernel headers and
> > you'll see a ton of [u]intXX_t hits.
>
> Now, keep in mind this is only true for headers exported to userspace.
> But this is correct - which is the base of this conversation (Sam
> suggesting that they should be warned about, and I suggested
> auto-converting them.)

if the topic is for autoconverting the uintXX_t (and related) types to __uX=
X=20
(and related), then that's easy to do i would think.  i can post a patch to=
 do=20
that.

> > this logic though means that the kernel should not be defining any
> > structures that the C library is defining (such as asm-generic/fcntl.h)=
=2E=20
> > such structs should get renamed the same way as __[us]XX types
>
> This is also correct, at least for exported headers.  For
> kernel-internal headers, it doesn't matter.  Unfortunately we do have at
> least several cases of exported interfaces with globally visible names.
>
> There is one other exception of note, which is a header file which can
> only be included by the userspace *application*, using a nonportable
> top-level include (either directly <linux/*> or indirectly via <sys/*>).
>  In those cases we can be looser about at least structure names.  This
> is common for ioctl structures.

the structures that go through ioctls rarely are an issue.  trouble often=20
brews when dealing with POSIX functions that have a very similar (if not=20
direct) version in the kernel interface that utilize structures.  i mention=
=20
the fcntl structure because ive seen that with a couple of packages where t=
he=20
version in the kernel headers conflicts with the version in the C library. =
 or=20
where the kernel ABI structure is not directly compatible with the POSIX C=
=20
library structure ... the stat struct is an example of this where the C=20
library has to know the layout of both and converts one to the other.

looking at asm-generic/fcntl.h, i'd propose this change as a template:
=2E..
#ifdef __KERNEL__
# define kernel_flock flock
#endif
struct kernel_flock {
=2E..
=2Dmike

--nextPart5757080.kjsY8z0YAf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVpaiAAoJEEFjO5/oN/WB58sQAIonb1h1L8Kr2ExZ0bNWl8o8
7C7bWGH7ob+Qnn0rSsIwmAvoyA8yzO9N4EVOOwOOY9eowa8Bv9IOOiurIFgD9zII
S/SMR0Y0viE6CwJdC+gC/ywe3xOkxeQ2YFifohGexHkt/siM39FJeizX+wgGdRmz
lcX2hjAA/2eaaxH8xT9Ysi5B0hun4XvH6RZklSwbAwEiflL70mxKHBSW6CoZT+Bd
m0zYRb79ZawWsPfFD6UvdRPkgIgzWSbeg7gARv/r+qz4ujc+hV1JJU6UYz6ICcqy
IKwTkfXRatkOq50XRZmPYh9ku1g5WKX4mb7Pz3CshdKIvD7DoIUdsxecS5cALk14
JAIgU6WC4DMZMT4mSoFgri5/O95js3la9X/ye4uvRre7alQ3t9wjSAZ6LsvqWY1y
sNBg/AJG5u+XokAU3IU8QyXGemdzi1nCQJllTns8J9TAx3l4vZJClkHsNS5cGw9l
QamOzDNJy5k93wpiqORxTyy1KeSyWGKBQxNFUihe4WhGz6rhg7UF1zI70x8mwtTC
gZaLjCJ6mqQBuqmlXJI0hwtd5gpe/zSWTRrtobYkzq7+rje1TFstUEkDP7HRFT/P
CgnbpZhT+oCqxTNeF4saWlmUZeDM07AZHjvTFtLOb6CsEbFpbmJKiJeu3QRFo+0l
2oFpOJytmM8Bblx7sQPX
=XyZF
-----END PGP SIGNATURE-----

--nextPart5757080.kjsY8z0YAf--
