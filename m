Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZG1To4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZG1To4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZG1To4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:44:56 -0400
Received: from mail.open.by ([193.232.92.17]:55605 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZG1Toz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:44:55 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9179 [Jul 28 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 28 Jul 2009 22:47:33 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: James Morris <jmorris@namei.org>
Cc: Miloslav Trmac <mitr@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: BUG: scheduling while atomic reintroduced
Message-ID: <20090728194733.GC3223@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,
Looks like someone reintroduced "scheduling while atomic" bug.
(rc4-git2)

...
kernel: [  747.713441] BUG: scheduling while atomic: ksoftirqd/0/4/0x00000203
kernel: [  747.713450] Modules linked in: ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq asus_laptop rng_core snd_timer snd_seq_device snd i2c_i801 soundcore snd_page_alloc psmouse evdev pcspkr serio_raw usbhid hid
sg sd_mod sr_mod cdrom sdhci_pci sdhci ata_generic mmc_core pata_acpi uhci_hcd ricoh_mmc led_class ehci_hcd ata_piix ide_pci_generic usbcore r8169 mii
kernel: [  747.713567] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc4-git2 #1
kernel: [  747.713573] Call Trace:
kernel: [  747.713589]  [<c140265f>] ? printk+0x23/0x36
kernel: [  747.713601]  [<c103a865>] __schedule_bug+0x75/0x80
kernel: [  747.713610]  [<c14031f8>] schedule+0x5c8/0xb70
kernel: [  747.713622]  [<c1068d4b>] ? sched_clock_cpu+0x16b/0x1f0
kernel: [  747.713631]  [<c14058eb>] ? _spin_lock+0x1b/0x50
kernel: [  747.713642]  [<c10327a2>] ? task_rq_lock+0x42/0x90
kernel: [  747.713654]  [<c112e5b1>] ? ep_poll_callback+0xa1/0xe0
kernel: [  747.713665]  [<c1404234>] __mutex_lock_slowpath+0xe4/0x190
kernel: [  747.713674]  [<c1404035>] mutex_lock+0x25/0x50
kernel: [  747.713684]  [<c12d3443>] tty_throttle+0x23/0x70
kernel: [  747.713695]  [<c12d1d17>] n_tty_receive_buf+0x407/0x1200
kernel: [  747.713708]  [<c13a22bc>] ? __inet_lookup_established+0x2bc/0x2f0
kernel: [  747.713719]  [<c140608e>] ? _spin_unlock+0x1e/0x60
kernel: [  747.713728]  [<c13b99ef>] ? tcp_v4_rcv+0x56f/0x7a0
kernel: [  747.713739]  [<c1405f70>] ? _spin_unlock_irqrestore+0x20/0x60
kernel: [  747.713748]  [<c12d4352>] ? tty_ldisc_try+0x42/0x60
kernel: [  747.713757]  [<c12d55e5>] flush_to_ldisc+0xf5/0x1f0
kernel: [  747.713767]  [<c12d575b>] tty_flip_buffer_push+0x7b/0x90
kernel: [  747.713777]  [<c12d68b5>] pty_write+0x55/0x80
kernel: [  747.713790]  [<f8095c57>] ppp_async_push+0x397/0x480 [ppp_async]
kernel: [  747.713804]  [<f80964f5>] ppp_async_process+0x85/0x98 [ppp_async]
kernel: [  747.713814]  [<c104cad3>] tasklet_action+0xe3/0xf0
kernel: [  747.713824]  [<c104d417>] __do_softirq+0xa7/0x210
kernel: [  747.713834]  [<c104d5cd>] do_softirq+0x4d/0x60
kernel: [  747.713843]  [<c104d662>] ksoftirqd+0x82/0x1a0
kernel: [  747.713851]  [<c104d5e0>] ? ksoftirqd+0x0/0x1a0
kernel: [  747.713862]  [<c10618b4>] kthread+0x84/0x90
kernel: [  747.713872]  [<c1061830>] ? kthread+0x0/0x90
kernel: [  747.713883]  [<c1003e7f>] kernel_thread_helper+0x7/0x18
kernel: [  973.783398] BUG: scheduling while atomic: ksoftirqd/0/4/0x00000203
kernel: [  973.783407] Modules linked in: ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq asus_laptop rng_core snd_timer snd_seq_device snd i2c_i801 soundcore snd_page_alloc psmouse evdev pcspkr serio_raw usbhid hid
sg sd_mod sr_mod cdrom sdhci_pci sdhci ata_generic mmc_core pata_acpi uhci_hcd ricoh_mmc led_class ehci_hcd ata_piix ide_pci_generic usbcore r8169 mii
kernel: [  973.783525] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc4-git2 #1
kernel: [  973.783531] Call Trace:
kernel: [  973.783546]  [<c140265f>] ? printk+0x23/0x36
kernel: [  973.783558]  [<c103a865>] __schedule_bug+0x75/0x80
kernel: [  973.783567]  [<c14031f8>] schedule+0x5c8/0xb70
kernel: [  973.783579]  [<c1068d4b>] ? sched_clock_cpu+0x16b/0x1f0
kernel: [  973.783589]  [<c14058eb>] ? _spin_lock+0x1b/0x50
kernel: [  973.783599]  [<c10327a2>] ? task_rq_lock+0x42/0x90
kernel: [  973.783609]  [<c103d610>] ? default_wake_function+0x0/0x40
kernel: [  973.783620]  [<c1404234>] __mutex_lock_slowpath+0xe4/0x190
kernel: [  973.783630]  [<c1404035>] mutex_lock+0x25/0x50
kernel: [  973.783641]  [<c12d3443>] tty_throttle+0x23/0x70
kernel: [  973.783652]  [<c12d1d17>] n_tty_receive_buf+0x407/0x1200
kernel: [  973.783663]  [<c13b9348>] ? tcp_v4_do_rcv+0x258/0x390
kernel: [  973.783673]  [<c13a22bc>] ? __inet_lookup_established+0x2bc/0x2f0
kernel: [  973.783685]  [<c140608e>] ? _spin_unlock+0x1e/0x60
kernel: [  973.783693]  [<c13b99ef>] ? tcp_v4_rcv+0x56f/0x7a0
kernel: [  973.783704]  [<c1405f70>] ? _spin_unlock_irqrestore+0x20/0x60
kernel: [  973.783713]  [<c12d4352>] ? tty_ldisc_try+0x42/0x60
kernel: [  973.783723]  [<c12d55e5>] flush_to_ldisc+0xf5/0x1f0
kernel: [  973.783733]  [<c12d575b>] tty_flip_buffer_push+0x7b/0x90
kernel: [  973.783742]  [<c12d68b5>] pty_write+0x55/0x80
kernel: [  973.783755]  [<f8095c57>] ppp_async_push+0x397/0x480 [ppp_async]
kernel: [  973.783769]  [<f80964f5>] ppp_async_process+0x85/0x98 [ppp_async]
kernel: [  973.783780]  [<c104cad3>] tasklet_action+0xe3/0xf0
kernel: [  973.783789]  [<c104d417>] __do_softirq+0xa7/0x210
kernel: [  973.783799]  [<c104d5cd>] do_softirq+0x4d/0x60
kernel: [  973.783807]  [<c104d662>] ksoftirqd+0x82/0x1a0
kernel: [  973.783816]  [<c104d5e0>] ? ksoftirqd+0x0/0x1a0
kernel: [  973.783827]  [<c10618b4>] kthread+0x84/0x90
kernel: [  973.783837]  [<c1061830>] ? kthread+0x0/0x90
kernel: [  973.783848]  [<c1003e7f>] kernel_thread_helper+0x7/0x18
kernel: [  973.790112] BUG: scheduling while atomic: ksoftirqd/0/4/0x00000203
kernel: [  973.790119] Modules linked in: ppp_async crc_ccitt ppp_generic slhc ipv6 fuse loop snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq asus_laptop rng_core snd_timer snd_seq_device snd i2c_i801 soundcore snd_page_alloc psmouse evdev pcspkr serio_raw usbhid hid
sg sd_mod sr_mod cdrom sdhci_pci sdhci ata_generic mmc_core pata_acpi uhci_hcd ricoh_mmc led_class ehci_hcd ata_piix ide_pci_generic usbcore r8169 mii
kernel: [  973.790228] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-rc4-git2 #1
kernel: [  973.790244]  [<c140265f>] ? printk+0x23/0x36
kernel: [  973.790254]  [<c103a865>] __schedule_bug+0x75/0x80
kernel: [  973.790264]  [<c14031f8>] schedule+0x5c8/0xb70
kernel: [  973.790274]  [<c1068d4b>] ? sched_clock_cpu+0x16b/0x1f0
kernel: [  973.790283]  [<c14058eb>] ? _spin_lock+0x1b/0x50
kernel: [  973.790294]  [<c10327a2>] ? task_rq_lock+0x42/0x90
kernel: [  973.790306]  [<c1404234>] __mutex_lock_slowpath+0xe4/0x190
kernel: [  973.790315]  [<c1404035>] mutex_lock+0x25/0x50
kernel: [  973.790325]  [<c12d3443>] tty_throttle+0x23/0x70
kernel: [  973.790335]  [<c12d1d17>] n_tty_receive_buf+0x407/0x1200
kernel: [  973.790345]  [<c104d86c>] ? local_bh_enable_ip+0x4c/0xc0
kernel: [  973.790357]  [<f80959c5>] ? ppp_async_push+0x105/0x480 [ppp_async]
kernel: [  973.790369]  [<c104d86c>] ? local_bh_enable_ip+0x4c/0xc0
kernel: [  973.790379]  [<c1405d56>] ? _spin_unlock_bh+0x26/0x40
kernel: [  973.790393]  [<f8033878>] ? ppp_push+0x158/0x5a0 [ppp_generic]
kernel: [  973.790403]  [<c1405f70>] ? _spin_unlock_irqrestore+0x20/0x60
kernel: [  973.790412]  [<c12d4352>] ? tty_ldisc_try+0x42/0x60
kernel: [  973.790422]  [<c12d55e5>] flush_to_ldisc+0xf5/0x1f0
kernel: [  973.790432]  [<c12d575b>] tty_flip_buffer_push+0x7b/0x90
kernel: [  973.790442]  [<c12d68b5>] pty_write+0x55/0x80
kernel: [  973.790453]  [<f8095c57>] ppp_async_push+0x397/0x480 [ppp_async]
kernel: [  973.790467]  [<f80964f5>] ppp_async_process+0x85/0x98 [ppp_async]
kernel: [  973.790476]  [<c104cad3>] tasklet_action+0xe3/0xf0
kernel: [  973.790486]  [<c104d417>] __do_softirq+0xa7/0x210
kernel: [  973.790496]  [<c104d5cd>] do_softirq+0x4d/0x60
kernel: [  973.790505]  [<c104d662>] ksoftirqd+0x82/0x1a0
kernel: [  973.790514]  [<c104d5e0>] ? ksoftirqd+0x0/0x1a0
kernel: [  973.790524]  [<c10618b4>] kthread+0x84/0x90
kernel: [  973.790534]  [<c1061830>] ? kthread+0x0/0x90
kernel: [  973.790543]  [<c1003e7f>] kernel_thread_helper+0x7/0x18
...

Please Cc me.

        Sergey

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpvVdUACgkQfKHnntdSXjTTtAQAsYgywbQ6DTxzwKfkC/5/2NyE
ThsnsyY1szYhr+QVneq0cFYxLSOi8R1bAqmNOTSNuv3AFultnYKiH40K6v2/MSm8
I0cU6rIDQZvEjFJ0va8nIDMWFpuA2hWj+TshdIA3nF3POKNiv4w2s2V9qDvWOtWm
rjYPa5qEtAHD1PUDUaU=
=4aY3
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
