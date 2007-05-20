Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbXETQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbXETQDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbXETQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:03:06 -0400
Received: from mx1-2.mail.ru ([194.67.23.121]:24208 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757355AbXETQDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:03:04 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Sun, 20 May 2007 20:02:52 +0400
User-Agent: KMail/1.9.6
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Uwe Bugla" <uwe.bugla@gmx.de>, "Ken Chen" <kenchen@google.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
References: <464F42F3.1080300@madrabbit.org> <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com> <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
In-Reply-To: <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2397148.kc1Yrhy21G";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705202002.53991.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2397148.kc1Yrhy21G
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 20 May 2007, Kay Sievers wrote:
> On 5/20/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > > issues are ironed out.
> > >
> > > Hold it.  The real question here is which logics do we want there.
> > > IOW, and how many device nodes do we want to appear and _when_ do
> > > we want them to appear?
> >
> > The when part is what looks to make it racy. I'm guessing that we're
> > relying on udev to create those loop nodes. If so, I think any scheme
> > that creates more on demand would give transient mount errors while
> > it's waiting on udev to create more nodes.
> >
> > Perhaps if we were to start with 8 loop nodes at init (as we have in
> > 2.6.21), and then always maintain a margin of 8 (or 4, or...) when
> > they start being used or detached?
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>
> Until the tools can request dynamic loop device allocation from the
> kernel before they want to use the device, you can create as many as
> needed "static" loop* nodes in /lib/udev/devices/, which will be
> copied to /dev/ early on every bootup.
>

Won't these be removed after "losetup -d"?

--nextPart2397148.kc1Yrhy21G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGUHEtR6LMutpd94wRAjWrAKC0d4f/4NwmYLtuGVF3tx0TymZhLACdFUGB
0iS7CfGURFTBIH3WYJ6QNdM=
=C+GY
-----END PGP SIGNATURE-----

--nextPart2397148.kc1Yrhy21G--
