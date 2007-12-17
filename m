Return-Path: <linux-kernel-owner+w=401wt.eu-S935536AbXLQQSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536AbXLQQSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbXLQQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:18:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:59208 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbXLQQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:18:20 -0500
From: Ritesh Raj Sarraf <rrs@researchut.com>
Reply-To: Ritesh Raj Sarraf <rrs@researchut.com>
Organization: RESEARCHUT
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Suspend-devel] Fwd: Kernel Oops with 2.6.23
Date: Mon, 17 Dec 2007 21:45:54 +0530
User-Agent: KMail/1.9.7
References: <200711300103.38658.rrs@researchut.com> <200712030601.33212.rrs@researchut.com> <20071203215105.GC8704@elf.ucw.cz>
In-Reply-To: <20071203215105.GC8704@elf.ucw.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1753431.BtX3VVH6oV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712172146.01667.rrs@researchut.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1753431.BtX3VVH6oV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 04 December 2007, Pavel Machek wrote:
> On Mon 2007-12-03 06:01:26, Ritesh Raj Sarraf wrote:
> > On Sunday 02 December 2007, Pavel Machek wrote:
> > > killall -9 pulseaudio. If pulseaudio is not dead within 60 seconds,
> > > you hit a kernel bug. If it needs suspend to be reproduced, you
> > > probably have a suspend bug.
> >
> > Hi Pavel,
> >
> > Something similar to this are multiple cases where the kernel is not ab=
le
> > to kill a process at all.
> >
> > A good example is an application pumping IO to a multipathed device. Wh=
en
> > all the paths to the multipathed devices go down, and you'd like to kill
> > the process, there is no way left to do it. In fact, a reboot also
> > doesn't work in such cases. Reboot gets hung in midway trying to kill t=
he
> > process. The user is left to do a hard reset of the machine.
> >
> > In situations like these, the processes go into D state.
> >
> > Here's what the manpage of ps says:
> >
> > PROCESS STATE CODES
> >        Here are the different values that the s, stat and state output
> > specifiers (header "STAT" or "S")
> >        will display to describe the state of a process.
> >        D    Uninterruptible sleep (usually IO)
> >
> > Does it mean that processes in D state are excluded by the kernel from
> > being killed ? Or is it still a kernel bug ?
>
> Still a kernel bug. Processes should not stay in D state for long.
> 									Pavel

Hi Pavel,

Sometime back we discussed about 'D' state processes which are not killed b=
y=20
the kernel by any signal.

Here's a bugzilla detailing the symptom.
https://bugzilla.redhat.com/show_bug.cgi?id=3D419581
[I/O Processes don't get killed when all the paths to the LUN are down]

It is still being assumed as working as designed.

Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--nextPart1753431.BtX3VVH6oV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHZqDB4Rhi6gTxMLwRAhZHAJ94MLh1evilmGeP18mOcdK6ymCVBwCffh01
YGo75Y4dslu5qO7+1srRSTQ=
=oiwC
-----END PGP SIGNATURE-----

--nextPart1753431.BtX3VVH6oV--
