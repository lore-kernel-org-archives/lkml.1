Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXEBCEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXEBCEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbXEBCEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:04:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59126 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXEBCEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:04:07 -0400
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was:
	Critical points about ...)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Markus Rechberger <mrechberger@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	 <1178031333.3958.63.camel@localhost>
	 <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
Content-Type: text/plain; charset=utf-8
Date: Tue, 01 May 2007 23:03:51 -0300
Message-Id: <1178071431.11109.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2007-05-01 às 16:16 -0700, Trent Piepho escreveu:
> On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> > With this configuration, dvb-bt8xx hangs during initialization,
> > generating an OOPS, if you have a board with DST (modprobe dvb-bt8xx
> > never returns).
> 
> Stupid typo in the first patch, a != should have been ==.
> 
> Fixed:
> http://linuxtv.org/hg/~tap/dst-new

With the changes, the dst unselection worked.

Those are the logs with dst unselected:

DVB: registering new adapter (bttv0).
DVB: Unable to find symbol dst_attach()
frontend_init: Could not find a Twinhan DST.
dvb-bt8xx: A frontend driver was not found for device 109e/0878 subsystem fbfb/f800


However, when dst is selected, I got those errors:


DVB: registering new adapter (bttv0).
dst(0) dst_get_device_id: Recognise [DSTMCI]
dst(0) dst_get_device_id: Unsupported
dst(0) dst_check_mb86a15: Found a MB86A15 NIM
DST type flags : 0x1 newtuner 0x1000 VLF 0x10 firmware version = 2
dst(0) dst_get_mac: MAC Address=[00:00:00:00:00:00]
dst(0) dst_get_tuner_info: DST TYpe = MULTI FE
dst(0) dst_fw_ver: Firmware Ver = 1.4 Build = 02, on 11:5, 22-2-2005
dst(0) dst_card_type: Device Model=[VP1032]
dst(0) dst_get_vendor: Vendor=[TWINHAN]
Unable to handle kernel NULL pointer dereference at 00000000000002f0 RIP:
<ffffffff883ede94>{:dvb_bt8xx:dvb_bt8xx_probe+2548}
PGD 6c2c1067 PUD 73f56067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: dst dvb_bt8xx dvb_core bt878 tuner bttv video_buf ir_common compat_ioctl32 btcx_risc tveeprom videodev v4l2_common v4l1_compat dvb_pll ipt_ULOG x_tables autofs4 tun it87 hwmon_vid hwmon eeprom i2c_isa i2c_nforce2 ipv6 snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd_page_alloc snd soundcore af_packet capi capifs kernelcapi bridge ide_cd binfmt_misc isofs loop nls_iso8859_1 nls_cp850 vfat fat evdev dm_mod usbmouse video usbhid thermal fan container button battery ac cpufreq_ondemand cpufreq_conservative cpufreq_powersave powernow_k8 freq_table processor firmware_class i2c_algo_bit i2c_core pcspkr forcedeth kqemu joydev analog gameport ohci1394 ieee1394 ehci_hcd ohci_hcd usbcore reiserfs sd_mod sata_nv libata scsi_mod
Pid: 4211, comm: modprobe Tainted: P      2.6.17.4 #1
RIP: 0010:[<ffffffff883ede94>] <ffffffff883ede94>{:dvb_bt8xx:dvb_bt8xx_probe+2548}
RSP: 0018:ffff81006f0b5e38  EFLAGS: 00010286
RAX: ffff8100716bf018 RBX: ffff81007962a000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8100716bf018 RDI: ffff8100716bf270
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000080
R10: 0000000000000000 R11: ffffffff8011c530 R12: ffff8100717f7800
R13: ffff81007962a0d0 R14: ffff81007962a498 R15: ffff81007962a3c8
FS:  00002aff6d9c06f0(0000) GS:ffffffff80476000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002f0 CR3: 000000006c1d4000 CR4: 00000000000006e0
Process modprobe (pid: 4211, threadinfo ffff81006f0b4000, task ffff81007dff42c0)
Stack: ffff81007962a4b0 ffff81007962a070 0000007176bdc0c0 ffff8100717f7998
       ffff8100717f7800 ffffffff883f0940 ffffffff883f0940 0000000000000000
       0000000000518130 ffffffff8026ce95
Call Trace: <ffffffff8026ce95>{driver_probe_device+101}
       <ffffffff8026d00a>{__driver_attach+122} <ffffffff8026cf90>{__driver_attach+0}
       <ffffffff8026c6f9>{bus_for_each_dev+73} <ffffffff8026c2e8>{bus_add_driver+136}
       <ffffffff80152977>{sys_init_module+199} <ffffffff80109d2a>{system_call+126}

Code: f6 04 25 f0 02 00 00 20 0f 84 ae 01 00 00 48 c7 c7 ae ee 3e
RIP <ffffffff883ede94>{:dvb_bt8xx:dvb_bt8xx_probe+2548} RSP <ffff81006f0b5e38>
CR2: 00000000000002f0


-- 
Cheers,
Mauro

