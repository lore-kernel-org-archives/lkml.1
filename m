Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYBKS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYBKS0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYBKS0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:26:09 -0500
Received: from rosi.naasa.net ([212.8.0.13]:53353 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbYBKS0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:26:06 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: BUG with 2.6.25-rc1 and smack
Date: Mon, 11 Feb 2008 19:26:02 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802111926.03067.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when booting linux 2.6.25-rc1 I get the following error:

BUG: unable to handle kernel NULL pointer dereference at 00000138
IP: [<c01aa59e>] smack_netlabel+0x13/0xc8
*pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: nfsd auth_rpcgss exportfs af_packet autofs4 ipt_MASQUERADE 
iptable_nat nf_nat nf_conntrack_ipv4 xt_state ipt_REJECT ipt_LOG xt_limit 
xt_mark xt_tcpudp xt_mac iptable_filter xt_
MARK xt_multiport iptable_mangle ip_tables x_tables nf_conntrack_ftp 
nf_conntrack cpufreq_userspace cpufreq_stats cpufreq_powersave nfs lockd 
nfs_acl sunrpc deflate zlib_deflate zlib_inflate ctr
twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 
aes_generic xcbc sha256_generic sha1_generic md5 crypto_null hmac crypto_hash 
af_key nls_utf8 ntfs nls_base ext2 fuse ebt
able_broute bridge llc ebtable_nat ebtable_filter ebtables deadline_iosched 
as_iosched ircomm_tty ircomm tun acpi_cpufreq video output sbs sbshc joydev 
arc4 ecb crypto_blkcipher cryptomgr crypto_
algapi snd_intel8x0m irtty_sir sir_dev snd_intel8x0 snd_ac97_codec ac97_bus 
snd_pcm_oss snd_pcm snd_mixer_oss nsc_ircc irda crc_ccitt parport_pc 
snd_seq_oss parport 8250_pnp snd_seq_midi snd_rawm
idi snd_seq_midi_event snd_seq serio_raw snd_timer snd_seq_device psmouse 
ath5k snd mac80211 pcspkr 8250_pci yenta_socket rsrc_nonstatic cinergyT2 8250 
cfg80211 pcmcia firmware_class dvb_core ser
ial_core soundcore snd_page_alloc pcmcia_core i2c_i801 rng_core iTCO_wdt 
iTCO_vendor_support battery ac button intel_agp agpgart thinkpad_acpi hwmon 
evdev nvram ext3 jbd mbcache sg usbhid hid ff_
memless sr_mod cdrom sd_mod ata_generic pata_acpi floppy ata_piix e1000 libata 
scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan unix 
cpufreq_conservative cpufreq_ondemand freq_table bay d
ock fbcon tileblit font bitblit softcursor radeonfb fb fb_ddc backlight 
i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect

Pid: 5307, comm: nfsd Not tainted (2.6.25-rc1 #1)
EIP: 0060:[<c01aa59e>] EFLAGS: 00010286 CPU: 0
EIP is at smack_netlabel+0x13/0xc8
EAX: 00000000 EBX: f682edf4 ECX: 00000006 EDX: 00000002
ESI: 00000000 EDI: 00000001 EBP: f682ee18 ESP: f682edd8
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process nfsd (pid: 5307, ti=f682e000 task=f7f54e50 task.ti=f682e000)
Stack: 00000040 f732e1a4 c0331998 f732e290 f682edf8 c01aacf8 f732e1a4 f7468400
       f682ee04 c01aad52 f732e1a4 f682ee0c c01a7510 c0331668 f732e180 00000001
       f682ee20 c01aa665 f682ee34 c01a7a06 00000006 00000001 fffffff4 f682ee58
Call Trace:
 [<c01aacf8>] ? new_inode_smack+0x39/0x3f
 [<c01aad52>] ? smack_inode_alloc_security+0x16/0x27
 [<c01a7510>] ? security_inode_alloc+0x19/0x1b
 [<c01aa665>] ? smack_socket_post_create+0x12/0x18
 [<c01a7a06>] ? security_socket_post_create+0x16/0x1b
 [<c02116ce>] ? sock_create_lite+0x44/0x64
 [<c0211712>] ? kernel_accept+0x24/0x5f
 [<f9f77ef3>] ? svc_tcp_accept+0x51/0x526 [sunrpc]
 [<c012f200>] ? getnstimeofday+0x2f/0xb4
 [<c012db9e>] ? ktime_get_ts+0x3b/0x3f
 [<c011508c>] ? hrtick_start_fair+0xcb/0x107
 [<c0212730>] ? lock_sock_nested+0xab/0xb3
 [<c0211e5f>] ? kernel_recvmsg+0x2b/0x3d
 [<f9f7dcf0>] ? svc_xprt_received+0x1e/0x20 [sunrpc]
 [<f9f77c88>] ? svc_udp_recvfrom+0xd3/0x2ed [sunrpc]
 [<c01153da>] ? enqueue_task_fair+0x41/0x4c
 [<f9f7dd02>] ? svc_xprt_put+0x10/0x12 [sunrpc]
 [<f9f7de5b>] ? svc_xprt_release+0x92/0x9a [sunrpc]
 [<f9f7ed20>] ? svc_recv+0x335/0x665 [sunrpc]
 [<c01172d6>] ? default_wake_function+0x0/0xd
 [<fa0676b3>] ? nfsd+0xd5/0x28e [nfsd]
 [<fa0675de>] ? nfsd+0x0/0x28e [nfsd]
 [<c01054a7>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: 5d f0 74 0d 46 8b 5d f0 c6 45 ef 80 83 eb 08 eb c6 59 5b 5b 5e 5f 5d c3 
55 b9 06 00 00 00 89 e5 57 56 89 c6 53 83 ec 34 8d 5d dc <8b> 90 38 01 00 00 
31 c0 89 df f3 ab 83 3d f4 19 33 c0 03 8
b 3a
EIP: [<c01aa59e>] smack_netlabel+0x13/0xc8 SS:ESP 0068:f682edd8
---[ end trace 499ec328c921ccf2 ]---

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

