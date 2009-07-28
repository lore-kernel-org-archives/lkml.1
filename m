Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZG1WR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZG1WR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZG1WR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:17:57 -0400
Received: from mail.open.by ([193.232.92.17]:59958 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbZG1WR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:17:57 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9182 [Jul 29 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 29 Jul 2009 01:18:42 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: James Morris <jmorris@namei.org>
Cc: Miloslav Trmac <mitr@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: BUG: scheduling while atomic reintroduced
Message-ID: <20090728221842.GD3223@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

something is wrong with tty->termios_mutex

kernel: [16662.855163] BUG: scheduling while atomic: ksoftirqd/0/4/0x00000203
kernel: [16662.855172] Modules linked in: usb_storage ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq asus_laptop rng_core snd_timer snd_seq_device snd i2c_i801 soundcore snd_page_alloc psmouse
evdev pcspkr serio_raw usbhid hid sg sd_mod sr_mod cdrom sdhci_pci sdhci ata_generic mmc_core pata_acpi uhci_hcd ricoh_mmc led_class ehci_hcd ata_piix ide_pci_generic usbcore
r8169 mii
kernel: [16662.855292] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc4-git2 #1
kernel: [16662.855298] Call Trace:
kernel: [16662.855313]  [<c140265f>] ? printk+0x23/0x36
kernel: [16662.855325]  [<c103a865>] __schedule_bug+0x75/0x80
kernel: [16662.855336]  [<c14031f8>] schedule+0x5c8/0xb70
kernel: [16662.855347]  [<c1068d4b>] ? sched_clock_cpu+0x16b/0x1f0
kernel: [16662.855357]  [<c14058eb>] ? _spin_lock+0x1b/0x50
kernel: [16662.855367]  [<c10327a2>] ? task_rq_lock+0x42/0x90
kernel: [16662.855380]  [<c112e5b1>] ? ep_poll_callback+0xa1/0xe0
kernel: [16662.855391]  [<c1404234>] __mutex_lock_slowpath+0xe4/0x190
kernel: [16662.855401]  [<c1404035>] mutex_lock+0x25/0x50
kernel: [16662.855411]  [<c12d3443>] tty_throttle+0x23/0x70
kernel: [16662.855422]  [<c12d1d17>] n_tty_receive_buf+0x407/0x1200
kernel: [16662.855432]  [<c13b9348>] ? tcp_v4_do_rcv+0x258/0x390
kernel: [16662.855443]  [<c13a22bc>] ? __inet_lookup_established+0x2bc/0x2f0
kernel: [16662.855454]  [<c140608e>] ? _spin_unlock+0x1e/0x60
kernel: [16662.855463]  [<c13b99ef>] ? tcp_v4_rcv+0x56f/0x7a0
kernel: [16662.855475]  [<c109ccf0>] ? move_native_irq+0x20/0x70
kernel: [16662.855485]  [<c1405f70>] ? _spin_unlock_irqrestore+0x20/0x60
kernel: [16662.855494]  [<c12d4352>] ? tty_ldisc_try+0x42/0x60
kernel: [16662.855504]  [<c12d55e5>] flush_to_ldisc+0xf5/0x1f0
kernel: [16662.855514]  [<c12d575b>] tty_flip_buffer_push+0x7b/0x90
kernel: [16662.855524]  [<c12d68b5>] pty_write+0x55/0x80
kernel: [16662.855537]  [<f8095c57>] ppp_async_push+0x397/0x480 [ppp_async]
kernel: [16662.855551]  [<f80964f5>] ppp_async_process+0x85/0x98 [ppp_async]
kernel: [16662.855561]  [<c104cad3>] tasklet_action+0xe3/0xf0
kernel: [16662.855570]  [<c104d417>] __do_softirq+0xa7/0x210
kernel: [16662.855580]  [<c104d5cd>] do_softirq+0x4d/0x60
kernel: [16662.855589]  [<c104d662>] ksoftirqd+0x82/0x1a0
kernel: [16662.855598]  [<c104d5e0>] ? ksoftirqd+0x0/0x1a0
kernel: [16662.855608]  [<c10618b4>] kthread+0x84/0x90
kernel: [16662.855618]  [<c1061830>] ? kthread+0x0/0x90
kernel: [16662.855629]  [<c1003e7f>] kernel_thread_helper+0x7/0x18


commit 26a2e20f4a966bebc312836aeb4423fbfd4e33e2
commit 38db89799bdf11625a831c5af33938dcb11908b6


	Sergey
--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpveUIACgkQfKHnntdSXjQqAQP/bbCYBpmdUOpQ4pBUMG4wAtM4
KV3m2mJs2t/4Whl4CMAKzRMchTMHeFN85O+YQKk5++19zNBKG0Z4mV7KfB+68NOv
JY+CuvPBc/J6yk+hsqZKceujSwU+KbyjvDLHFlKjz8moQB7VPx8LkwckdD+FN+ad
E9swxGPAKHW6DzrqWqM=
=kkSQ
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
