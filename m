Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbZGPSNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbZGPSNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZGPSNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:13:06 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38560 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835AbZGPSNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:13:02 -0400
Date: Thu, 16 Jul 2009 20:12:56 +0200
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, Greg KH <gregkh@suse.de>
Subject: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release()
	function, it is broken and must be fixed."
Message-ID: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

got this when modprobing and then rmmoding my snd-azt3328 driver.

Then I decided to rmmod another soundcard, snd-als4000,
with the same result.
Trying to exclude any ALSA issues, I then unloaded parport_pc: same
message.

The error happening _before_ module _init() and _after_ module _exit()
clearly points to something outside of an individual driver's control,
i.e. a module core code bug, as hinted by Greg.

x86_32 UP, Debian testing, module-init-tools 3.9-2, git as of yesterday.

Any ideas?

Thanks,

Andreas Mohr

Jul 16 18:57:58 andi kernel: kobject: 'snd_azt3328' (e0d97588): auto cleanup kobject_del
Jul 16 18:57:58 andi kernel: kobject: 'snd_azt3328': free name
Jul 16 18:58:18 andi kernel: kobject: 'snd_azt3328' (e0843148): kobject_add_internal: parent: 'module', set: 'module'
Jul 16 18:58:18 andi kernel: kobject: 'holders' (de254d00): kobject_add_internal: parent: 'snd_azt3328', set: '<NULL>'
Jul 16 18:58:18 andi kernel: kobject: 'snd_azt3328' (e0843148): kobject_uevent_env
Jul 16 18:58:18 andi kernel: kobject: 'snd_azt3328' (e0843148): fill_kobj_path: path = '/module/snd_azt3328'
Jul 16 18:58:18 andi kernel: kobject: 'notes' (de55f8c0): kobject_add_internal: parent: 'snd_azt3328', set: '<NULL>'
Jul 16 18:58:18 andi kernel: --> alsa_card_azf3328_init
Jul 16 18:58:18 andi kernel: kobject: 'AZF3328' (de598b00): kobject_add_internal: parent: 'drivers', set: 'drivers'
Jul 16 18:58:18 andi kernel: --> snd_azf3328_probe
Jul 16 18:58:18 andi kernel: probe started
Jul 16 18:58:18 andi kernel: AZF3328 0000:00:0d.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jul 16 18:58:18 andi kernel: ctrl_io 0xa800, game_io 0xac00, mpu_io 0xb000, opl3_io 0xb400, mixer_io 0xb800, irq 19
Jul 16 18:58:18 andi kernel: game 4f 0c 7e 01 00 00
Jul 16 18:58:18 andi kernel: mpu_io 0x00fe
Jul 16 18:58:18 andi kernel: mpu_io 0x0080
Jul 16 18:58:18 andi kernel: mpu_io 0x0002
Jul 16 18:58:18 andi kernel: mpu_io 0x0000
Jul 16 18:58:18 andi kernel: mpu_io 0x00ff
Jul 16 18:58:18 andi last message repeated 2 times
Jul 16 18:58:18 andi kernel: 0x00: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x01: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x02: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x03: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x04: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x05: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x06: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x07: game200 0x00ff, game208 0x00ff
Jul 16 18:58:18 andi kernel: 0x00: mpu300 0x00ff, mpu310 0x00ff, mpu320 0x00ff, mpu330 0x00ff opl388 0x00ff opl38c 0x00ff
Jul 16 18:58:18 andi kernel: 0x01: mpu300 0x00ff, mpu310 0x00ff, mpu320 0x00ff, mpu330 0x00ff opl388 0x00ff opl38c 0x00ff
Jul 16 18:58:18 andi kernel: ctrl 0x00: 0x0034
Jul 16 18:58:18 andi kernel: ctrl 0x02: 0x0001
Jul 16 18:58:18 andi kernel: ctrl 0x04: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x06: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x08: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x0a: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x0c: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x0e: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x10: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x12: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x14: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x16: 0x0010
Jul 16 18:58:18 andi kernel: ctrl 0x18: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x1a: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x1c: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x1e: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x20: 0x0034
Jul 16 18:58:18 andi kernel: ctrl 0x22: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x24: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x26: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x28: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x2a: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x2c: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x2e: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x30: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x32: 0x0000
Jul 16 18:58:18 andi kernel: ctrl 0x34: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x36: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x38: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x3a: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x3c: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x3e: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x40: 0x0034
Jul 16 18:58:19 andi kernel: ctrl 0x42: 0x0001
Jul 16 18:58:19 andi kernel: ctrl 0x44: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x46: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x48: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x4a: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x4c: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x4e: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x50: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x52: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x54: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x56: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x58: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x5a: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x5c: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x5e: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x60: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x62: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x64: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x66: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x68: 0x03d6
Jul 16 18:58:19 andi kernel: ctrl 0x6a: 0x0001
Jul 16 18:58:19 andi kernel: ctrl 0x6c: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x6e: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x70: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x72: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x74: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x76: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x78: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x7a: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x7c: 0x0000
Jul 16 18:58:19 andi kernel: ctrl 0x7e: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x00: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x02: 0x8000
Jul 16 18:58:19 andi kernel: mixer 0x04: 0x8000
Jul 16 18:58:19 andi kernel: mixer 0x06: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x08: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x0a: 0x8008
Jul 16 18:58:19 andi kernel: mixer 0x0c: 0x8008
Jul 16 18:58:19 andi kernel: mixer 0x0e: 0x8808
Jul 16 18:58:19 andi kernel: mixer 0x10: 0x8808
Jul 16 18:58:19 andi kernel: mixer 0x12: 0x8808
Jul 16 18:58:19 andi kernel: mixer 0x14: 0x8808
Jul 16 18:58:19 andi kernel: mixer 0x16: 0x8808
Jul 16 18:58:19 andi kernel: mixer 0x18: 0x8808
Jul 16 18:58:19 andi kernel: mixer 0x1a: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x1c: 0x8000
Jul 16 18:58:19 andi kernel: mixer 0x1e: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x20: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x22: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x24: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x26: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x28: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x2a: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x2c: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x2e: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x30: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x32: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x34: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x36: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x38: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x3a: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x3c: 0x0000
Jul 16 18:58:19 andi kernel: mixer 0x3e: 0x0000
Jul 16 18:58:19 andi kernel: --> snd_azf3328_mixer_new
Jul 16 18:58:19 andi kernel: <-- snd_azf3328_mixer_new
Jul 16 18:58:19 andi kernel: codec_activity: PLAYBACK codec, enable 0, need_change 1
Jul 16 18:58:19 andi kernel: codec_enable 0
Jul 16 18:58:19 andi kernel: 6AH_update mask 0x0100 do_mask 1: val 0x0100
Jul 16 18:58:19 andi kernel: --> snd_azf3328_codec_setfmt
Jul 16 18:58:19 andi kernel: <-- snd_azf3328_codec_setfmt
Jul 16 18:58:20 andi kernel: codec_activity: CAPTURE codec, enable 0, need_change 1
Jul 16 18:58:20 andi kernel: codec_enable 0
Jul 16 18:58:20 andi kernel: 6AH_update mask 0x0100 do_mask 1: val 0x0100
Jul 16 18:58:20 andi kernel: --> snd_azf3328_codec_setfmt
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_codec_setfmt
Jul 16 18:58:20 andi kernel: codec_activity: I2S_OUT codec, enable 0, need_change 1
Jul 16 18:58:20 andi kernel: codec_enable 0
Jul 16 18:58:20 andi kernel: 6AH_update mask 0x0100 do_mask 1: val 0x0100
Jul 16 18:58:20 andi kernel: --> snd_azf3328_codec_setfmt
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_codec_setfmt
Jul 16 18:58:20 andi kernel: --> snd_azf3328_pcm
Jul 16 18:58:20 andi kernel: t_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 08 is 801e -> vol 00|00 (shift 01|00, mask 0f, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 09, enum_c 2)
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 10 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 10 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:20 andi last message repeated 3 times
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: get: 1c is 8707 -> vol 07|07 (shift 08|00, mask 0f, inv. 0, stereo 1)
Jul 16 18:58:20 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:20 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shifmixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0c is 801f -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 08, enum_c 2)
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 08 is 801e -> vol 00|00 (shift 01|00, mask 0f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 09, enum_c 2)
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:21 andi last message repeated 3 times
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 1c is 8707 -> vol 07|07 (shift 08|00, mask 0f, inv. 0, stereo 1)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 00|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 01|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 10|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 11|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 12|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 14|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 15|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 02|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 03|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 04|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 05|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 07|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 08|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 09|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 04 is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:21 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:21 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 02 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 01|00 (shift 07|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 16 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 15, enum_c 2)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0c is 801f -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 08, enum_c 2)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 08 is 801e -> vol 00|00 (shift 01|00, mask 0f, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 09, enum_c 2)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:22 andi last message repeated 3 times
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1c is 8707 -> vol 07|07 (shift 08|00, mask 0f, inv. 0, stereo 1)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 00|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 01|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 10|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 11|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 12|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 14|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:22 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:22 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 15|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 02|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 03|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 04|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 05|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 07|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 08|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 09|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 04 is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 02 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 20 is 0000 -> vol 01|00 (shift 07|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 16 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 15, enum_c 2)
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0c is 801f -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 08, enum_c 2)
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:23 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:23 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:23 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 08 is 801e -> vol 00|00 (shift 01|00, mask 0f, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 09, enum_c 2)
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:24 andi last message repeated 3 times
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1c is 8707 -> vol 07|07 (shift 08|00, mask 0f, inv. 0, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 00|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 01|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 10|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 11|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 12|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 14|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 15|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 02|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 03|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 04|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 05|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 07|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 08|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 09|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 04 is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 02 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 20 is 0000 -> vol 01|00 (shift 07|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 16 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:24 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:24 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 15, enum_c 2)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0c is 801f -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 08, enum_c 2)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 08 is 801e -> vol 00|00 (shift 01|00, mask 0f, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 09, enum_c 2)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:25 andi last message repeated 3 times
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 1c is 8707 -> vol 07|07 (shift 08|00, mask 0f, inv. 0, stereo 1)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 00|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 01|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 10|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 11|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 12|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 14|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 15|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 02|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 03|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 04|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 05|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 07|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 08|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 09|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:25 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:25 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 04 is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 02 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 02 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 09|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 06 is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 08|00, mask 03, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1e is 0000 -> vol 00|00 (shift 01|00, mask 07, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 20 is 0000 -> vol 01|00 (shift 07|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 16 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 16 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 15, enum_c 2)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 18 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0c is 801f -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 08, enum_c 2)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 08 is 801e -> vol 00|00 (shift 01|00, mask 0f, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 08 is 801e -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 20 is 0000 -> 0|0 (shift 09, enum_c 2)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0c is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0c is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 10 is 0606 -> vol 19|19 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 10 is 0606 -> vol 01|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 12 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 14 is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 08|00, mask 1f, inv. 1, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 0e is 9f1f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get_enum: 1a is 0000 -> 0|0 (shift 00, enum_c 8)
Jul 16 18:58:26 andi last message repeated 3 times
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1c is 8707 -> vol 07|07 (shift 08|00, mask 0f, inv. 0, stereo 1)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 1c is 8707 -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 00|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 01|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 10|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 11|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:26 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 12|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 13|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 14|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 15|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 02|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 03|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 04|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 05|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 06|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 07|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 08|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 20 is 0000 -> vol 00|00 (shift 09|00, mask 01, inv. 0, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 04 is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 04 is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 00|00, mask 1f, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: get: 0a is 801f -> vol 00|00 (shift 15|00, mask 01, inv. 1, stereo 0)
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_get_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_mixer_write_volume_gradually
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_mixer_write_volume_gradually
Jul 16 18:58:27 andi kernel: put: 02 to 18|18, oreg 0606; shift 08|00 -> nreg 0707; after: 0707
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: put: 02 to 01|18, oreg 0707; shift 15|00 -> nreg 0707; after: 0707
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_mixer_write_volume_gradually
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_mixer_write_volume_gradually
Jul 16 18:58:27 andi kernel: put: 02 to 18|18, oreg 0707; shift 08|00 -> nreg 0707; after: 0707
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_info_mixer
Jul 16 18:58:27 andi kernel: --> snd_azf3328_put_mixer
Jul 16 18:58:27 andi kernel: put: 02 to 01|18, oreg 0707; shift 15|00 -> nreg 0707; after: 0707
Jul 16 18:58:27 andi kernel: <-- snd_azf3328_put_mixer
Jul 16 18:59:18 andi kernel: --> alsa_card_azf3328_exit
Jul 16 18:59:18 andi kernel: --> snd_azf3328_remove
Jul 16 18:59:18 andi kernel: --> snd_azf3328_ctrl_timer_stop
Jul 16 18:59:18 andi kernel: <-- snd_azf3328_ctrl_timer_stop
Jul 16 18:59:18 andi kernel: kobject: 'mixer' (dd880008): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'mixer' (dd880008): fill_kobj_path: path = '/class/sound/mixer'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'mixer' (dd880008): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'mixer' (dd880008): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'mixer': free name
Jul 16 18:59:18 andi kernel: kobject: 'dmfm' (dd87fb08): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'dmfm' (dd87fb08): fill_kobj_path: path = '/class/sound/dmfm'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'dmfm' (dd87fb08): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'dmfm' (dd87fb08): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'dmfm': free name
Jul 16 18:59:18 andi kernel: kobject: 'hwC0D0' (d91c9d08): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'hwC0D0' (d91c9d08): fill_kobj_path: path = '/class/sound/hwC0D0'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'hwC0D0' (d91c9d08): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'hwC0D0' (d91c9d08): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'hwC0D0': free name
Jul 16 18:59:18 andi kernel: kobject: 'adsp' (dd87f708): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'adsp' (dd87f708): fill_kobj_path: path = '/class/sound/adsp'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'adsp' (dd87f708): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'adsp' (dd87f708): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'adsp': free name
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D1p' (dd87f908): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D1p' (dd87f908): fill_kobj_path: path = '/class/sound/pcmC0D1p'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D1p' (dd87f908): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D1p' (dd87f908): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D1p': free name
Jul 16 18:59:18 andi kernel: kobject: 'dsp' (de271008): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'dsp' (de271008): fill_kobj_path: path = '/class/sound/dsp'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'dsp' (de271008): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'dsp' (de271008): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'dsp': free name
Jul 16 18:59:18 andi kernel: kobject: 'audio' (de271e08): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'audio' (de271e08): fill_kobj_path: path = '/class/sound/audio'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'audio' (de271e08): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'audio' (de271e08): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'audio': free name
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0p' (dd87ff08): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0p' (dd87ff08): fill_kobj_path: path = '/class/sound/pcmC0D0p'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0p' (dd87ff08): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0p' (dd87ff08): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0p': free name
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0c' (de271f08): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0c' (de271f08): fill_kobj_path: path = '/class/sound/pcmC0D0c'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0c' (de271f08): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0c' (de271f08): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'pcmC0D0c': free name
Jul 16 18:59:18 andi kernel: kobject: 'midi' (de271108): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'midi' (de271108): fill_kobj_path: path = '/class/sound/midi'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'midi' (de271108): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'midi' (de271108): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'midi': free name
Jul 16 18:59:18 andi kernel: kobject: 'dmmidi' (dd880608): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'dmmidi' (dd880608): fill_kobj_path: path = '/class/sound/dmmidi'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'dmmidi' (dd880608): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'dmmidi' (dd880608): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'dmmidi': free name
Jul 16 18:59:18 andi kernel: kobject: 'midiC0D0' (de271c08): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'midiC0D0' (de271c08): fill_kobj_path: path = '/class/sound/midiC0D0'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'midiC0D0' (de271c08): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'midiC0D0' (de271c08): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'midiC0D0': free name
Jul 16 18:59:18 andi kernel: kobject: 'controlC0' (dd880208): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'controlC0' (dd880208): fill_kobj_path: path = '/class/sound/controlC0'
Jul 16 18:59:18 andi kernel: kobject: '0000:00:0d.0' (dfa09060): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0'
Jul 16 18:59:18 andi kernel: kobject: 'controlC0' (dd880208): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'controlC0' (dd880208): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'controlC0': free name
Jul 16 18:59:18 andi kernel: --> snd_azf3328_ctrl_timer_stop
Jul 16 18:59:18 andi kernel: <-- snd_azf3328_ctrl_timer_stop
Jul 16 18:59:18 andi kernel: kobject: 'gameport1' (dd8d4140): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'gameport1' (dd8d4140): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0d.0/gameport1'
Jul 16 18:59:18 andi kernel: kobject: 'gameport1' (dd8d4140): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'gameport1' (dd8d4140): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'gameport1': free name
Jul 16 18:59:18 andi kernel: AZF3328 0000:00:0d.0: PCI INT A disabled
Jul 16 18:59:18 andi kernel: <-- snd_azf3328_remove
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328' (de598b00): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328' (de598b00): auto cleanup 'remove' event
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328' (de598b00): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328' (de598b00): fill_kobj_path: path = '/bus/pci/drivers/AZF3328'
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328' (de598b00): auto cleanup kobject_del
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328' (de598b00): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: 'AZF3328': free name
Jul 16 18:59:18 andi kernel: <-- alsa_card_azf3328_exit
Jul 16 18:59:18 andi kernel: kobject: 'notes' (de55f8c0): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'notes' (de55f8c0): auto cleanup kobject_del
Jul 16 18:59:18 andi kernel: kobject: 'notes' (de55f8c0): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: (de55f8c0): dynamic_kobj_release
Jul 16 18:59:18 andi kernel: kobject: 'notes': free name
Jul 16 18:59:18 andi kernel: kobject: 'drivers' (d79797c0): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'drivers' (d79797c0): auto cleanup kobject_del
Jul 16 18:59:18 andi kernel: kobject: 'drivers' (d79797c0): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: (d79797c0): dynamic_kobj_release
Jul 16 18:59:18 andi kernel: kobject: 'drivers': free name
Jul 16 18:59:18 andi kernel: kobject: 'holders' (de254d00): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'holders' (de254d00): auto cleanup kobject_del
Jul 16 18:59:18 andi kernel: kobject: 'holders' (de254d00): calling ktype release
Jul 16 18:59:18 andi kernel: kobject: (de254d00): dynamic_kobj_release
Jul 16 18:59:18 andi kernel: kobject: 'holders': free name
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328' (e0843148): kobject_cleanup
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328' (e0843148): does not have a release() function, it is broken and must be fixed.
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328' (e0843148): auto cleanup 'remove' event
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328' (e0843148): kobject_uevent_env
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328' (e0843148): fill_kobj_path: path = '/module/snd_azt3328'
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328' (e0843148): auto cleanup kobject_del
Jul 16 18:59:18 andi kernel: kobject: 'snd_azt3328': free name




Jul 16 19:22:44 andi kernel: kobject: 'snd_als4000' (e0db89e8):
kobject_cleanup
Jul 16 19:22:44 andi kernel: kobject: 'snd_als4000' (e0db89e8): does not
have a 
release() function, it is broken and must be fixed.




Jul 16 19:23:43 andi kernel: kobject: 'parport_pc' (e0f30648):
kobject_cleanup
Jul 16 19:23:43 andi kernel: kobject: 'parport_pc' (e0f30648): does not
have a r
elease() function, it is broken and must be fixed.
