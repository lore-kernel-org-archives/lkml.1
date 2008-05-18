Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYERWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYERWYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYERWX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:23:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:27261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYERWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=dnFruNz3GjeG81yjUrWoU9XT4bSokdnzdB1ETXY6T/ss2Wlwa8atK8O45sWpHwOYLb5XLOkFMhvOBvaC9NHOpqigedaXxCxOe5YVKtKuNnbPDq9C0M65ixbIpss5rR5/D/DrLw/StmQKyBo6w2GQ8yOquxTKhJJq79l2z6t2/q4=
Date: Sun, 18 May 2008 23:23:47 +0100
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr
 after e820_reserve_resources
Message-ID: <20080518232347.7964835c@snowcone>
In-Reply-To: <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
References: <20080518014111.4f32298b@googlemail.com>
 <86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
 <20080518164127.2236d82a@googlemail.com>
 <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hadD.1l3yhcQq/ciuc2iYKP";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hadD.1l3yhcQq/ciuc2iYKP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 18 May 2008 14:00:16 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >> wonder if init_apic_mapping need some delay with that strange
> >> chipset.
> >
> > I don't see any additional information with apic=3Dverbose with the
> > broken kernel (although I only have a screen's worth of text that I
> > can see -- the kernel doesn't get far enough to let me grab it).
> > I've attached dmesg from a working kernel with apic=3Dverbose in case
> > that helps.
>=20
> or try to boot with initcall_debug to see where did it hang.

The last initcall_debug messages are:

    calling atiixp_ide_init+0x0/0x20
    initcall atiixp_ide_init+0x0/0x20 returned 0 after 0 msecs
    calling piix_ide_init+0x0/0xc0
    initcall piix_ide_init+0x0/0xc0 returned 0 after 0 msecs
    calling ide_scan_pcibus+0x0/0x100

ide_scan_pcibus doesn't return. I tried shoving some printks in there,
but as soon as I did it instead locked up in pci_init. Is it worth
continuing this approach or will doing so not give useful results
anyway?

Thanks,
--=20
Ciaran McCreesh

--Sig_/hadD.1l3yhcQq/ciuc2iYKP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgwrHYACgkQ96zL6DUtXhEDrgCfT9IYht/Q3zATWI6JlfogJltA
DX8AoJPQbb+tGKCfWNMwYFO5sKqlHeBB
=oAAK
-----END PGP SIGNATURE-----

--Sig_/hadD.1l3yhcQq/ciuc2iYKP--
