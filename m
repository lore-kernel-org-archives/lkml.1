Return-Path: <linux-kernel-owner+w=401wt.eu-S1766913AbXDSRz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766913AbXDSRz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766912AbXDSRz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:55:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:22578 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766913AbXDSRz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=AdIu0D55Qy2kshChl/2NIAiovPaWt5uCBU8hA892kmXEJEzzhVgNqS793Upn/Br1DKh/6/vyw1ZVgKGrWGDsM8wA9e4SzEfUR/0/ACMhtj+6LkPQxTJ5GnQLzQQRLU2rCWBBJv/ricZ0n3dIt+gmRNU2oCqbziF5Wnr5xvc7+PM=
Message-ID: <4627ACED.3000808@gmail.com>
Date: Thu, 19 Apr 2007 18:54:53 +0100
From: Chris Murton <chris.murton@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops on 2.6.21 with dvb-usb-dib0700?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Get an occasional Oops which can occur either when the device is in use, 
or idle.. and it only usually happens after several hours of uptime with 
the module and device loaded. The 'oops' seems to directly correlate 
with the device appearing to disconnect and reconnect via USB (but 
nothing physical has changed).

In this example, the box was booted at 21:50 and the Oops occurred at 
03:13 when the device was idle:

Apr 19 03:13:01 basil kernel: usb 2-1: USB disconnect, address 2
Apr 19 03:13:01 basil kernel: ehci_hcd 0000:04:08.2: qh ffff81003dbc61e0 
(#82) state 4(has tds)
Apr 19 03:13:01 basil kernel: mt2060 I2C write failed
Apr 19 03:13:01 basil kernel: mt2060 I2C write failed
Apr 19 03:13:01 basil kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T 
successfully deinitialized and disconnected.
Apr 19 03:13:02 basil kernel: usb 2-1: new high speed USB device using 
ehci_hcd and address 3
Apr 19 03:13:02 basil kernel: usb 2-1: configuration #1 chosen from 1 choice
Apr 19 03:13:02 basil kernel: dvb-usb: found a 'Hauppauge Nova-T 500 
Dual DVB-T' in warm state.
Apr 19 03:13:02 basil kernel: **WARNING** I2C adapter driver [Hauppauge 
Nova-T 500 Dual DVB-T] forgot to specify physical device; fi
x it!
Apr 19 03:13:02 basil kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Apr 19 03:13:02 basil kernel: DVB: registering new adapter (Hauppauge 
Nova-T 500 Dual DVB-T).
Apr 19 03:13:02 basil kernel: **WARNING** I2C adapter driver [DiBX000 
tuner I2C bus] forgot to specify physical device; fix it!
Apr 19 03:13:02 basil kernel: DVB: registering frontend 0 (DiBcom 
3000MC/P)...
Apr 19 03:13:02 basil kernel: MT2060: successfully identified (IF1 = 1220)
Apr 19 03:13:02 basil kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Apr 19 03:13:02 basil kernel: DVB: registering new adapter (Hauppauge 
Nova-T 500 Dual DVB-T).
Apr 19 03:13:02 basil kernel: **WARNING** I2C adapter driver [DiBX000 
tuner I2C bus] forgot to specify physical device; fix it!
Apr 19 03:13:02 basil kernel: DVB: registering frontend 1 (DiBcom 
3000MC/P)...
Apr 19 03:13:02 basil kernel: MT2060: successfully identified (IF1 = 1220)
Apr 19 03:13:03 basil kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T 
successfully initialized and connected.
Apr 19 03:17:30 basil kernel: Unable to handle kernel NULL pointer 
dereference at 0000000000000000 RIP:
Apr 19 03:17:30 basil kernel:  [<ffffffff804a4af2>] 
__mutex_lock_interruptible_slowpath+0x22/0x99
Apr 19 03:17:30 basil kernel: PGD 13042067 PUD 13043067 PMD 0
Apr 19 03:17:30 basil kernel: Oops: 0002 [1]
Apr 19 03:17:30 basil kernel: CPU 0
Apr 19 03:17:30 basil kernel: Modules linked in: nvidia(P) snd_mpu401 
snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_hda_intel
snd_hda_codec snd_seq snd_pcm_oss snd_mixer_oss dvb_usb_dib0700 dib7000m 
dib7000p dvb_usb snd_rawmidi dvb_core snd_pcm snd_timer snd
_seq_device lirc_imon lirc_mceusb2 lirc_dev dvb_pll dib3000mc 
dibx000_common mt2060 snd_page_alloc
Apr 19 03:17:30 basil kernel: Pid: 7860, comm: mythbackend Tainted: 
P      2.6.20 #1
Apr 19 03:17:30 basil kernel: RIP: 0010:[<ffffffff804a4af2>]  
[<ffffffff804a4af2>] __mutex_lock_interruptible_slowpath+0x22/0x99
Apr 19 03:17:30 basil kernel: RSP: 0018:ffff81002e929ea8  EFLAGS: 00010292
Apr 19 03:17:30 basil kernel: RAX: ffffc200101ad0a0 RBX: 
ffffc200101ad098 RCX: 0000000000000000
Apr 19 03:17:30 basil kernel: RDX: ffff81002e929fd8 RSI: 
ffff8100331ee980 RDI: ffffc200101ad098
Apr 19 03:17:30 basil kernel: RBP: ffff810034403200 R08: 
0000000000000000 R09: 0000000000001eb4
Apr 19 03:17:30 basil kernel: R10: 0000000000000000 R11: 
0000000000000206 R12: ffffc200101ad098
Apr 19 03:17:30 basil kernel: R13: ffff81003cff7418 R14: 
ffff81003da1a8c0 R15: ffff81003c997b70
Apr 19 03:17:30 basil kernel: FS:  000000004a816960(0063) 
GS:ffffffff80615000(0000) knlGS:00000000f7db58c0
Apr 19 03:17:30 basil kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Apr 19 03:17:30 basil kernel: CR2: 0000000000000000 CR3: 
0000000013041000 CR4: 00000000000006e0
Apr 19 03:17:30 basil kernel: Process mythbackend (pid: 7860, threadinfo 
ffff81002e928000, task ffff810034403200)
Apr 19 03:17:30 basil kernel: Stack:  ffffc200101ad0a0 0000000000000000 
0000000000000000 0000000800000000
Apr 19 03:17:30 basil kernel:  ffff81003c542fa0 ffffc200101ad000 
ffff81003c542fa0 ffffffff88043d22
Apr 19 03:17:30 basil kernel:  0000000000000008 ffff8100331ee980 
ffff81003cff7418 ffffffff802618ec
Apr 19 03:17:30 basil kernel: Call Trace:
Apr 19 03:17:30 basil kernel:  [<ffffffff88043d22>] 
:dvb_core:dvb_demux_release+0x37/0xba
Apr 19 03:17:30 basil kernel:  [<ffffffff802618ec>] __fput+0xb1/0x164
Apr 19 03:17:30 basil kernel:  [<ffffffff8023671d>] hrtimer_wakeup+0x0/0x21
Apr 19 03:17:30 basil kernel:  [<ffffffff8025f3ec>] filp_close+0x5d/0x65
Apr 19 03:17:30 basil kernel:  [<ffffffff8026046d>] sys_close+0x76/0xaf
Apr 19 03:17:30 basil kernel:  [<ffffffff802092be>] system_call+0x7e/0x83
Apr 19 03:17:30 basil kernel:
Apr 19 03:17:30 basil kernel:
Apr 19 03:17:30 basil kernel: Code: 48 89 21 48 89 4c 24 08 48 89 6c 24 
10 48 83 c8 ff 87 03 ff
Apr 19 03:17:30 basil kernel: RIP  [<ffffffff804a4af2>] 
__mutex_lock_interruptible_slowpath+0x22/0x99
Apr 19 03:17:30 basil kernel:  RSP <ffff81002e929ea8>
Apr 19 03:17:30 basil kernel: CR2: 0000000000000000

If you need any more diagnostics or information from me, just let me know.

Thanks
Chris
