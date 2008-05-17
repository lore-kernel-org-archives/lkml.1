Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYEQDXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYEQDXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 23:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYEQDXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 23:23:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37181 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYEQDXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 23:23:33 -0400
Date: Sat, 17 May 2008 13:23:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Adrian Bunk <bunk@kernel.org>,
       kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: spontaneous reboots and hangs on x86_64
Message-Id: <20080517132317.3265d52c.sfr@canb.auug.org.au>
In-Reply-To: <200805162053.36390.m.kozlowski@tuxland.pl>
References: <200805152201.49154.m.kozlowski@tuxland.pl>
	<200805160737.50373.m.kozlowski@tuxland.pl>
	<20080516174452.6fff3a3e.sfr@canb.auug.org.au>
	<200805162053.36390.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__17_May_2008_13_23_17_+1000_BJ_XqBx4TtI6ah_7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_May_2008_13_23_17_+1000_BJ_XqBx4TtI6ah_7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Fri, 16 May 2008 20:53:36 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.p=
l> wrote:
>
> Ok I got bisection working finally, now I'm at d5be23e2 I have something =
like 80 revisions left and
> I'm stuck with this:
>=20
> In file included from kernel/sched.c:1861:
> kernel/sched_rt.c: In function 'check_preempt_curr_rt':
> kernel/sched_rt.c:653: error: implicit declaration of function 'cpupri_fi=
nd'
> kernel/sched_rt.c:653: error: 'struct root_domain' has no member named 'c=
pupri'
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2

This error is caused by commit 677ceea32cf1d8ba9a4870bc58079cd7e7f77558
("sched: prioritize non-migratable tasks over migratable ones") in the
sched tree (sched/for-akpm).  This commit is either just wrong, is was
misrebased, or is just badly out of order.  It introduces a use of
cpupri_find, but the function is not defined until commit
ea9b3c95b7c666d4658a139b88587269e5baa647 ("sched: use a 2-d bitmap for
searching lowest-pri CPU") about 146 commits later ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_May_2008_13_23_17_+1000_BJ_XqBx4TtI6ah_7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFILk+rTgG2atn1QN8RAowNAJwOS0f381qcb7van0m8TWEMkLYXIQCdHzsC
U0mvt0AtTUcWhAAW4+Zg/P0=
=L2X1
-----END PGP SIGNATURE-----

--Signature=_Sat__17_May_2008_13_23_17_+1000_BJ_XqBx4TtI6ah_7--
