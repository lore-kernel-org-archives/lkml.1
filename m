Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYHEEee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYHEEee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYHEEe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:34:26 -0400
Received: from ozlabs.org ([203.10.76.45]:44042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYHEEeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:34:25 -0400
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,
	post-2.6.27-rc1
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Paul Collins <paul@burly.ondioline.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8763qg5don.fsf@burly.wgtn.ondioline.org>
References: <20080802184554.GB715@fieldses.org>
	 <87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	 <877iayy4qc.fsf@burly.wgtn.ondioline.org>
	 <18581.40960.737792.454035@notabene.brown>
	 <87r696l1yo.fsf@burly.wgtn.ondioline.org>
	 <18582.32935.501672.689845@notabene.brown>
	 <87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	 <87y73dcd60.fsf@burly.wgtn.ondioline.org>
	 <1217860597.12535.2.camel@localhost>
	 <87hca05ws4.fsf@burly.wgtn.ondioline.org>
	 <20080804205908.GA29890@fieldses.org> <1217895418.7951.7.camel@localhost>
	 <8763qg5don.fsf@burly.wgtn.ondioline.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HuoXUTJGldHexIr3LpT3"
Date: Tue, 05 Aug 2008 04:34:22 +0000
Message-Id: <1217910862.7951.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HuoXUTJGldHexIr3LpT3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 15:43 +1200, Paul Collins wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > On Mon, 2008-08-04 at 16:59 -0400, J. Bruce Fields wrote:
> >> On Tue, Aug 05, 2008 at 08:51:23AM +1200, Paul Collins wrote:
> >> > Michael Ellerman <michael@ellerman.id.au> writes:
> >> >=20
> >> > > On Mon, 2008-08-04 at 22:00 +1200, Paul Collins wrote:
> >> > >> Paul Collins <paul@burly.ondioline.org> writes:
> >> > >>=20
> >> > >> > Neil Brown <neilb@suse.de> writes:
> >> > >> >> Could you try removing the 'static' declaration for nfsd_accep=
table
> >> > >> >> and recompile?
> >> > >> >> Or maybe try a different compiler?
> >> > >> >
> >> > >> > I will give these a try this evening.
> >> > >>=20
> >> > >> I built myself a nice new cross compiler:
> >> > >>=20
> >> > >>         powerpc-linux-gnu-gcc-4.1 (GCC) 4.1.3 20080623 (prereleas=
e) (Debian 4.1.2-23)
> >> > >>=20
> >> > >> and rebuilt 94ad374a0751f40d25e22e036c37f7263569d24c.  Running th=
at on
> >> > >> the server and 2.6.26 on the client, I got yet another Oops.  Thi=
s one
> >> > >> locked the machine up pretty good, so all I have is a picture:
> >> > >>=20
> >> > >> http://ondioline.org/~paul/DSCN1608.JPG
> >> > >
> >> > > Wow.
> >> > >
> >> > > Can you try building a kernel on the server? ie. not over NFS.
> >> >=20
> >> > Built kernels on the server with native gcc 4.2.4 and 4.3.1 and repe=
ated
> >> > the build test.
> >> =20
> >> But the build test itself was over nfs?  (And you can't reproduce the
> >> same problem without nfs?)
> >
> > Yeah, I'm not clear on that either. What I was aiming at was can you ge=
t
> > it to oops somewhere else by not building over NFS - in which case we
> > can rule NFS (more or less) out.
>=20
> I think may be able to rule NFS out now.  I just got this Oops when Xorg
> started on boot.

Cool, that looks fairly convincing.

> In case anyone wants to disassemble it, I've uploaded the kernel to
> http://ondioline.org/~paul/vmlinux-2.6.27-rc1-00158-g643fbd8 and the
> config to http://ondioline.org/~paul/config-2.6.27-rc1-00158-g643fbd8
>=20
> I've rebuilt a whole bunch of times in the course of this little
> project, but the all four Oopses in this message are from the very
> vmlinux linked above.
>=20
> I have a couple of patches applied locally (a console font and a
> Bluetooth HID quirk), so this is really Linus revision
> 94ad374a0751f40d25e22e036c37f7263569d24c.

And you're _sure_ none of them has a "break-everything" hunk in it? :)


I see you have FTRACE enabled. That's new and could potentially bugger
things up without the compiler knowing, so can you turn that off.

And can you enable CONFIG_CODE_PATCHING_SELFTEST and
CONFIG_FTR_FIXUP_SELFTEST, that will enable tests of some code I changed
that /could/ (maybe) cause random blow ups.

Also, how old is the machine? Any chance you're just seeing random
memory corruption?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-HuoXUTJGldHexIr3LpT3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIl9hOdSjSd0sB4dIRAhMaAKCWtT08+KJPnqvECqndEc2RyPl4SACeM+E0
5C1btBZtusKye84h0OVH7tY=
=tfPj
-----END PGP SIGNATURE-----

--=-HuoXUTJGldHexIr3LpT3--

