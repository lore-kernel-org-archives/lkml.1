Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXGXIWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXGXIWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbXGXIWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:22:11 -0400
Received: from hydra.gt.owl.de ([195.71.99.218]:53178 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933456AbXGXIWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:22:07 -0400
Date: Tue, 24 Jul 2007 10:22:05 +0200
From: Florian Lohoff <flo@rfc822.org>
To: Stephen Hemminger <shemminger@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1 sky2 boot crash in sky2_mac_intr
Message-ID: <20070724082205.GA19480@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
Organization: rfc822 - pure communication
X-SpiderMe: mh-200707241011@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
i am seeing irregular crashes on boot in the sky2_mac_intr. This is an
Fujitsu Siemens Lifebook E8110 with a Core Duo. Currently i suspect some
strange BIOS issues as the issues i see with the sky2 aka parity errors
etc i also see sometimes with the integrated ipw3945 which complains
about firmware errors. It seems the BIOS randomly fails to initialize
all the hardware. To reproduce this crash and catch it on the serial
console it took me around 12 boots. The machine is stable once correctly
booted and i work most of the day on it.

[   46.479939] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -=
> IRQ 19
[   46.568569] sky2 0000:02:00.0: v1.16 addr 0xf0000000 irq 19 Yukon-EC Ult=
ra (0xb4) rev 2
[   46.664555] sky2 eth0: addr 00:17:42:13:45:8c

[   61.958741] sky2 eth1: enabling interface
[   62.010834] sky2 eth1: phy write timeout
[   62.060319] sky2 eth1: phy write timeout
[   62.109819] sky2 eth1: phy write timeout
[   62.159330] sky2 eth1: phy write timeout
[   62.208811] sky2 eth1: phy write timeout
[   62.258306] sky2 eth1: phy write timeout
[   62.307786] sky2 eth1: phy write timeout
[   62.357323] sky2 eth1: phy write timeout
[   62.406820] sky2 eth1: phy write timeout
[   62.456304] sky2 eth1: phy write timeout
[   62.505796] sky2 eth1: phy write timeout
[   62.555275] sky2 eth1: phy write timeout
[   62.604766] sky2 eth1: phy write timeout
[   62.654259] sky2 eth1: phy write timeout
[   62.703736] sky2 eth1: phy write timeout
[   62.750601] sky2 0000:02:00.0: error interrupt status=3D0xffffffff
[   62.822361] sky2 0000:02:00.0: PCI hardware error (0xffff)
[   62.887897] sky2 0000:02:00.0: PCI Express error (0xffffffff)
[   62.956548] sky2 eth1: hw error interrupt status 0xffffffff
[   63.023112] sky2 eth1: ram data read parity error
[   63.079308] sky2 eth1: ram data write parity error
[   63.136536] sky2 eth1: MAC parity error
[   63.182382] BUG: unable to handle kernel NULL pointer dereference at vir=
tual address 0000020c
[   63.284354]  printing eip:
[   63.316658] e004c528
[   63.342729] *pde =3D 00000000
[   63.376072] Oops: 0000 [#1]
[   63.409407] PREEMPT SMP=20
[   63.439704] Modules linked in: sbp2 hci_usb bluetooth snd_hda_intel snd_=
pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_ra=
wmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device pcmcia ipw3945 sm=
sc_ircc2 ehci_hcd snd ieee80211 ieee80211_crypt uhci_hcd ohci1394 sdhci yen=
ta_socket rsrc_nonstatic parport_pc parport irda ieee1394 mmc_core ide_cd u=
sbcore pcmcia_core crc_ccitt snd_page_alloc sky2
[   63.883256] CPU:    0
[   63.883257] EIP:    0060:[<e004c528>]    Not tainted VLI
[   63.883258] EFLAGS: 00010202   (2.6.23-rc1 #1)
[   64.026826] EIP is at sky2_mac_intr+0x14/0xac [sky2]
[   64.086857] eax: 00000080   ebx: 00000001   ecx: 00000008   edx: 00000000
[   64.167942] esi: df4d6c00   edi: ffffffff   ebp: ffffffff   esp: de3c1dbc
[   64.249024] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   64.318683] Process ifconfig (pid: 1878, ti=3Dde3c0000 task=3Ddf43b740 t=
ask.ti=3Dde3c0000)
[   64.409113] Stack: e004e1e0 e0051fa5 df4d5000 00000000 c15ae914 00042010=
 ffffffff ffffffff=20
[   64.509381]        e004f737 e00521b2 e00520cf c15ae914 ffffffff c040fbe0=
 de3c1e4c df4d5000=20
[   64.609644]        df4d6c00 00000000 000000ff c02c3be6 c13c5400 c02c9ea9=
 c13d9dc0 00000287=20
[   64.709905] Call Trace:
[   64.741230]  [<e004e1e0>] sky2_hw_error+0xf9/0x12a [sky2]
[   64.805757]  [<e004f737>] sky2_poll+0x1da/0xa88 [sky2]
[   64.867171]  [<c02c3be6>] kfree_skbmem+0x8/0x61
[   64.921311]  [<c02c9ea9>] net_tx_action+0x61/0xd0
[   64.977521]  [<c02c9ea9>] net_tx_action+0x61/0xd0
[   65.033734]  [<c02c9ea9>] net_tx_action+0x61/0xd0
[   65.089942]  [<c02ca586>] net_rx_action+0x92/0x1b5
[   65.147197]  [<c012a467>] __do_softirq+0x58/0xba
[   65.202372]  [<c012a4fa>] do_softirq+0x31/0x36
[   65.255472]  [<c012a8cb>] local_bh_enable_ip+0x36/0x56
[   65.316876]  [<e004d816>] sky2_up+0x234/0x5df [sky2]
[   65.376203]  [<c02c9da1>] dev_open+0x2e/0x68
[   65.427223]  [<c02c80e3>] dev_change_flags+0x9d/0x14e
[   65.487590]  [<c0305886>] devinet_ioctl+0x224/0x532
[   65.545874]  [<c02c9686>] dev_ifsioc+0x113/0x396
[   65.601043]  [<c02c8ef2>] dev_load+0x24/0x4b
[   65.652060]  [<c02be7ad>] sock_ioctl+0x0/0x1be
[   65.705159]  [<c02be94c>] sock_ioctl+0x19f/0x1be
[   65.760329]  [<c011b983>] do_page_fault+0x269/0x58e
[   65.818613]  [<c02be7ad>] sock_ioctl+0x0/0x1be
[   65.871708]  [<c0177703>] do_ioctl+0x1f/0x62
[   65.922732]  [<c017797d>] vfs_ioctl+0x237/0x249
[   65.976869]  [<c01779c2>] sys_ioctl+0x33/0x4d
[   66.028925]  [<c0103e52>] sysenter_past_esp+0x5f/0x85
[   66.089293]  [<c0320000>] pfkey_send_notify+0x41/0x226
[   66.150699]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   66.193363] Code: 05 e0 e8 da a2 0d e0 03 1f c7 03 00 04 00 00 83 c4 1c =
5b 5e 5f 5d c3 55 57 56 89 c6 53 89 d3 83 ec 10 8b 54 90 08 89 d8 c1 e0 07 =
<8b> ba 0c 02 00 00 89 44 24 0c 05 08 0f 00 00 03 06 f6 47 0d 02=20
[   66.422172] EIP: [<e004c528>] sky2_mac_intr+0x14/0xac [sky2] SS:ESP 0068=
:de3c1dbc
[   66.511713] Kernel panic - not syncing: Fatal exception in interrupt

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGpbatUaz2rXW+gJcRAhOhAJ0ZrUbDhrzuO0GRx2Wi2m20hyytuACgpvMW
OXeqduEqFyZa/Vol68QP+CM=
=uEP8
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
