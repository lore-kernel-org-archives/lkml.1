Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXJVMPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXJVMPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXJVMPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:15:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:42945 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbXJVMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:15:07 -0400
Subject: Re: [RFC/PATCH 2/3] rt: PI-workqueue support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <Pine.LNX.4.58.0710220754440.10836@gandalf.stny.rr.com>
References: <20071022095054.393085000@chello.nl>
	 <20071022095658.745030000@chello.nl>
	 <Pine.LNX.4.58.0710220754440.10836@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mu/c0Yyp7T96aBjSkKn/"
Date: Mon, 22 Oct 2007 14:15:03 +0200
Message-Id: <1193055303.27435.176.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mu/c0Yyp7T96aBjSkKn/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-22 at 08:00 -0400, Steven Rostedt wrote:
> --
>=20
> On Mon, 22 Oct 2007, Peter Zijlstra wrote:
> 5B>
> > Index: linux-2.6/kernel/workqueue.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/kernel/workqueue.c
> > +++ linux-2.6/kernel/workqueue.c
> > @@ -44,7 +44,7 @@ struct cpu_workqueue_struct {
> >
> >  	spinlock_t lock;
> >
> > -	struct list_head worklist;
> > +	struct plist_head worklist;
> >  	wait_queue_head_t more_work;
> >  	struct work_struct *current_work;
> >
> > @@ -127,16 +127,19 @@ struct cpu_workqueue_struct *get_wq_data
> >  static void insert_work(struct cpu_workqueue_struct *cwq,
> >  				struct work_struct *work, int tail)
> >  {
> > +	int prio =3D current->normal_prio;
> > +
>=20
> I'm curious to why you use normal_prio here? If the task has been boosted
> by some other PI method, and this task is about to sleep, why not use the
> actualy current->prio?

Daniel wrote this bit, but I tend to agree with him, but can't give his
rationale. Mine is that worklets are typically asynchonous and thus its
prio should not depend on temporal things like boosting.

OTOH it would probably make sense to allow it to depend on it through
the barrier constructs, but for that I have to hook the completions into
the PI chain. Something that needs more thought.


--=-mu/c0Yyp7T96aBjSkKn/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHHJRHXA2jU0ANEf4RAvXGAJ0UoJHiV4V3LSvN/tuDFvyqg/IAJwCfdtkT
1MbLJ+7XUjFlDr0rUgDKjwc=
=2pGG
-----END PGP SIGNATURE-----

--=-mu/c0Yyp7T96aBjSkKn/--

