Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbXJYR3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbXJYR3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJYR3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:29:25 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47110 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbXJYR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:29:24 -0400
Subject: Re: [PATCH 3/3] RT: CPU priority management
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <Pine.LNX.4.58.0710251124370.5639@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
	 <20071025144633.19876.10342.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0710251124370.5639@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DYEhY3MU/7fHnQgwm97z"
Date: Thu, 25 Oct 2007 13:26:38 -0400
Message-Id: <1193333198.4021.24.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DYEhY3MU/7fHnQgwm97z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Oh crap.  I just realized this is an older version of the patch..mustv'e
forgot to refresh...grr.  Ill send out the refreshed one.

But anyway, I digress. =20

On Thu, 2007-10-25 at 11:27 -0400, Steven Rostedt wrote:

>=20
> The cpu_priority and the cp->lock will be aboslutely horrible for
> cacheline bouncing.

In the form presented here in this email, perhaps.  I think you will see
some significant improvements in the refreshed version.  The big change
is that the global lock is gone.

>   Ironically, this will kill performance for the very
> machines this code is to help with.  The larger the number of CPUs you
> have the more cacheline bouncing this code will create.

Don't forget:  The same is precisely true for the current -rt2
algorithm.  For instance, the -rt2 algorithm aside from being linear in
general, scales cacheline bouncing linearly as well.  Each cpu is going
to trash rq->rt.highest_prio and then we will walk them for each scan.

The fact is, you can't maintain a global dynamic policy without bouncing
cachelines, period.  But hopefully we can minimize it, and I just want
to see the fastest code here.

>=20
> I still don't see the benefit from the cpupri code.

I still owe you timing data, but at this juncture I think I can beat
linear (especially as we start throwing in big-iron) ;)  I originally
got involved in this scheduler rework from observations of poor scaling
on our 8/16-ways, so I want it to scale as much as you ;)  If this alg
doesn't pan out, that's cool.  But I think it will in the end.  Linear
algs in the fast path just make my skin crawl.  Perhaps it will still be
the best design in the end, but I am not giving up that easy until I
prove it to myself.

Regards,
-Greg

--=-DYEhY3MU/7fHnQgwm97z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHINHOSW61Ku6jJPkRAsA6AJ4n4fO4o9IE5K8i8UU8J1ENoWUEPgCcDbnl
PzXqHptHf1mXsDJAsARwBg8=
=w/0J
-----END PGP SIGNATURE-----

--=-DYEhY3MU/7fHnQgwm97z--

