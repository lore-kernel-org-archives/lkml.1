Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbXGKDhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbXGKDhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 23:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXGKDhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 23:37:42 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:56272 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbXGKDhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 23:37:41 -0400
From: timotheus <timotheus@tstotts.net>
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.ck,gmane.linux.kernel.mm
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Hawkins" <darthmdh@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	<20070710181419.6d1b2f7e.akpm@linux-foundation.org>
	<20070710202123.d819835e.kernel@irasnyder.com>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.51 (gnu/linux)
Followup-To: gmane.linux.kernel.ck
Date: Tue, 10 Jul 2007 23:37:23 -0400
Message-ID: <m2ejjf1uh8.fsf@tstotts.net>
Cancel-Lock: sha1:0Wb+ztnwDhe+DwJJSNpXvGip1hg=
In-Reply-To: <20070710202123.d819835e.kernel@irasnyder.com> (Ira Snyder's
	message of "Tue, 10 Jul 2007 20:21:23 -0600")
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ira Snyder <kernel@irasnyder.com> writes:

>> Always interested.  Please provide us more details on your usage and
>> testing of that code.  Amount of memory, workload, observed results,
>> etc?
>>=20
>
> I often leave long compiles running overnight (I'm a gentoo user). I
> always have the desktop running, with quite a few applications open,
> usually firefox, amarok, sylpheed, and liferea at the minimum. I've
> recently tried using a "stock" gentoo kernel, without the swap
> prefetch patch, and in the morning when I get on the computer, it hits
> the disk pretty hard pulling my applications (especially firefox) in
> from swap. With swap prefetch, the system responds like I expect:
> quick. It doesn't hit the swap at all, at least that I can tell.
>
> Swap prefetch definitely makes a difference for me: it makes my
> experience MUCH better.
>
> My system is a Core Duo 1.83GHz laptop, with 1GB ram and a 5400 rpm
> disk. With the disk being so slow, the less I hit swap, the better.
>
> I'll cast my vote to merge swap prefetch.

Very similar experiences. Other usage patterns that swap prefetch can
cause improvements with:

=2D Idling VMware session with large memory. Since VMware (server) can use
  mixed swap/RAM, the prefetch allows it swap back into RAM without
  having to make the application active in the foreground.

=2D Firefox, OO Office, long from-source compilations, all of the normal.

=2D My largest RAM capacity machine is a Core 2 Duo Laptop with 2 GB of
  RAM. It still benefits from the prefetch after running long
  compilations or backups.

=2D Also, I have an old Pentium 4 server (1.3 GHz, original RDRAM, ...)
  that uses the CK patches including swap prefetch. It has only 640 MB
  of RAM, and runs GBytes of data backup every night. The swap is split
  among multiple disks, and can easily fill .5 GBytes over
  night. Applications that run in a VNC session, web browsers, office
  programs, etc., all resume much faster with the prefetch. Even the
  intial ssh-login appears snappier; but I think that is just CK's fine
  work elsewhere. :)

I am curious how much of the benefit is due to prefetch, or due to CK
using `vm_mapped' rather than `vm_swappiness'. Swappiness always seemed
such an unbenificial hack to me...

(The past 6 months I've tried weeks/months of using various kernels,
=2Dmm, -ck, vanilla, genpatches, combinations there of -- x86 and ppc.)

I vote for prefetch and `vm_mapped'.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQFGlFB+GWMp0IAo0gsRAj19AJ9wM/E/NNDIcPofWskFn0116RUtuQCdFFjp
y53yIIPgAANYvudOE7rPCLI=
=y+hG
-----END PGP SIGNATURE-----
--=-=-=--
