Return-Path: <linux-kernel-owner+w=401wt.eu-S933251AbXDZHCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbXDZHCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXDZHCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:02:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:47146 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbXDZHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:02:05 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.0.98.0704251933300.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz>
	 <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	 <20070425202741.GC17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	 <20070425214420.GG17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	 <1177540027.5025.87.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
	 <1177551601.5025.131.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
	 <1177553635.5025.159.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251933300.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w1PGOo6OiLeC9CaRXFPJ"
Date: Thu, 26 Apr 2007 13:34:27 +1000
Message-Id: <1177558467.5025.181.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w1PGOo6OiLeC9CaRXFPJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 20:03 -0700, Linus Torvalds wrote:
>=20
> On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> >=20
> > Sorry. I wasn't clear. I wasn't saying that suspend to ram has a
> > snapshot point. I was trying to say it has a point where you're seeking
> > to save information (PCI state / SCSI transaction number or whatever)
> > that you'll need to get the hardware into the same state at a later
> > stage. That (saving information) is the point of similarity.
>=20
> Yes, they do both save information, but I'm not actually convinced they=20
> would necessarily even save the *same* information.
>=20
> Let's just take an example of USB, and to make things more interesting,=20
> say that the disk you want to suspend to is itself over USB (not=20
> necessarily something you _want_ to do, but I think we can all agree that=
=20
> it's something that should potentially work, no?)

Agreed - it would be nice.

> Now, USB devices actually have per-connection state (at a minimum, the=20
> "toggle" bit or whatever), and that's obviously something that will=20
> inevitably *change* as a result of the device being used after=20
> snapshotting (and even if not used, by the rediscovery by the first kerne=
l=20
> to boot), and we fundamentally cannot put the final toggle state in the=20
> snapshot.
>=20
> So in the snapshot-to-disk scenario, there are some pieces of data that=20
> simply fundamentally *cannot* be snapshotted, because they are not=20
> controller state, they are "connection" state.
>=20
> So in that case, you basically know that you *have* to rebuild the=20
> connection when you do the "snapshot_resume()" thing. So there's no point=
=20
> in even keeping these kinds of connection states (the same is true of=20
> keyboards, mice, anything else - it's how USB works).

Sort of agree - you might want to record some serial number that might
let you recognise it as the same thing at resume time when everything is
re-hotplugged (assuming it's even there then). Nevertheless, I don't
think that diminishes what you're saying.

> In contrast, in suspend-to-RAM, USB connections might just be things you=20
> actually want to keep open and active, and you *can* do so, in ways you=20
> simply cannot do with "snapshot to disk". In fact, if you are something=20
> like an OLPC and actually go to s2ram very aggressively, you might well=20
> want to keep the connection established, because it's conceivable that yo=
u=20
> might otherwise lose keypresses etc issues)
>=20
> See? There are real *technical* reasons to believe that the two "save=20
> state" operations are really fundamentally different. There are reasons t=
o=20
> believe that a s2ram can actually happen while keeping some connections=20
> open that cannot be kept open over a disk snapshot.
>=20
> Do they *have* to be different? Of course not. For many devices the "save=
"=20
> and "freeze" operations will likely all be no-ops, and there would be=20
> absolutely no difference between suspending and snapshotting, because the=
=20
> driver state already natively contains all the information needed to get=20
> the device going again.
>=20
> Equally, I don't doubt that in many drivers you'll have very similar "sav=
e=20
> state" logic, but in fact I believe that in many cases that "save state"=20
> logic will often just be a simple
>=20
> 	pci_save_state(dev);
>=20
> call, so it's literally the case that they will not be just shared betwee=
n=20
> the "suspend" and "snapshot" case, they'll be shared across all simple PC=
I=20
> devices too!
>=20
> But that doesn't mean that the functions to do so should be the same. You=
=20
> might have
>=20
> 	static int mypcidevice_suspend(struct pci_dev *dev)
> 	{
> 		pci_save_state(dev);
> 		pci_set_power_state(dev, PCI_D3);
> 		return 0;
> 	}
>=20
> 	static int mupcidevice_snapshot(struct pci_dev *dev)
> 	{
> 		pci_save_state(dev);
> 		return 0;
> 	}
>=20
> and who cares if they both have that same call to a shared "save state"=20
> function? They're still totally different operations, and the fact that=20
> *some* devices may save the same things doesn't make them any more=20
> similar! See above why some devices might save totally *different* things=
=20
> for a "snapshot" vs a "suspend" event.

No disagreement here.

> > I suppose that's another point of similarity - for snapshotting, the
> > same ordering is probably needed?
>=20
> I agree that you're likely to walk the device list in the same order. The=
=20
> whole "shut down leaf devices first", "start up root devices first" is=20
> pretty fundamental.
>=20
> But that's true of reboot and device discovery too. Should that ordering=20
> mean that we should use the "discovery()" function and pass it a flag and=
=20
> say "you shouldn't discover, you should snapshot or suspend now"? No.=20
> Everybody agrees that device discovery is something different from device=
=20
> suspend. The fact that it's done in a topological order and thus they bea=
r=20
> some kind of inverse relationship to each other doesn't make them "the=20
> same".
>=20
> > > And yes, the _individual_ "save-and-suspend" events obviously needs t=
o be=20
> > > "atomic", but it's purely about that particular individual device, so=
=20
> > > there's never any cross-device issues about that.
> >=20
> > No interdependencies? I'm not sure.
>=20
> Well, we pretty much count on it, since we will *suspend* the devices at=20
> the same time. So if they had interdependencies that aren't described by=20
> the ordering we enforce, they are pretty much screwed anyway ;)
>=20
> So yes, the device list needs to be topologically sorted (and you need to=
=20
> walk it in the right direction), but apart from that we'd *better* not=20
> have any interdependencies, or we simply cannot suspend at all.

Thanks for your reply.

Nigel

--=-w1PGOo6OiLeC9CaRXFPJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMB3DN0y+n1M3mo0RAuD3AJ9/E1lwJC+7aspE9DHQk36BHaO5GwCfejFM
stNm+q/ObF7wVjYT6EF6X9w=
=rAuM
-----END PGP SIGNATURE-----

--=-w1PGOo6OiLeC9CaRXFPJ--

