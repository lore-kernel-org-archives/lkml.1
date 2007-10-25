Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbXJYR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbXJYR6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXJYR5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:57:49 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47813 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXJYR5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:57:48 -0400
Subject: Re: [PATCH 3/3] RT: CPU priority management
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <Pine.LNX.4.58.0710251332470.8874@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
	 <20071025144633.19876.10342.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0710251124370.5639@gandalf.stny.rr.com>
	 <1193333198.4021.24.camel@ghaskins-t60p.haskins.net>
	 <Pine.LNX.4.58.0710251332470.8874@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0F4gmyepkSfgYi22FreG"
Date: Thu, 25 Oct 2007 13:55:05 -0400
Message-Id: <1193334905.4021.35.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0F4gmyepkSfgYi22FreG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 13:36 -0400, Steven Rostedt wrote:


>=20
> Yep, -rt2 (and -rt3) are both horrible too. That's why I'm working on a
> sched-domain version now to handle that.

Excellent.  I'm not 100% sure I've got the "mingo lingo" ;) down enough
to know if sched_domains are the best fit, but I think in concept that
makes a lot of sense (as we have discussed on IRC).   I am thinking that
we want to treat the rt.highest_prio/cpupri stuff to the "cpuset"
mentality, just like Ingo suggested for the rto masks.  If sched_domains
are those beasts, then great.

>=20
> >
> > The fact is, you can't maintain a global dynamic policy without bouncin=
g
> > cachelines, period.  But hopefully we can minimize it, and I just want
> > to see the fastest code here.
>=20
> Well, we need a balance between cacheline hits, and where to pull from.
> As performance goes, the two are inverse perportional. The secret is to
> find a nice middle ground.

Fully agree.

>=20
> >
> > >
> > > I still don't see the benefit from the cpupri code.
> >
> > I still owe you timing data, but at this juncture I think I can beat
> > linear (especially as we start throwing in big-iron) ;)  I originally
> > got involved in this scheduler rework from observations of poor scaling
> > on our 8/16-ways, so I want it to scale as much as you ;)  If this alg
> > doesn't pan out, that's cool.  But I think it will in the end.  Linear
> > algs in the fast path just make my skin crawl.  Perhaps it will still b=
e
> > the best design in the end, but I am not giving up that easy until I
> > prove it to myself.
>=20
> It's only linear in respect to the size of the domain or cpus allowed.

True, but as of now its a singular domain ;)  And even so, I still think
a cpupri like algorithm can be potentially useful even if we utilize
finer grained domains.  That is, unless the membership becomes
sufficiently small (maybe < 4 CPUs?) where the lower-overhead linear
search will just always trounce the larger overhead of cpupri_set().

>  Any
> 8/16 way boxes worried about cacheline bouncing need to reign in on the
> cpus allowed mask. Otherwise, we would simply have bouncing anyway with
> the tasks themselves.

Agreed.   Looking forward to reviewing your work here. :)

Regards,
-Greg

--=-0F4gmyepkSfgYi22FreG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHINh5SW61Ku6jJPkRAq+hAJ4+cXNr9TIl/pfsAYcjnhUsigqcFQCeMwdd
/UJ+d7PR8zh0C7JgLDfSL8I=
=S3jC
-----END PGP SIGNATURE-----

--=-0F4gmyepkSfgYi22FreG--

