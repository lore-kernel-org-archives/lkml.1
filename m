Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZIXH6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZIXH6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZIXH6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:58:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:37097 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751944AbZIXH6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:58:30 -0400
X-Authenticated: #32306085
X-Provags-ID: V01U2FsdGVkX18/StNyXJk/Ts3lfskbwrcdgVj/CYijMxaYvG+kZo
	7dVhR8ruPMbsYv
From: Christoph Thielecke <christoph.thielecke@gmx.de>
Reply-To: christoph.thielecke@gmx.de
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: console access lost after deregistering oti6858 module
Date: Thu, 24 Sep 2009 09:58:36 +0200
User-Agent: KMail/1.9.9
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4157812.MlDVcoHxhH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909240958.39383.christoph.thielecke@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4157812.MlDVcoHxhH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I found a problem with the oti6858 usbserial driver. Sometimes something go=
es=20
wrong and I lost completly the console access. I can type chars in a=20
application like firefox but not in any console window (xterm or real tty).=
=20
ssh login succeedes partly but I dont get a prompt in this case. After=20
examining the syslog I found that:

=2D---- syslog begin ------
Sep 24 09:27:48 develop kernel: usbcore: deregistering interface driver=20
oti6858
Sep 24 09:27:48 develop kernel: ------------[ cut here ]------------
Sep 24 09:27:48 develop kernel: WARNING: at kernel/workqueue.c:368=20
flush_cpu_workqueue+0x68/0x6a()
Sep 24 09:27:48 develop kernel: Hardware name: MP061
Sep 24 09:27:48 develop kernel: Modules linked in: oti6858(-) nvidia(P)=20
binfmt_misc ppdev lp parport rfcomm l2cap bluetooth tun vboxnetadp vboxnetf=
lt=20
vboxdrv pppol2tp pppox ppp_generic slhc ipv6 capifs acpi_cpufreq=20
cpufreq_ondemand cpufr
eq_powersave cpufreq_stats freq_table cpufreq_userspace cpufreq_conservativ=
e=20
nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc deflate zlib_deflate ctr=
=20
twofish twofish_common camellia serpent blowfish cast5 des_generic cbc=20
aes_i586 aes_g
eneric xcbc rmd160 sha256_generic sha1_generic crypto_null af_key=20
nls_iso8859_1 nls_cp437 vfat fat fuse dm_snapshot dm_mirror dm_region_hash=
=20
dm_log coretemp loop pl2303 snd_hda_codec_idt usbhid snd_hda_intel hid=20
snd_hda_codec snd_hwdep s
nd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 snd_seq_oss ecb=20
snd_seq_midi snd_rawmidi iwl3945 snd_seq_midi_event usbserial dm9601 snd_se=
q=20
iwlcore sdhci_pci firewire_ohci usb_storage asix usbnet snd_timer sdhci=20
snd_seq_device intel
_agp rtc_cmos b44 mmc_core firewire_core mac80211 snd crc_itu_t agpgart=20
iTCO_wdt iTCO_vendor_support rtc_core rtc_lib ssb ohci1394 soundcore=20
snd_page_alloc joydev led_class pcmcia pcmcia_core mii ieee1394 ricoh_mmc=20
button battery ac vide
o processor cfg80211 sg i2c_i801 i2c_core uhci_hcd ehci_hcd evdev usbcore=20
psmouse wmi dell_laptop sr_mod serio_raw output cdrom rfkill dm_mod thermal=
=20
fan ide_pci_generic
Sep 24 09:27:48 develop kernel: Pid: 7, comm: events/0 Tainted: P  R       =
=20
2.6.31 #1
Sep 24 09:27:48 develop kernel: Call Trace:
Sep 24 09:27:48 develop kernel: [<c133a780>] ? printk+0x18/0x20
Sep 24 09:27:48 develop kernel: [<c1042fe4>] ? flush_cpu_workqueue+0x68/0x6a
Sep 24 09:27:48 develop kernel: [<c1032761>] warn_slowpath_common+0x66/0xae
Sep 24 09:27:48 develop kernel: [<c1042fe4>] ? flush_cpu_workqueue+0x68/0x6a
Sep 24 09:27:48 develop kernel: [<c10327be>] warn_slowpath_null+0x15/0x17
Sep 24 09:27:48 develop kernel: [<c1042fe4>] flush_cpu_workqueue+0x68/0x6a
Sep 24 09:27:48 develop kernel: [<c10290e1>] ? default_wake_function+0xb/0xd
Sep 24 09:27:48 develop kernel: [<c103bf43>] ? lock_timer_base+0x1f/0x40
Sep 24 09:27:48 develop kernel: [<c10431be>] flush_workqueue+0x2e/0x4c
Sep 24 09:27:48 develop kernel: [<c10431e9>] flush_scheduled_work+0xd/0xf
Sep 24 09:27:48 develop kernel: [<f805bf96>] oti6858_close+0x74/0x10a=20
[oti6858]
Sep 24 09:27:48 develop kernel: [<f8a777d9>] serial_do_down+0x33/0x3f=20
[usbserial]
Sep 24 09:27:48 develop kernel: [<f8a777f6>] serial_hangup+0x11/0x1c=20
[usbserial]
Sep 24 09:27:48 develop kernel: [<c1232568>] do_tty_hangup+0xbf/0x325
Sep 24 09:27:48 develop kernel: [<c10429c2>] worker_thread+0x153/0x22c
Sep 24 09:27:48 develop kernel: [<c1023141>] ? __wake_up_common+0x3f/0x63
Sep 24 09:27:48 develop kernel: [<c12324a9>] ? do_tty_hangup+0x0/0x325
Sep 24 09:27:48 develop kernel: [<c1046baf>] ?=20
autoremove_wake_function+0x0/0x3a
Sep 24 09:27:48 develop kernel: [<c104286f>] ? worker_thread+0x0/0x22c
Sep 24 09:27:48 develop kernel: [<c1046896>] kthread+0x74/0x76
Sep 24 09:27:48 develop kernel: [<c1046822>] ? kthread+0x0/0x76
Sep 24 09:27:48 develop kernel: [<c1004127>] kernel_thread_helper+0x7/0x10
Sep 24 09:27:48 develop kernel: ---[ end trace ca500da836b73c70 ]---
Sep 24 09:27:48 develop kernel: oti6858 ttyUSB1: oti6858 converter now=20
disconnected from ttyUSB1
Sep 24 09:27:48 develop kernel: oti6858 4-1:1.0: device disconnected
Sep 24 09:27:48 develop kernel: USB Serial deregistering driver oti6858
Sep 24 09:27:49 develop chipcardd[28322]: devicemanager.c: 3356: Changes in=
=20
hardware list
=2D---- syslog end ------

I think this should fixed. I'm not an basic user and can test a lot and fin=
d a=20
way to help me but its very nasty to do a hard shutdown (system hangs on=20
reboot).

With best regards

Christoph
=2D-=20
Linux User Group Wernigerode
http://www.lug-wr.de/

--nextPart4157812.MlDVcoHxhH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq7Jq0ACgkQd9JRTD5SjRhDqACeNpfgiqfxx1xYXeiWZE+S6zer
KZAAniVakA+CB55uvrLiAKonMMNpuo7S
=Md/O
-----END PGP SIGNATURE-----

--nextPart4157812.MlDVcoHxhH--
