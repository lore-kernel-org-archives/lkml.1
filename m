Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbYFTPrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbYFTPrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYFTPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:46:56 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYFTPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:46:55 -0400
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213976619.8967.204.camel@johannes.berg> (sfid-20080620_174407_488559_A2CC96B4)
References: <1213739834.3803.137.camel@johannes.berg>
	 <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
	 <1213774177.3803.164.camel@johannes.berg> <20080620134637.GA8135@elte.hu>
	 <20080620152748.GA21245@elte.hu>  <1213976619.8967.204.camel@johannes.berg>
	 (sfid-20080620_174407_488559_A2CC96B4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-46YljxFwJRfMfekuC836"
Date: Fri, 20 Jun 2008 17:46:12 +0200
Message-Id: <1213976772.8967.206.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-46YljxFwJRfMfekuC836
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-20 at 17:43 +0200, Johannes Berg wrote:
> On Fri, 2008-06-20 at 17:27 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >=20
> > > > Subject: clean up and comment local_bh_enable code
> > > >=20
> > > > There's no need to use local_irq_save() over local_irq_disable() in=
=20
> > > > the local_bh_enable code since it is a bug to call it with irqs=20
> > > > disabled and do_softirq will enable irqs if there is any pending=20
> > > > work. Consolidate the code from local_bh_enable and ..._ip to avoid=
=20
> > > > having a disconnect between them in the warnings they trigger that=20
> > > > is currently there. Also always trigger the warning on in_irq(), no=
t=20
> > > > just in the trace-irqflags case.
> > >=20
> > > applied to tip/core/softirq for testing, thanks Johannes.
> >=20
> > ok, -tip testing found that your patch triggers a new warning on an old=
=20
> > testbox that uses 3c59x vortex and netlogging:
> >=20
> > ----->
> > calling  vortex_init+0x0/0xb0
> > PCI: Found IRQ 10 for device 0000:00:0b.0
> > PCI: Sharing IRQ 10 with 0000:00:0a.0
> > PCI: Sharing IRQ 10 with 0000:00:0b.1
> > 3c59x: Donald Becker and others.
> > 0000:00:0b.0: 3Com PCI 3c556 Laptop Tornado at e0800400.
> > PCI: Enabling bus mastering for device 0000:00:0b.0
> > initcall vortex_init+0x0/0xb0 returned 0 after 47 msecs
> > ...
> > calling  init_netconsole+0x0/0x1b0
> > netconsole: local port 4444
> > netconsole: local IP 10.0.1.9
> > netconsole: interface eth0
> > netconsole: remote port 4444
> > netconsole: remote IP 10.0.1.16
> > netconsole: remote ethernet address 00:19:xx:xx:xx:xx
> > netconsole: device eth0 not up yet, forcing it
> > eth0:  setting half-duplex.
> > eth0:  setting full-duplex.
> > ------------[ cut here ]------------
> > WARNING: at kernel/softirq.c:137 local_bh_enable_ip+0xd1/0xe0()
> > Pid: 1, comm: swapper Not tainted 2.6.26-rc6-tip #2091
> >  [<c0125ecf>] warn_on_slowpath+0x4f/0x70
> >  [<c0126834>] ? release_console_sem+0x1b4/0x1d0
> >  [<c0126d00>] ? vprintk+0x2a0/0x450
>=20
> Now you can't printk in irq context any more?

Or I'm just confused by x86 stack dumps.

johannes

--=-46YljxFwJRfMfekuC836
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW9DBAAoJEKVg1VMiehFYq4IP/15+UtzVn2coBJH9Kv/jlWEe
oUf0lVNJXoMYF4C685Pn7FWPgAgPvvQZq3/SzpO/lN/OAiNfcXSXUYSI+407m69E
9drvPJeFw4LEt81cI10lqmJRNR7X4CG7J2XymGJd2KFhhibR5WWzfKabcq4xNi6G
jVEOmO5oN5Ev6HUohWaS2dX5vKACPGfdjb/+ROqIzP9TdtbJtIMOR5oUvBj8ku5N
5R1VyFQNuP7SeTBmnt+XVlD+xYsAiBlTERxyz8DwWFzdI+1Zadpvw5d8ELYMTsjN
iDmhjeF0DObBjyAMww7SQBOP/EVd6a89vljAGMDyax+v9FCpcpYmDKpqeUETNCaE
7X9Vw0f2632FHTFTmYnUE4VJ6ZXKNQXEJKF/Dn1042mG1F5K6TgKUqQYeVTipsoz
ibLa3g5/R5vPDP4jYKxobJyVaCy+yR7GbX0I3oKC/BL7X5pRhJ95KoeOgyUXVQjS
qcVjPqCJWQzAC6j1RuVmmN+SYLgQzHY/hdKke880rKOBnQf4TdAmZ4ekW2vWg2MI
v47hO52xcflBqrgAXqzjhNAPOVn1RC/6PArPKFXIYVXdS4wIFCH5RvqVZ7pYu+Cr
OjKUMmejPGn3HOLq4mNrDl2/XhRvtxBL7n7/aMPQcP89epuLHdEfmE92iPAHaH/T
/6nEPobpozrn2fSGnmL5
=2JQB
-----END PGP SIGNATURE-----

--=-46YljxFwJRfMfekuC836--

