Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZBTFDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZBTFDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 00:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZBTFC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 00:02:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:44138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZBTFC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 00:02:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,238,1233561600"; 
   d="asc'?scan'208";a="667080629"
Subject: Re: [git pull] changes for tip, and a nasty x86 page table bug
From: Huang Ying <ying.huang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.00.0902192007400.21686@localhost.localdomain>
References: <20090220011316.379904625@goodmis.org>
	 <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain>
	 <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain>
	 <alpine.DEB.2.00.0902192254040.29217@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0902192007400.21686@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O1DiMTcFbuaPg/VDMg4Z"
Date: Fri, 20 Feb 2009 13:02:52 +0800
Message-Id: <1235106172.6171.63.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O1DiMTcFbuaPg/VDMg4Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Linus,

On Fri, 2009-02-20 at 12:17 +0800, Linus Torvalds wrote:
>=20
> On Thu, 19 Feb 2009, Steven Rostedt wrote:
> >=20
> > Is this something worthy of 29? I could whip up a patch against your=20
> > latest tree.
>=20
> I think it's a real issue, but I do have to admit that I don't see why it=
=20
> would only trigegr for you. Is it just because the trace stuff ends up=20
> setting pages to RW, and you have to have had a lot of read-only stuff to=
=20
> get a whole read-only PMD to begin with?
>=20
> So there's two things that make me nervous:
>=20
>  - I do think the KERNPG_TABLE thing is the right thing, and I _think_=20
>    that code is just confused, and we should just do KERNPG_TABLE rather=20
>    than play with confused bits one by one (PRESENT, RW, NX) to the point=
=20
>    of just making for more confusion.
>=20
>    But I'd like some of the people involved with that code confirm that.=20
>    Either a "Yeah, we were just confused" or "No, there's this really=20
>    subtle thing going on, liek this: ..."
>=20
>  - The fact that apparently you're the first one to hit this. I realize=20
>    that you do odd things with ftrace. Was it the fact that you made the=20
>    "set_memory_ro()" area larger, and then more dynamically mark it back=20
>    to read-write that you hit it? Haven't we done things like that before=
?

In fact, I am the first one to hit a similar bug. I do some odd thing
with EFI to change the page tables to be executable. Unfortunately I
fixed that bug in a confused way.

Yes. I think KERNPG_TABLE fixes all these types of bugs in a more clear
way.

Best Regards,
Huang Ying


--=-O1DiMTcFbuaPg/VDMg4Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmeOXcACgkQKhFGF+eHlpj41ACeIUug86xiKghBTBAtVhbX3vtt
F/UAnAtc3eRqROL2PNa5Re8wEWVGerJZ
=F5sJ
-----END PGP SIGNATURE-----

--=-O1DiMTcFbuaPg/VDMg4Z--

