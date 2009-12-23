Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZLWIHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZLWIHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZLWIHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:07:38 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:42734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZLWIHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:07:38 -0500
Subject: Re: workqueue thing
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com
In-Reply-To: <alpine.LFD.2.00.0912221004540.6879@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>
	 <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>
	 <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
	 <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	 <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>
	 <1261480220.4937.24.camel@laptop>
	 <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain>
	 <1261504042.4937.59.camel@laptop>
	 <alpine.LFD.2.00.0912221004540.6879@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4/hCs2waQb+2fu3bNvpG"
Date: Wed, 23 Dec 2009 09:06:25 +0100
Message-ID: <1261555586.15510.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4/hCs2waQb+2fu3bNvpG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-22 at 10:28 -0800, Linus Torvalds wrote:
>=20
> On Tue, 22 Dec 2009, Peter Zijlstra wrote:
> >=20
> > Which in turn would imply we cannot carry fwd the current lockdep
> > annotations, right?
> >=20
> > Which means we'll be stuck in a situation where A flushes B and B
> > flushes A will go undetected until we actually hit it.
>=20
> No, lockdep should still work. It just means that waiting for an=20
> individual work should be seen as a matter of only waiting for the
> locks that work itself has done - rather than waiting for all the locks
> that any worker has taken.
>=20
> And the way the workqueue lockdep stuff is done, I'd assume this just=20
> automatically fixes itself when rewritten.

Yeah, you'd just have to remove the per-workqueue lockmap since that's
no longer applicable if there is, in effect, one workqueue per work item
available. We do track each work struct already.

However, I'm not sure what you (Peter) mean by "A flushes B" since flush
is a workqueue operation which appears to no longer exist after this
patchset. If struct work A tries to remove struct work B and vice versa,
it'd still be detected though, assuming the annotations are taken
forward properly of course.

johannes

--=-4/hCs2waQb+2fu3bNvpG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLMc98AAoJEODzc/N7+QmaT0IQAJL1FBGTEnG/qmmM5vYIQa4r
9CxMbQMsBIkwKTKX+kBkxwVaYSVQPXzwy8lClKydZqzDMdl17Y7eIj76N7nJEedA
wlQGFMhTsqoug5sI28ZgLNDjTrlF4I9SWSe1ZNP/focDOF0tFyrznMnhxIkZ8Eo8
1Anw3h/jyFSn3nflS4+HR5dGFwt/FzXzJm2UFeBFMBO+n2COqWQ76aatJc40XN3e
e/pPLE9b+TvdkUYwnwBYaY2wuah/S+OdEg/hH7zbxwHqQYj5Y2q4mXo72gEU5tXW
Hlp81p+Vaeft1orySZYrS15VzZz3aIFP80eu/i61ett32LTFuwFFpUQyieDPaiIn
TerCNNousCx+InTj6vNXvP/ODmx7M6hJi2v58sMu/Fd7AjAiJt/EdxzWwHgnl7/n
2D0goZomMBv7+fa1hp+rvSiOIJzX8IC+dfbfKctG8gvRScxtTG79NL3UC7Znn2f8
OpaxRKz1hy1fA0QfKDOp/EhtGdaYToCIQaoafh6yN0R5bleCM+gT2rdtnh4gyz1C
yzaK6c0P0dmpMxHVB1YfOWh8trducQekLLpdglOpkLEbwevLi/KDZF5MmaMlCyzB
8N84Uh0BSuL6Qj93LzvAGB8utzVXejBk58Q58wgwvnZrJtBjwIHZN1v8xD9AkbdL
W7WEAIFt01awvyjst8gS
=CLOz
-----END PGP SIGNATURE-----

--=-4/hCs2waQb+2fu3bNvpG--

