Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbXD1GK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbXD1GK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXD1GK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:10:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:45109 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbXD1GKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=e7TjiClujIsI7krlT6VAedpsTwiKdGrlKdNL2reVRkfIPwwtpgF58I+j8Yq0YQIJfiLM63KfR7h0DKYS1Hh5gRgWga5zjuLob3wt0F8HemI2v4/M5YYiLA29/3dsI64/i4GMyFIDPIGUm9zdv1qE5zcI5bBsl/VN2oRYMph2kQQ=
Date: Fri, 27 Apr 2007 23:09:50 -0700
From: Mike Mattie <codermattie@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: htpt366 PCI latency value is really high
Message-ID: <20070427230950.33d4d040@reforged>
In-Reply-To: <4630B789.3040402@ru.mvista.com>
References: <20070426064927.13d0ed72@reforged>
	<4630B789.3040402@ru.mvista.com>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_v_WEieGHBbHJStsP_ftKiz3;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_v_WEieGHBbHJStsP_ftKiz3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Apr 2007 18:30:33 +0400
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
>=20
> Mike Mattie wrote:
>=20
> > while hunting down some latency problems I found something quite
> > odd. The latency reported by lspci -v for the HTP203N card is
> > enormous.
>=20
> > 00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
> > (rev 02) Subsystem: Triones Technologies, Inc. Unknown device 0001
> >         Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 17
> >         I/O ports at ec00 [size=3D8]
> >         I/O ports at e800 [size=3D4]
> >         I/O ports at e400 [size=3D8]
> >         I/O ports at e000 [size=3D4]
> >         I/O ports at dc00 [size=3D256]
> >         Expansion ROM at dffe0000 [disabled by cmd] [size=3D128K]
> >         Capabilities: [60] Power Management version 2
>=20
> > I am assuming that the "latency" field here is the PCI latency timer
> > which means this card is a bus hog.=20
>=20
> > From some reading on this issue linux methodically sets a sane
> > value for all the PCI cards it sets up, which looks normal on the
> > rest of the system, which is set to the value: 32
>=20
>    Hm, I'm only seeing clamping to the smallest of 64 and
> pcibios_max_latency (255) in arch/i386/pci/i386.c if the latency
> value is too low... Which arch are you using?
>=20
> > setting the value 32 with:
>=20
> > setpci -v -s "00:09.0" latency_timer=3D32
>=20
> > 00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
> > (rev 02) Subsystem: Triones Technologies, Inc. Unknown device 0001
> >         Flags: bus master, 66MHz, medium devsel, latency 48, IRQ 17
> >         I/O ports at ec00 [size=3D8]
> >         I/O ports at e800 [size=3D4]
> >         I/O ports at e400 [size=3D8]
> >         I/O ports at e000 [size=3D4]
> >         I/O ports at dc00 [size=3D256]
> >         Expansion ROM at dffe0000 [disabled by cmd] [size=3D128K]
> >         Capabilities: [60] Power Management version 2
>=20
> > Results in 48, which is not what I asked, but hopefully this is
> > linux doing the right thing.

output is decimal, input is hex - self-rtfm.
=20
>    Not sure -- seems likely that it's the chip's own enforced minimum
> instead...
>=20
> > I know this chipset is pretty brain-damaged, but is this
> > high latency value a work-around for broken hardware, or
>=20
>    More like it.  Although HighPoint's own drivers force 64.
>=20
> > just a oversight ?
>=20
>    Not likely since the value is too "special"...

I have ran with a setting of 40 for a couple of days without any trouble.
There are many reasons a card would default to a higher level, but in
the end it is basically tuning the card for a server application.

A warning that some cards default to high PCI latency values; settings that=
=20
can interfere with latency sensitive devices such as sounds cards - this=20
could be a help to others. =20

00:09.0 RAID bus controller: Triones Technologies, Inc. HPT302/302N
(rev 02) Subsystem: Triones Technologies, Inc. Unknown device 0001
        Flags: bus master, 66MHz, medium devsel, latency 40, IRQ 19
        I/O ports at ec00 [size=3D8]
        I/O ports at e800 [size=3D4]
        I/O ports at e400 [size=3D8]
        I/O ports at e000 [size=3D4]
        I/O ports at dc00 [size=3D256]
        Expansion ROM at dffe0000 [disabled by cmd] [size=3D128K]
        Capabilities: [60] Power Management version 2


> > Cheers,
> > Mike Mattie - codermattie@gmail.com
>=20
> WBR, Sergei

--Sig_v_WEieGHBbHJStsP_ftKiz3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGMuU0dfRchrkBInkRAnTvAKCaBWAWAdih72K8mBb8biPgOlvjhgCdF3C3
TYOv5eNrXVIqIew2VkLMT4w=
=PoR3
-----END PGP SIGNATURE-----

--Sig_v_WEieGHBbHJStsP_ftKiz3--
