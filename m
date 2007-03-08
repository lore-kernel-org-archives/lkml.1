Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXCHICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXCHICS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXCHICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:02:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:8843 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbXCHICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HilH0CuwrJ8pbquZX5Q5u6lfcAiIpwS0Mtdq+KwlDMOYmPUnl6Jx0FNUemLdpcrkEAgzsEHhLFOSkUosUtm4lI4HuCZCgseevjSEqWhOBzuTrSQUxnhFhh2zXjmKWVRirdZgeVYpUIoeZsR4WcAtVP5mwzAE5/DnqJj2P794udU=
Message-ID: <ea6b19020703080002q2e0944bdufec7af2a902ccc1@mail.gmail.com>
Date: Thu, 8 Mar 2007 09:02:14 +0100
From: "Alexis Ballier" <alexis.ballier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel oops with dvb_usb_umt_010 module (x86_64 2.6.21-rc3)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I bought a HanfTek UMT-010 dvb-T usb stick, so I compiled yesterday's
linus' git tree (2.6.21-rc3) and downloaded the firmware from
linuxtv.org. The driver loads fine :


[  170.316104] usb 1-4: new high speed USB device using ehci_hcd and address 5
[  170.448372] usb 1-4: configuration #1 chosen from 1 choice
[  170.667165] dvb-usb: found a 'Hanftek UMT-010 DVB-T USB2.0 ' in
cold state, will try to load a firmware
[  170.702176] dvb-usb: downloading firmware from file 'dvb-usb-umt-010-02.fw'
[  170.737380] usbcore: registered new interface driver dvb_usb_umt_010
[  170.737624 ] usb 1-4: USB disconnect, address 5
[  170.739692] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[  172.493762] usb 1-4: new high speed USB device using ehci_hcd and address 6
[  172.626428 ] usb 1-4: configuration #1 chosen from 1 choice
[  172.626502] dvb-usb: found a 'Hanftek UMT-010 DVB-T USB2.0' in warm state.
[  172.641677] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  172.641860] DVB: registering new adapter (Hanftek UMT-010 DVB-T USB2.0).
[  172.643098] DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
[  172.657695] dvb-usb: Hanftek UMT-010 DVB-T USB2.0 successfully
initialized and connected.

but when I try to access it (with vlc, or dvbscan -c for example) I
get a kernel oops :

[  180.459390] Unable to handle kernel paging request at 000000002de68808 RIP:
[  180.459393]  [<ffffffff882ad315>]
:dvb_usb_dibusb_common:dibusb_streaming_ctrl+0x35/0xa0
[  180.459402] PGD 2ddd1067 PUD 2de40067 PMD 0
[  180.459406] Oops: 0000 [1] PREEMPT
[  180.459408] CPU 0
[  180.459410] Modules linked in: dvb_usb_umt_010 mt352
dvb_usb_dibusb_common dib3000mc dibx000_common dvb_usb dvb_core
dvb_pll nfsd exportfs lockd nfs_acl sunrpc xt_state xt_multiport
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device reiserfs genrtc eth1394 bt878 tuner msp3400 saa7134
ir_kbd_i2c 8250_pnp 8250 serial_core bttv video_buf ir_common
compat_ioctl32 i2c_algo_bit btcx_risc tveeprom videodev v4l2_common
v4l1_compat parport_pc parport psmouse ohci1394 ieee1394 snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc ide_cd
cdrom i2c_nforce2 i2c_core
[  180.459443] Pid: 8363, comm: dvbscan Not tainted 2.6.21-rc3-dirty #22
[  180.459446] RIP: 0010:[<ffffffff882ad315>]  [<ffffffff882ad315>]
:dvb_usb_dibusb_common:dibusb_streaming_ctrl+0x35/0xa0
[  180.459453] RSP: 0018:ffff810034aa9ca8  EFLAGS: 00010296
[  180.459455] RAX: 0000000000000051 RBX: 000000002de68800 RCX: 0000000000000000
[  180.459458] RDX: 00000000ffffff01 RSI: 0000000000000000 RDI: 0000000000000001
[  180.459461] RBP: ffff81002dc5ee90 R08: 00000000ffffffff R09: 0000000000000001
[  180.459464] R10: 00000000ffffffff R11: 0000000000000006 R12: 0000000000000001
[  180.459467] R13: 0000000000000001 R14: ffff81002dc5ef60 R15: ffff81002dc5efc8
[  180.459471] FS:  00002b3a0c76d6d0(0000) GS:ffffffff805e3000(0000)
knlGS:0000000000000000
[  180.459474] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  180.459476] CR2: 000000002de68808 CR3: 00000000293f3000 CR4: 00000000000006e0
[  180.459480] Process dvbscan (pid: 8363, threadinfo
ffff810034aa8000, task ffff81003be4a1c0)
[  180.459482] Stack:  ffff81002dc5ee90 0000000000000001
ffff81002dc5ee90 ffffffff882ad58b
[  180.459488]  0000000000000000 ffff81002dc5ee90 ffff81002dc5ee90
0000000000000001
[  180.459493]  ffffc20010586000 ffffffff882a1496 0000000000000002
ffffc20010586000
[  180.459497] Call Trace:
[  180.459503]  [<ffffffff882ad58b>]
:dvb_usb_dibusb_common:dibusb2_0_streaming_ctrl+0x3b/0x110
[  180.459512]  [<ffffffff882a1496>] :dvb_usb:dvb_usb_ctrl_feed+0x106/0x140
[  180.459525]  [<ffffffff8828dea8>]
:dvb_core:dmx_section_feed_start_filtering+0x108/0x170
[  180.459535]  [<ffffffff8828b502>]
:dvb_core:dvb_dmxdev_filter_start+0x2c2/0x480
[  180.459542]  [<ffffffff8025a432>] kobject_get+0x12/0x20
[  180.459547]  [<ffffffff802bdce8>] cdev_get+0x88/0xc0
[  180.459558]  [<ffffffff8828b9a4>] :dvb_core:dvb_demux_do_ioctl+0x2e4/0x490
[  180.459567]  [<ffffffff8828b6c0>] :dvb_core:dvb_demux_do_ioctl+0x0/0x490
[  180.459576]  [<ffffffff8828a165>] :dvb_core:dvb_usercopy+0xe5/0x170
[  180.459588]  [<ffffffff80228f0d>] do_filp_open+0x2d/0x40
[  180.459595]  [<ffffffff80243db9>] do_ioctl+0x69/0xa0
[  180.459600]  [<ffffffff80231773>] vfs_ioctl+0x2a3/0x2e0
[  180.459607]  [<ffffffff8024ea39>] sys_ioctl+0x49/0x80
[  180.459611]  [<ffffffff8021a922>] do_sys_open+0xd2/0x100
[  180.459617]  [<ffffffff8025fb9e>] system_call+0x7e/0x83
[  180.459625]
[  180.459626]
[  180.459627] Code: 48 83 7b 08 00 74 44 48 c7 c7 08 d7 2a 88 31 c0 e8 36 73 fd
[  180.459636] RIP  [<ffffffff882ad315>]
:dvb_usb_dibusb_common:dibusb_streaming_ctrl+0x35/0xa0
[  180.459642]  RSP <ffff810034aa9ca8>
[  180.459643] CR2: 000000002de68808


after doing some basic tracking, I found that the offending line was :

               if (st->ops.fifo_ctrl != NULL){

in drivers/media/dvb/dvb-usb/dibusb-common.c : ~25

I modified it to do some printk, and the value of st I have is :
000000002de68800

Is that a correct value ?
I've not really been able to track where this value comes from so I
suppose reporting that here is the best way to get some help as I have
no clue on how to fix that.

-- 

Regards,

Alexis Ballier.
