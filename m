Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbZFNTJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbZFNTJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbZFNTJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:09:36 -0400
Received: from rosi.naasa.net ([212.8.0.13]:51564 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZFNTJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:09:35 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 15:09:35 EDT
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-acpi@vger.kernel.org
Subject: [2.6.30] Kernel bug with dock driver
Date: Sun, 14 Jun 2009 21:00:47 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906142100.48621.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

today I ran into the following bug several times (Kernel 2.6.30, IBM ThinkPad 
T40 with ultrabay HD and CD/DVD):

BUG: unable to handle kernel paging request at 00001000
IP: [<c01df5fa>] strcpy+0xe/0x1b
*pde = 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file: /sys/class/power_supply/BAT0/energy_full
Modules linked in: nls_iso8859_1 nls_cp850 vfat fat usb_storage usb_libusual
udf crc_itu_t sg sr_mod cdrom nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs
radeon drm sco bridge stp llc bnep l2cap bluetooth ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT
ipt_LOG xt_limit xt_tcpudp xt_mac xt_multiport iptable_filter iptable_mangle
ip_tables x_tables nf_conntrack_ftp nf_conntrack vboxdrv binfmt_misc
af_packet cpufreq_userspace cpufreq_stats cpufreq_powersave nsc_ircc autofs4
fuse nls_utf8 ntfs nls_base ext2 deadline_iosched as_iosched ircomm_tty
ircomm tun acpi_cpufreq sbs sbshc snd_intel8x0m snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event joydev snd_seq snd_timer snd_seq_device
dvb_usb_cinergyT2 thinkpad_acpi irtty_sir dvb_usb yenta_socket
rsrc_nonstatic ipw2200 pcmcia libipw sir_dev rfkill snd video led_class
lib80211 i2c_i801 rng_core soundcore pcmcia_core snd_page_alloc 8250_pci
dvb_core irda parport_pc parport crc_ccitt psmouse pcspkr nvram output
battery ac button processor rtc_cmos 8250_pnp serio_raw rtc_core rtc_lib
8250 serial_core evdev ext3 jbd mbcache usbhid hid sd_mod ata_generic
pata_acpi ata_piix uhci_hcd ehci_hcd libata e1000 usbcore scsi_mod intel_agp
agpgart thermal fan unix cpufreq_conservative cpufreq_ondemand freq_table
radeonfb fb_ddc backlight i2c_algo_bit cfbcopyarea i2c_core cfbimgblt
cfbfillrect fbcon tileblit font bitblit softcursor fb

Pid: 52, comm: kacpi_notify Not tainted (2.6.30 #1) 2373G1G
EIP: 0060:[<c01df5fa>] EFLAGS: 00010286 CPU: 0
EIP is at strcpy+0xe/0x1b
EAX: c278a22c EBX: c278a200 ECX: c278a22c EDX: 00001000
ESI: 00001000 EDI: c278a22c EBP: f70a8f34 ESP: f70a8f28
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kacpi_notify (pid: 52, ti=f70a8000 task=f70c0c40 task.ti=f70a8000)
Stack:
 c278a200 c278a214 c278a244 f70a8f64 c01fc898 030a8f54 00001000 f708a879
 00000002 f6b3ca80 c278a218 00000014 f97fb132 f0a07a80 00000000 f70a8f70
 f97fb14e 00000000 f70a8f7c f97fb023 f7041460 f70a8f8c c020199d f6984ac0
Call Trace:
 [<c01fc898>] ? acpi_bus_generate_netlink_event+0x140/0x199
 [<f97fb132>] ? bay_notify+0x0/0x1f [thinkpad_acpi]
 [<f97fb14e>] ? bay_notify+0x1c/0x1f [thinkpad_acpi]
 [<f97fb023>] ? dispatch_acpi_notify+0x23/0x26 [thinkpad_acpi]
 [<c020199d>] ? acpi_ev_notify_dispatch+0x4c/0x57
 [<c01f4558>] ? acpi_os_execute_deferred+0x20/0x2c
 [<c012cff6>] ? worker_thread+0x15a/0x1fd
 [<c01f4538>] ? acpi_os_execute_deferred+0x0/0x2c
 [<c012fc7d>] ? autoremove_wake_function+0x0/0x33
 [<c012ce9c>] ? worker_thread+0x0/0x1fd
 [<c012f8bc>] ? kthread+0x42/0x67
 [<c012f87a>] ? kthread+0x0/0x67
 [<c01030d3>] ? kernel_thread_helper+0x7/0x10
Code: ff ff 21 e3 8b 5b 18 83 eb 07 39 d9 73 08 89 01 89 51 04 31 c0 c3 b8
f2 ff ff ff c3 90 55 89 c1 89 e5 57 89 c7 56 89 d6 83 ec 04 <ac> aa 84 c0 75
fa 5a 89 c8 5e 5f 5d c3 55 89 e5 57 89 c7 56 89
EIP: [<c01df5fa>] strcpy+0xe/0x1b SS:ESP 0068:f70a8f28
CR2: 0000000000001000
---[ end trace fe729b61cde0024d ]---

The bug message appears with a high probability - but not always - when I 
release the eject lever to exchange the drive in the ultrabay slot. I'm not 
sure if this bug is a regression of 2.6.30, because I did not change the drive 
in the ultrabay for several months. Maybe it was already in 2.6.29 or before. 
How can I help to resolve this bug?

regards,
Jörg
