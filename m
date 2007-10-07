Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbXJGQtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbXJGQtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXJGQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:49:48 -0400
Received: from smtp4.netcabo.pt ([212.113.174.31]:9523 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbXJGQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:49:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtajAFKrCEdViow7PGdsb2JhbACBWYxVAQEBATU
Date: Sun, 7 Oct 2007 17:49:37 +0100
From: Luciano Rocha <strange@nsk.no-ip.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: can't change euid 0 to uid != running user
Message-ID: <20071007164937.GA4382@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <strange@nsk.no-ip.org>,
	Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org
References: <20071005142541.GA9224@bit.office.eurotux.com> <2c0942db0710050828jcb161c0qc10e65f7f65af6c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <2c0942db0710050828jcb161c0qc10e65f7f65af6c4@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 07 Oct 2007 16:49:39.0456 (UTC) FILETIME=[0D1BA800:01C80902]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 05, 2007 at 08:28:50AM -0700, Ray Lee wrote:
> On 10/5/07, Luciano Rocha <strange@nsk.no-ip.org> wrote:
> > I have the following problem:
> > $ sudo -u ie -s # or sudo su ie
> > unable to change to runas uid: Resource temporarily unavailable
> >
> > Works:
> > $ sudo su, followed by su ie
> >
> > The first sudo also worked while I had a shell under user ie.
> >
> > When I exited, it stopped working, but it is now working every time I
> > trie it.
> >
> > dmesg shows:
> >
> > [82602.729330] kobject_add failed for 504 with -EEXIST, don't try to
> >                register things with the same name in the same directory.
> > [82602.729365]  [<c04b9195>] kobject_shadow_add+0x16e/0x1a0
> > [82602.729383]  [<c04b9480>] kobject_set_name+0x29/0x92
> > [82602.729504]  [<c04238ea>] user_kobject_create+0x6a/0x90
> > [82602.729520]  [<c0423cce>] alloc_uid+0x18f/0x1d7
> > [82602.729530]  [<c0427030>] set_user+0x1c/0x8f
> > [82602.729539]  [<c0428b5f>] sys_setresuid+0xd5/0x162
> > [82602.729552]  [<c0403e6a>] syscall_call+0x7/0xb
> > [82602.729575]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> > $ git describe
> > v2.6.23-rc9-156-ga95dacb
> >
> > (Clone of Linus' tree, after rc9, with some patches from
> > mingo/linux-2.6-sched-devel.git, and a fix for lguest (didn't link due
> > to kasprintf)).
>=20
> Hmm, it works for me under 2.6.23-rc6, so it's either a difference
> between our .configs or a late regression. If you could bisect the
> problem (starting with reverting Ingo's sched devel patches and lguest
> patches, and trying that), then that would tell us where the issue is.
>=20

Without the patches, i.e., a clean Linus tree (v2.6.23-rc9-41-g804b3f9),
I can't reproduce it anymore.

The commits since v2.6.23-rc9:

804b3f9a16e446cb023417faec58b6506c834052 Merge branch 'upstream-linus' of m=
aster.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev
3e0ca2f148f97c5748f52bcf2a69dd17cb2b1d13 Merge branch 'upstream-linus' of m=
aster.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
c7659e2c139d0be4647bef89188a932e0254d709 Merge branch 'upstream' of git://f=
tp.linux-mips.org/pub/scm/upstream-linus
66b1f1a982bf4dbad9fa0de25b8d95c4936f05c4 Merge branch 'for-linus' of master=
=2Ekernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6
991bf528f602882580d0918842b125255d246a19 drivers/ata/pata_ixp4xx_cf.c: iore=
map return code check
90925d3050253ff7b4f5d1660071df75f44bd0ff Ata: pata_marvell, use ioread* for=
 iomap-ped memory
4007b493ee6e4a52c2b618ab8361847fba5bf116 libata: fix for sata_mv >64KB DMA =
segments
bda0233b89c10ae46ccecb78bffdaf0fd7833d17 ocfs2: Unlock mutex in local alloc=
 failure case
529d303e075aa6d988f30935b8995ffb382ad38e sky2: jumbo frame regression fix
5c55c434917429f229a1bf43def97fd421f444c6 Merge branch 'fixes-jgarzik' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6 into upst=
ream-fixes
cda6a20b68c1f21f4b4bc9cd3ee08494e7ebf0d5 Blackfin arch: fix PORT_J BUG for =
BF537/6 EMAC driver reported by Kalle Pokki <kalle.pokki@iki.fi>
c58c2140f08de4ad0b0dbd48f6e78168dc321042 Blackfin arch: gpio pinmux and res=
ource allocation API required by BF537 on chip ethernet mac driver
9ea0f043fec38fadb0101fbf29563a5635f42e93 [MIPS] Terminally fix local_{dec,s=
ub}_if_positive
fef74705ea310acd716c2722bfeb0f796cf23640 [MIPS] Type proof reimplementation=
 of cmpxchg.
f6a9e6dec537dc1d9d2c62d7b8ad205d0993bddc [MIPS] pg-r4k.c: Fix a typo in an =
R4600 v2 erratum workaround
ee0a8169b693e1c708d0f9af0a5e4ade65a65439 [PATCH] softmac: Fix compiler-warn=
ing
4365e99f9587b94010e9818a4237ce2b1c734e91 [PATCH] bcm43xx: Correct printk wi=
th PFX before KERN_
f778089cb2445dfc6dfd30a7a567925fd8589f1e Merge branch 'sas-fixes' of master=
=2Ekernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6
db7a89db5e3bc6ba131965183577b15fd6fc92cc Merge branch 'upstream-linus' of m=
aster.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
2910ca6f8ae69648623b3c05b79be87dd7bda73d Merge branch 'upstream-linus' of m=
aster.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev
d237098c03eb91cef240e9a1b248c0e1ecd1c80c Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/mingo/linux-2.6-sched
114d5b1ca265f8a582dcbf0030da20ccdddbe8e1 Merge branch 'master' of master.ke=
rnel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6
2b3b29080d702e5488f214276170ab46adc40ee5 Merge branch 'master' of master.ke=
rnel.org:/pub/scm/linux/kernel/git/davem/net-2.6
e80eaf9904d5b19512265e1435372b2e12146a5f Merge branch 'merge' of git://git.=
kernel.org/pub/scm/linux/kernel/git/paulus/powerpc
d136552e8beadcf5e59089292e2ba44f09e3aad8 aic94xx: fix DMA data direction fo=
r SMP requests
f662fe5a0b144efadbfc00e8040e603ec318746e dm9601: Fix receive MTU
593ff56ef2a23ed3a66ee87d9c9b33044b9fb193 mv643xx_eth: Do not modify struct =
netdev tx_queue_len
50626297b1beb0a29c0f174be39f36485533216c qla3xxx: bugfix: Fix VLAN rx compl=
etion handling.
b323e0e49fe9331ee3a7a336af879d6e303b16b3 qla3xxx: bugfix: Add memory barrie=
r before accessing rx completion.
4c74d4ec3524a8f31deadd115139dd93bc91d598 ata_piix: add another TECRA M3 ent=
ry to broken suspend list
30084fbd1caa4b2e1a336fcdef60b68129d1d8f8 sched: fix profile=3Dsleep
25e5566ed38650f7990041fcd20571d6ddd2a040 [SPARC64]: Fix missing load-twin u=
sage in Niagara-1 memcpy.
04045f98e0457aba7d4e6736f37eed189c48a5f7 [IEEE80211]: avoid integer underfl=
ow for runt rx frames
9b42c336d06411e6463949d2dac63949f66ff70b [TCP]: secure_tcp_sequence_number(=
) should not use a too fast clock
32740ddc1095e5e320bf961dda146bf97bc28adb [SFQ]: Remove artificial limitatio=
n for queue limit.
e48395f1753cab0fde6c03f1db833cece9ef2ba0 [POWERPC] Fix xics set_affinity co=
de
8cc8c28a9acdceda0e60519167a052cc3408c5c3 [SPARC64]: Fix put_user() calls in=
 binfmt_aout32.c
9c908f97d0f9aee32fa6d4b0a44c4c5d0ccab2b0 [SPARC]: Fix EBUS use of uninitial=
ized variable.
0b95f22bd3b91c7114c6892bbfbb5a8576b27fbe Blackfin arch: add some missing sy=
scall
576bb9ced2d274446639d7fbeee7125e24daf012 binfmt_flat: checkpatch fixing min=
imum support for the blackfin relocations
f9720205d1f847cb59e197e851b5276425363f6b Binfmt_flat: Add minimum support f=
or the Blackfin relocations

--=20
lfr
0/0

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHCQ4ginSul6a7oB8RAsrdAKCKe9BjaULAr9iBsPy+phr6orSclQCgoxFe
rSS61WMGEU2rAqz1EeEFUYU=
=H5ja
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
