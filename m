Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbYCDAff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbYCDAff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYCDAfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:35:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43982 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269AbYCDAfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:35:09 -0500
Date: Tue, 4 Mar 2008 11:34:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Tony Luck" <tony.luck@intel.com>
Cc: "Ard -kwaak- van Breemen" <ard@telegraafnet.nl>,
       "Andrew Morton" <akpm@osdl.org>, "Greg KH" <greg@kroah.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chuck Ebbert" <76306.1226@compuserve.com>,
       "Yinghai Lu" <yinghai.lu@amd.com>, take@libero.it, agalanin@mera.ru,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2.6.20-rc2-git1] start_kernel: Test if irq's got enabled
 early, barf, and disable them again
Message-Id: <20080304113458.23298d37.sfr@canb.auug.org.au>
In-Reply-To: <12c511ca0803031446h48c5ab27w51fb87e5b0ae966e@mail.gmail.com>
References: <20061222082248.GY31882@telegraafnet.nl>
	<20061222144134.GH31882@telegraafnet.nl>
	<20061222154234.GI31882@telegraafnet.nl>
	<20061228155148.f5469729.akpm@osdl.org>
	<20061229125108.GK912@telegraafnet.nl>
	<20061229132759.GL912@telegraafnet.nl>
	<20061229141058.GM912@telegraafnet.nl>
	<20061229150132.GN912@telegraafnet.nl>
	<20061229154251.GR912@telegraafnet.nl>
	<20061230194607.GT912@telegraafnet.nl>
	<12c511ca0803031446h48c5ab27w51fb87e5b0ae966e@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Mar_2008_11_34_58_+1100_0p.WXW4MQdTfFXsC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2008_11_34_58_+1100_0p.WXW4MQdTfFXsC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Mon, 3 Mar 2008 14:46:52 -0800 "Tony Luck" <tony.luck@intel.com> wrote:
>
> >  +               printk(KERN_WARNING "start_kernel(): bug: interrupts w=
ere enabled *very* early, fixing it\n");
>=20
> I built and booted the next-20080303 tag from linux-next and
> found the above warning in my console log on ia64 (this is
> new ... I've never seen this message before, even though
> this patch was applied January 2007).
>=20
> Hunting this down, I found the enabler was the lock_kernel() call
> on line 536 of init/main.c ... doesn't than happen to other archs
> too?  We get into the first call to lock_kernel() with current->lock_depth
> set to -1, so we call down(&kernel_sem) ... which does spin_lock_irq()
> and then spin_unlock_irq() ... leaving interrupts enabled.
>=20
> What else changed to make this suddenly kick out now? It
> doesn't happen from a build from Linus' tree.

This is Willy's generic semaphore code that is included in linux-next.
It is being discussed in another thread "linux-next: Tree for Feb 29:
WARNING: at kernel/lockdep.c:2024 trace_hardirqs_on" on the
linux-next@vger.kernel.org mailing list (archived at
http://marc.info/?l=3Dlinux-next&m=3D120440556729954&w=3D2).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Mar_2008_11_34_58_+1100_0p.WXW4MQdTfFXsC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzJk2TgG2atn1QN8RAhvzAJwOh7cYOVjHYUQTwzuupG48F5ySPACfVoU5
l7xaRPNZ2OGyP7rIx2YGbTg=
=5LvE
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2008_11_34_58_+1100_0p.WXW4MQdTfFXsC--
