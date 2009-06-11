Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbZFKWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbZFKWgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbZFKWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:36:07 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:59519 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbZFKWgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:36:06 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 18:36:05 EDT
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: Kernel trace log when resuming from suspend to disk
Date: Fri, 12 Jun 2009 00:30:24 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906120030.24654.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

today I moved to 2.6.30 and experienced suspend/resume problem:

------------[ cut here ]------------
WARNING: at kernel/time/timekeeping.c:98 getnstimeofday+0x21/0xcc()
Hardware name: 259IA1
Modules linked in: rfcomm l2cap parport_pc lp parport michael_mic arc4 ecb 
crypt
omgr aead pcompress crypto_blkcipher crypto_hash crypto_algapi 
lib80211_crypt_tk
ip sbp2 ide_cd_mod ide_core dvb_usb_dib0700 dib7000p dib7000m mt2266 
dvb_usb_dib
usb_mc tuner_xc2028 mxl5007t xc5000 s5h1411 dvb_usb_dibusb_common dvb_pll 
mt2060
 lgdt3305 dib0070 dib3000mc dibx000_common dvb_usb btusb dvb_core bluetooth 
snd_
intel8x0 snd_intel8x0m snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss 
ohci139
4 ieee1394 ipw2200 libipw snd_seq_oss snd_seq_midi_event 8139too pcspkr video 
ou
tput lib80211 mii firewire_ohci firewire_core snd_pcm snd_seq snd_timer 
snd_seq_
device snd 8250_pci snd_page_alloc iTCO_wdt i2c_i801 8250 serial_core ehci_hcd 
u
hci_hcd sg
Pid: 4606, comm: powerbtn.sh Not tainted 2.6.30 #1
Call Trace:
 [<c011ab6a>] ? warn_slowpath_common+0x41/0x71
 [<c011ab87>] ? warn_slowpath_common+0x5e/0x71
 [<c011aba4>] ? warn_slowpath_null+0xa/0xc
 [<c012f55e>] ? getnstimeofday+0x21/0xcc
 [<c012c5b0>] ? ktime_get_ts+0x1d/0x3f
 [<c012c5dc>] ? ktime_get+0xa/0x19
 [<c01184e6>] ? try_to_wake_up+0xe1/0xeb
 [<c01326e2>] ? tick_handle_oneshot_broadcast+0x2c/0xa9
 [<c0104573>] ? timer_interrupt+0x3f/0x48
 [<c014553e>] ? handle_IRQ_event+0x1a/0x90
 [<c014657a>] ? handle_level_irq+0x6b/0xcb
 [<c0104214>] ? handle_irq+0x38/0x44
 [<c0103edf>] ? do_IRQ+0x2b/0x63
 [<c0102ee9>] ? common_interrupt+0x29/0x30
 [<c0110000>] ? ack_apic_level+0x3d/0x93
 [<c010ea7f>] ? lapic_resume+0x166/0x16f
 [<c02a0a54>] ? __sysdev_resume+0x11/0x34
 [<c02a0ccc>] ? sysdev_resume+0x17/0x4b
 [<c013a063>] ? hibernation_snapshot+0xe6/0x1a3
 [<c013952d>] ? freeze_processes+0x7a/0x81
 [<c0139a99>] ? prepare_processes+0x5/0x18
 [<c013a1b5>] ? hibernate+0x95/0x130
 [<c0139027>] ? state_store+0x41/0xa1
 [<c0138fe6>] ? state_store+0x0/0xa1
 [<c0215792>] ? kobj_attr_store+0x18/0x1c
 [<c019f7f0>] ? sysfs_write_file+0xa4/0xd8
 [<c019f74c>] ? sysfs_write_file+0x0/0xd8
 [<c016848a>] ? vfs_write+0x73/0xa1
 [<c016854d>] ? sys_write+0x3c/0x60
 [<c0102931>] ? syscall_call+0x7/0xb
---[ end trace db14fdcfad1fcc16 ]---

Thanks for a fix!

Michal
