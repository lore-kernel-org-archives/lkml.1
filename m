Return-Path: <linux-kernel-owner+w=401wt.eu-S1767835AbXCJOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767835AbXCJOJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 09:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767838AbXCJOJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 09:09:45 -0500
Received: from web52911.mail.yahoo.com ([206.190.49.21]:32598 "HELO
	web52911.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767835AbXCJOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 09:09:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0l+t/R/SEexFkOl8cGEecEag9P/3E2jEeDpObMDaHNKuyDpdcHlVepA8nt11RsTy7nYACqUrwVNlC/CZayBYhDCObXohlK0vS+twMIxA8TraTnhVMTRfGcgW7c2yHJ0fSP/mj9/FryFnbSexHDWAdOXJiFYTkJquFEvsGrHGSeE=;
X-YMail-OSG: VRLD6f8VM1nD0siy9NE._12vq.AL0lYFAe2Zca82.VniCfOQ_l6UCa00PcD0ZdKJHMIdivaStO7FLT20St0GvL.VUVStFJXAcsMcTPdlim2.jG0mpba6GzRYVFrzAa9HvMSqO5_wjd27_ZNFLuBmPIMyaQ--
Date: Sat, 10 Mar 2007 14:09:43 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <170606.12059.qm@web52911.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like 2.6.20.2 is still doing Bad Things in /sys.

Cheers,
Chris

BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
c01300ff
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
Modules linked in: radeon drm pwc eeprom cpufreq_ondemand p4_clockmod speedstep_lib nfsd exportfs
ipv6 autofs4 nfs lockd sunrpc af_packet firmware_class binfmt_misc video thermal processor fan
button ac lp parport_pc parport nvram video1394 raw1394 eth1394 snd_usb_audio compat_ioctl32
videodev v4l2_common snd_usb_lib v4l1_compat sd_mod sg snd_emu10k1_synth snd_emux_synth
snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_seq_dummy
ohci1394 snd_seq_oss snd_seq_midi_event ieee1394 snd_seq ehci_hcd sata_sil snd_pcm_oss
snd_mixer_oss libata snd_pcm uhci_hcd e1000 serio_raw scsi_mod snd_seq_device snd_timer
snd_page_alloc snd_util_mem snd_hwdep pcspkr psmouse snd soundcore e7xxx_edac edac_mc ide_cd cdrom
i2c_i801 i2c_core intel_agp agpgart usbcore ext3 jbd
CPU:    1
EIP:    0060:[<c01300ff>]    Not tainted VLI
EFLAGS: 00010202   (2.6.20.2 #1)
EIP is at module_put+0x20/0x52
eax: 6b6b6d6b   ebx: 6b6b6b6b   ecx: 00000001   edx: e7a01000
esi: edb7e4e4   edi: 6b6b6b6b   ebp: e79fd50c   esp: e7a01f58
ds: 007b   es: 007b   ss: 0068
Process udevd (pid: 9656, ti=e7a01000 task=f7a46030 task.ti=e7a01000)
Stack: eba628a0 c0183a1e 00000010 ed570870 e7a641d0 c0151263 00000000 00000000
       f7ff2208 ed570870 f745b678 00000000 ed570870 c014eda0 00000003 00000003
       f745b678 f745b6f8 c014fd99 00000003 00000007 00000003 e7a01000 c0102bde
Call Trace:
 [<c0183a1e>] sysfs_release+0x2d/0x4c
 [<c0151263>] __fput+0x96/0x13c
 [<c014eda0>] filp_close+0x51/0x58
 [<c014fd99>] sys_close+0x70/0xa7
 [<c0102bde>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x613/0x971
 =======================
Code: 00 89 f0 83 c4 0c 5b 5e 5f 5d c3 53 89 c3 85 c0 74 49 b8 01 00 00 00 e8 77 49 fe ff e8 0f 5b
07 00 c1 e0 07 8d 84 18 80 01 00 00 <ff> 08 83 3b 02 75 0b 8b 83 88 05 00 00 e8 c1 45 fe ff b8 01
00
EIP: [<c01300ff>] module_put+0x20/0x52 SS:ESP 0068:e7a01f58
 <6>note: udevd[9656] exited with preempt_count 1
BUG: scheduling while atomic: udevd/0x10000001/9656
 [<c026fa76>] __sched_text_start+0x56/0x971
 [<c01a45de>] vsnprintf+0x44e/0x48c
 [<c0123af4>] atomic_notifier_call_chain+0x40/0x46
 [<c010dc9c>] nmi_watchdog_tick+0x5e/0x1ee
 [<c01123ba>] __wake_up_locked+0x1f/0x21
 [<c0114b05>] __cond_resched+0x12/0x2c
 [<c0270995>] cond_resched+0x26/0x31
 [<c01404e2>] unmap_vmas+0x3d3/0x4df
 [<c0142d05>] exit_mmap+0x7e/0x10a
 [<c0116bcb>] mmput+0x1d/0x78
 [<c011b316>] do_exit+0x1b2/0x6d8
 [<c011007b>] sys_vm86+0x95/0x21d
 [<c0104107>] die+0x1f2/0x217
 [<c0111812>] do_page_fault+0x442/0x510
 [<c01113d0>] do_page_fault+0x0/0x510
 [<c02723bc>] error_code+0x7c/0x84
 [<c01300ff>] module_put+0x20/0x52
 [<c0183a1e>] sysfs_release+0x2d/0x4c
 [<c0151263>] __fput+0x96/0x13c
 [<c014eda0>] filp_close+0x51/0x58
 [<c014fd99>] sys_close+0x70/0xa7
 [<c0102bde>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x613/0x971
 =======================


		
___________________________________________________________ 
What kind of emailer are you? Find out today - get a free analysis of your email personality. Take the quiz at the Yahoo! Mail Championship. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
