Return-Path: <linux-kernel-owner+w=401wt.eu-S1764612AbXHDNRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764612AbXHDNRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbXHDNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:17:42 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:53101 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756455AbXHDNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:17:41 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.23-rc1, KVM-AMD problem
Date: Sat, 4 Aug 2007 15:17:34 +0200
User-Agent: KMail/1.9.7
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200707281855.41277.alistair@devzero.co.uk> <200707291510.31731.alistair@devzero.co.uk> <46ADE0DD.1030505@qumranet.com>
In-Reply-To: <46ADE0DD.1030505@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1219845.sbl8aqGya3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708041517.37895.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1219845.sbl8aqGya3
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag 30 Juli 2007 schrieb Avi Kivity:
> Alistair John Strachan wrote:
[...]
> > Basically, the installer seems to work fine, but Windows seemed to have
> > problems after installing post-SP2 updates. Maybe that's why not
> > everybody is seeing it yet.
>
> How about the attached patch? (I haven't yet tried to reproduce, but
> this can cause an AMD-only oops).

commit 80917728e43e248155c019f743655806b582b099
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Jul 30 15:56:36 2007 +0300

    KVM: x86 emulator: disable writeback for debug register instructions
   =20
    These are handled internally by the instruction.
   =20
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 1a90ba0..2136da5 100644
=2D-- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1222,11 +1222,13 @@ twobyte_insn:
                }
                break;
        case 0x21: /* mov from dr to reg */
+               no_wb =3D 1;
                if (modrm_mod !=3D 3)
                        goto cannot_emulate;
                rc =3D emulator_get_dr(ctxt, modrm_reg, &_regs[modrm_rm]);
                break;
        case 0x23: /* mov from reg to dr */
+               no_wb =3D 1;
                if (modrm_mod !=3D 3)
                        goto cannot_emulate;
                rc =3D emulator_set_dr(ctxt, modrm_reg, _regs[modrm_rm]);


Unfortunately this doesn't seem to have made it into 2.6.23-rc2. I need it =
as=20
well, to make Windows XP boot up w/o hanging or reebooting my host machine.

Cheers,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1219845.sbl8aqGya3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGtHxxxU2n/+9+t5gRAu0oAKCFs5ZjCnapwFR5IVfn4NKnYSXhIACdFnvt
VnItBG6Pv84twArLgO+afCA=
=Onc+
-----END PGP SIGNATURE-----

--nextPart1219845.sbl8aqGya3--
