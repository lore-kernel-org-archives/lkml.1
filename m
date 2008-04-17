Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYDQVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYDQVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYDQVZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:25:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:35714 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752787AbYDQVZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:25:47 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX181RexbzII1sTcBhEqd8iGdeH/kydh2oloYtRDom5
	MSsIsmE+MQvg3i
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SUNRPC: Fix a memory leak in rpc_create()
Date: Thu, 17 Apr 2008 23:25:38 +0200
User-Agent: KMail/1.9.9
References: <20080417010122.148289106@sous-sol.org> <20080417010354.950049854@sous-sol.org>
In-Reply-To: <20080417010354.950049854@sous-sol.org>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
       Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1687315.ZbDtMz5Yvy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804172325.39462.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1687315.ZbDtMz5Yvy
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Donnerstag, 17. April 2008, you wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> upstream commit: ed13c27e546667fb0967ae30f5070cd7f6455f90
>=20
> Commit 510deb0d was supposed to move the xprt_create_transport() call in
> rpc_create(), but neglected to remove the old call site.  This resulted in
> a transport leak after every rpc_create() call.
>=20
> This leak is present in 2.6.24 and 2.6.25.
>=20
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>=20
>  net/sunrpc/clnt.c |    4 ----
>  1 file changed, 4 deletions(-)
>=20
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -249,10 +249,6 @@ struct rpc_clnt *rpc_create(struct rpc_c
>  	};
>  	char servername[20];
> =20
> -	xprt =3D xprt_create_transport(&xprtargs);
> -	if (IS_ERR(xprt))
> -		return (struct rpc_clnt *)xprt;
> -
>  	/*
>  	 * If the caller chooses not to specify a hostname, whip
>  	 * up a string representation of the passed-in address.
>=20

This patch might introduce a regression:

kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 17
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Bridge firewalling registered
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth0 entered promiscuous mode
audit(1208454819.533:2): dev=3Deth0 prom=3D256 old_prom=3D0 auid=3D42949672=
95
br0: port 1(eth0) entering learning state
br0: no IPv6 routers present
eth0: no IPv6 routers present
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state
lp0: using parport0 (interrupt-driven).
lp0: console ready
ppdev: user-space parallel port driver
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
BUG: unable to handle kernel NULL pointer dereference at virtual address 00=
0001c2
printing eip: f9043e90 *pde =3D 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ppdev lp =
ac battery bridge ipv6 af_packet nls_iso8859_1 nls_cp437 vfat fat fuse dm_c=
rypt vboxdrv powernow_k8 freq_table snd_ens1371 gameport snd_hda_intel snd_=
ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq=
_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_=
device snd soundcore button i2c_nforce2 snd_page_alloc parport_pc parport k=
8temp i2c_core psmouse evdev serio_raw pcspkr ext3 jbd dm_mirror dm_snapsho=
t dm_mod sd_mod usb_storage sg sr_mod cdrom usbhid ff_memless sata_nv pata_=
acpi libusual ata_generic ohci1394 pata_amd forcedeth ieee1394 libata ehci_=
hcd ohci_hcd usbcore ssb pcmcia pcmcia_core thermal processor fan

Pid: 2874, comm: rpc.nfsd Not tainted (2.6.24-2.6.24.4.slh.6-sidux-686 #1)
EIP: 0060:[<f9043e90>] EFLAGS: 00010282 CPU: 1
EIP is at rpc_create+0x20/0x400 [sunrpc]
EAX: f90575bf EBX: 0000000a ECX: f90575bf EDX: 00000002
ESI: f76d1e20 EDI: f76d1d40 EBP: f76d1d18 ESP: f76d1cb0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rpc.nfsd (pid: 2874, ti=3Df76d0000 task=3Ddf8b3080 task.ti=3Df76d00=
00)
Stack: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000=
000
       00000202 bae43b63 c0265a43 f76d1d3c f76d1d40 f76d1d44 f76d1d48 f76d1=
d4c
       7d7aeed1 c39f2ca7 00000014 0000000a f76d1e20 f76d1d40 f76d1d18 f9050=
dda
Call Trace:
 [<c0265a43>] __add_entropy_words+0x63/0x1f0
 [<f9050dda>] rpcb_create+0xaa/0xb0 [sunrpc]
 [<f905113d>] rpcb_register+0xfd/0x1d0 [sunrpc]
 [<f904b290>] svc_register+0xa0/0x170 [sunrpc]
 [<f904bb89>] __svc_create+0x179/0x1d0 [sunrpc]
 [<f90ad3e0>] write_ports+0x0/0x190 [nfsd]
 [<f904bc2f>] svc_create_pooled+0x4f/0x170 [sunrpc]
 [<f90ac6f0>] nfsd_last_thread+0x0/0x80 [nfsd]
 [<f90ac6f0>] nfsd_last_thread+0x0/0x80 [nfsd]
 [<f90ad3e0>] write_ports+0x0/0x190 [nfsd]
 [<f90ac543>] nfsd_create_serv+0x63/0xd0 [nfsd]
 [<f90ac770>] nfsd+0x0/0x2c0 [nfsd]
 [<f90ad3e0>] write_ports+0x0/0x190 [nfsd]
 [<f90ad472>] write_ports+0x92/0x190 [nfsd]
 [<f90ad3e0>] write_ports+0x0/0x190 [nfsd]
 [<f90acf65>] nfsctl_transaction_write+0x55/0x80 [nfsd]
 [<f90acf10>] nfsctl_transaction_write+0x0/0x80 [nfsd]
 [<c01888e5>] vfs_write+0xb5/0x140
 [<c0188f81>] sys_write+0x41/0x70
 [<c010445a>] syscall_call+0x7/0xb
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 00 00 00 00 8d bc 27 00 00 00 00 83 ec 5c 89 6c 24 58 89 c5 89 5c 24 =
4c 89 74 24 50 89 7c 24 54 8b 40 14 85 c0 0f 84 37 03 00 00 <0f> b6 83 b8 0=
1 00 00 83 c8 02 88 83 b8 01 00 00 f6 45 24 08 74
EIP: [<f9043e90>] rpc_create+0x20/0x400 [sunrpc] SS:ESP 0068:f76d1cb0
=2D--[ end trace 602ea69c0564d8ad ]---

The kernel has been compiled with gcc 4.2.3 (current debian/ unstable) and=
=20
eth0 is part of a bridge using tun/ tap for virtualbox-ose. Neither=20
2.6.24.4, nor 2.6.24.5-rc1 with this patch reverted trigger this Oops.

Responses might be a little delayed, as I am relaying this report for a=20
user (and cannot confirm it myself), I'll ask him to test 2.6.25 tomorrow.

Regards
	Stefan Lippers-Hollmann

--nextPart1687315.ZbDtMz5Yvy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIB8BTORbEMfgJlPYRAnv5AJ9a8faa6HgPy+ayXRDINOSwRjTDxACfblge
OuI2mwhW/dQ3I+7dEKxx8/c=
=UM9b
-----END PGP SIGNATURE-----

--nextPart1687315.ZbDtMz5Yvy--
