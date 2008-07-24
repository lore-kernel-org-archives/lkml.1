Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYGXKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYGXKCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYGXKC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:02:26 -0400
Received: from server.drzeus.cx ([85.8.24.28]:43950 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751416AbYGXKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:02:25 -0400
Date: Thu, 24 Jul 2008 12:02:17 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: bad dereference in sched_mc_power_savings_store()
Message-ID: <20080724120217.163a03f3@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-5621-1216893741-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-5621-1216893741-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I get the following with yesterdays kernel:

[   62.650080] BUG: unable to handle kernel NULL pointer dereference at 000=
00002
[   62.650093] IP: [<c0428736>] sched_mc_power_savings_store+0x6/0x40
[   62.650109] *pdpt =3D 0000000035447001 *pde =3D 0000000000000000=20
[   62.650119] Oops: 0000 [#2] PREEMPT SMP=20
[   62.650127] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conn=
track_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tab=
les x_tables bridge stp llc rfcomm l2cap fuse sunrpc ipv6 acpi_cpufreq binf=
mt_misc loop kvm_intel kvm sr_mod cdrom snd_hda_intel snd_seq_dummy ata_pii=
x pcmcia snd_seq_oss ata_generic snd_seq_midi_event snd_seq arc4 ecb i2c_i8=
01 sdhci_pci snd_seq_device yenta_socket firewire_ohci crypto_blkcipher rtc=
_cmos sdhci firewire_core snd_pcm_oss rsrc_nonstatic sg rtc_core thinkpad_a=
cpi mmc_core snd_mixer_oss i2c_core pcmcia_core rtc_lib ricoh_mmc ac pcspkr=
 pata_acpi crc_itu_t iwl4965 video snd_pcm output iwlcore battery bay rfkil=
l snd_timer mac80211 snd wmi soundcore hci_usb e1000e button snd_page_alloc=
 bluetooth cfg80211 ahci libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd o=
hci_hcd ehci_hcd [last unloaded: microcode]
[   62.650292]=20
[   62.650298] Pid: 2823, comm: sched-powersave Tainted: G      D   (2.6.26=
 #108)
[   62.650304] EIP: 0060:[<c0428736>] EFLAGS: 00010286 CPU: 1
[   62.650312] EIP is at sched_mc_power_savings_store+0x6/0x40
[   62.650317] EAX: c076e700 EBX: c0428730 ECX: 00000002 EDX: ffffffea
[   62.650323] ESI: c076e724 EDI: f5546000 EBP: f54aff3c ESP: f54aff28
[   62.650328]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   62.650334] Process sched-powersave (pid: 2823, ti=3Df54af000 task=3Df4f=
fa400 task.ti=3Df54af000)
[   62.650338] Stack: f54aff3c c059d930 f740c150 c076e418 f541b2c0 f54aff6c=
 c04e7f32 00000002=20
[   62.650355]        00000002 b7fb2000 f587f900 f541b2d4 c076e418 c076e724=
 f587f900 b7fb2000=20
[   62.650370]        00000002 f54aff90 c049f81c f54aff9c 00000001 00000004=
 c04e7e90 f587f900=20
[   62.650385] Call Trace:
[   62.650390]  [<c059d930>] ? sysdev_class_store+0x30/0x40
[   62.650403]  [<c04e7f32>] ? sysfs_write_file+0xa2/0x100
[   62.650414]  [<c049f81c>] ? vfs_write+0x9c/0x160
[   62.650424]  [<c04e7e90>] ? sysfs_write_file+0x0/0x100
[   62.650433]  [<c049f9a2>] ? sys_write+0x42/0x70
[   62.650442]  [<c0403fc6>] ? syscall_call+0x7/0xb
[   62.650451]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   62.650455] Code: ff 89 c3 b8 08 e9 75 c0 e8 08 5d 24 00 e8 93 4b 00 00 =
89 d8 5b c9 c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 ba ea ff ff ff =
<0f> b6 09 89 e5 8d 41 d0 3c 01 76 0e 89 d0 c9 c3 8d 76 00 8d bc=20
[   62.650540] EIP: [<c0428736>] sched_mc_power_savings_store+0x6/0x40 SS:E=
SP 0068:f54aff28
[   62.650560] ---[ end trace 155686795e307d74 ]---

I'm guessing it's because of commit 4a0b2b4dbe.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-5621-1216893741-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiIUywACgkQ7b8eESbyJLgd3gCfa41+cYaMtHokGIlhoNtLDZiQ
1J4AnR87qHlmUYy4DY9wXg2QzMpIbb4M
=/Kki
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-5621-1216893741-0001-2--
