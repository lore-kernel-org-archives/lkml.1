Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbXFVVit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbXFVVit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXFVVim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:38:42 -0400
Received: from web52904.mail.re2.yahoo.com ([206.190.49.14]:24586 "HELO
	web52904.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752543AbXFVVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:38:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bbwHjFfvS6yvGsw3uPKQAeE7OksVfbIdixwq4tjDR+XNhcmOl7nZvktsRo3JouZlGcEZXxMVnqkLxZIa9ewGBIRASxbc7HW85rv1dpw8U7cdAI5rpvIq2GbcvH6boNDqSRSm2qYkBTqhEwKWO+l2s0LsoaGIbzidQSO4F6s21cA=;
X-YMail-OSG: _mtYnk8VM1nc6pcdGhmZJ7eJsQSjgDYtZDnuOiN5yYSS8Xz1ktkyCiydXwV20fkayYkQsrzhW45RRCSbfVqZCTOn4ox0tlEJn7cLogRLV39UM4x3GzAeQRdtzagWNwnH9aEUQw4R_44_E9M-
Date: Fri, 22 Jun 2007 22:38:40 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] Linux 2.6.21.5 - Radeon NMI lockup
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <588227.68720.qm@web52904.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experienced this BUG while playing World of Warcraft with a Radeon 9200 AGPx8 video card and
FC7:

BUG: NMI Watchdog detected LOCKUP on CPU3, eip c019f98f, registers:
Modules linked in: snd_rtctimer snd_seq_midi radeon drm cpufreq_ondemand p4_clockmod speedstep_lib
nfsd exportfs autofs4 eeprom nfs lockd sunrpc af_packet ipv6 binfmt_misc video1394 raw1394 eth1394
thermal processor fan button ac lp nvram loop snd_emu10k1_synth snd_emux_synth snd_seq_virmidi
snd_seq_midi_emul snd_emu10k1 firmware_class snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_usb_audio snd_pcm_oss snd_mixer_oss snd_usb_lib pwc snd_pcm
snd_rawmidi snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep compat_ioctl32 snd
e7xxx_edac videodev ohci1394 v4l2_common edac_mc v4l1_compat ieee1394 serio_raw e1000 i2c_i801
parport_pc soundcore pcspkr sata_sil psmouse parport intel_agp agpgart i2c_core sr_mod cdrom sg
dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd
ohci_hcd uhci_hcd usbcore
CPU:    3
EIP:    0060:[<c019f98f>]    Not tainted VLI
EFLAGS: 00200297   (2.6.21.5 #1)
EIP is at delay_tsc+0xb/0x13
eax: 0487b218   ebx: 00000a4e   ecx: 0487ab54   edx: 00002707
esi: 00000080   edi: 00484af1   ebp: 00000000   esp: ce02bea8
ds: 007b   es: 007b   fs: 00d8  gs: 003b  ss: 0068
Process WoW.exe (pid: 4977, ti=ce02b000 task=f7fd8070 task.ti=ce02b000)
Stack: f7b506c8 c019f9c0 f8e2d6c7 00000000 00000001 ce02bee0 f5a4c0ec 00001fdb 
       f5a4c0ec f6d4d578 00000000 00000000 f8e2edf4 00000182 c02c58ac ce02bf28 
       c0336120 00000003 ed06ff24 00000003 00000000 00000000 00000000 00000000 
Call Trace:
 [<c019f9c0>] __delay+0x6/0x7
 [<f8e2d6c7>] radeon_freelist_get+0xde/0x11d [radeon]
 [<f8e2edf4>] radeon_cp_buffers+0xff/0x17c [radeon]
 [<f8e2ecf5>] radeon_cp_buffers+0x0/0x17c [radeon]
 [<f8e1ffb7>] drm_ioctl+0x146/0x18f [drm]
 [<c015d024>] do_ioctl+0x4c/0x62
 [<c015d279>] vfs_ioctl+0x23f/0x251
 [<c015d2be>] sys_ioctl+0x33/0x4d
 [<c0102722>] sysenter_past_esp+0x5f/0x85
 [<c0250033>] cookie_v4_check+0x19a/0x3d3
 =======================
Code: 26 00 00 00 00 8d bc 27 00 00 00 00 eb 0e 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 48 79 fd
c3 53 89 c3 0f 31 89 c1 f3 90 0f 31 <29> c8 39 d8 72 f6 5b c3 c7 05 6c d1 2c c0 84 f9 19 c0 c3 89
c1 

Cheers,
Chris



      ___________________________________________________________ 
Yahoo! Mail is the world's favourite email. Don't settle for less, sign up for
your free account today http://uk.rd.yahoo.com/evt=44106/*http://uk.docs.yahoo.com/mail/winter07.html 
