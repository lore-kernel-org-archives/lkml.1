Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXCANWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXCANWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXCANWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:22:49 -0500
Received: from web52905.mail.yahoo.com ([206.190.49.15]:31985 "HELO
	web52905.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752277AbXCANWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:22:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sWS8emGUl+GRMnk2JrGQVcZ3BPIKPorpwvOsdrPi4eT1JaUPARAFDr7Hyj7X1Abv54NNQGJiQX+LmmCiXm0Bsa1UvIJmRuoNu6JzgKM78AmPCBNtOoXG7xDUr3ewKpYofjILXZzpaZm58P8ZyQA2cn5GmTxgoCzsaFJ4rmwyEco=;
X-YMail-OSG: YvhCGYkVM1nEJlxaB_EG1HyWtVRNvU6KvHL6Nat1zj2twPnq_nnZikrTiJZWcznNqgcWsIbzeHLGQgYcaPZ31_rZ5Dp.jxW2QBWMGgisLrd7ek1edVpYKz8kBafk5aYa9vs2eXrTa8E-
Date: Thu, 1 Mar 2007 13:22:46 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [Alsa-devel] [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Takashi Iwai <tiwai@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703011330330.29829@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <5749.60103.qm@web52905.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Please apply this patch to your kernel and try to reproduce:

Ta-DA!!!!!!!!!!!!!!!!!!!!

BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
c0130113
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
last sysfs file: /class/net/eth2/statistics/collisions
Modules linked in: snd_rtctimer radeon drm pwc eeprom cpufreq_ondemand p4_clockmod speedstep_lib
nfsd exportfs ipv6 autofs4 nfs lockd sunrpc af_packet firmware_class binfmt_misc video thermal
processor fan button video1394 raw1394 ac lp parport_pc parport nvram eth1394 compat_ioctl32
videodev v4l2_common v4l1_compat snd_usb_audio snd_usb_lib sd_mod sg snd_emu10k1_synth
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec ohci1394
ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event ieee1394 snd_seq snd_pcm_oss sata_sil
ehci_hcd uhci_hcd snd_mixer_oss libata e7xxx_edac edac_mc snd_pcm e1000 i2c_i801 i2c_core ide_cd
intel_agp agpgart serio_raw psmouse scsi_mod snd_seq_device snd_timer snd_page_alloc snd_util_mem
snd_hwdep snd soundcore cdrom pcspkr usbcore ext3 jbd
CPU:    1
EIP:    0060:[<c0130113>]    Not tainted VLI
EFLAGS: 00010202   (2.6.20.1 #3)
EIP is at module_put+0x20/0x52
eax: 6b6b6d6b   ebx: 6b6b6b6b   ecx: 00000001   edx: e0049000
esi: f60f7b08   edi: 6b6b6b6b   ebp: ebc14e0c   esp: e0049f58
ds: 007b   es: 007b   ss: 0068
Process udevd (pid: 7608, ti=e0049000 task=f7e6b030 task.ti=e0049000)
Stack: f7898edc c0183a5b 00000010 ed5bbb7c eccd0978 c0151253 00000000 00000000
       f7ff2208 ed5bbb7c f75b5360 00000000 ed5bbb7c c014ed90 00000003 00000003
       f75b5360 f75b53e0 c014fd89 00000003 00000007 00000003 e0049000 c0102bce
Call Trace:
 [<c0183a5b>] sysfs_release+0x2d/0x4c
 [<c0151253>] __fput+0x96/0x13c
 [<c014ed90>] filp_close+0x51/0x58
 [<c014fd89>] sys_close+0x70/0xa7
 [<c0102bce>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x6b3/0x965
 =======================
Code: 00 89 f0 83 c4 0c 5b 5e 5f 5d c3 53 89 c3 85 c0 74 49 b8 01 00 00 00 e8 5f 49 fe ff e8 3b 5b
07 00 c1 e0 07 8d 84 18 80 01 00 00 <ff> 08 83 3b 02 75 0b 8b 83 88 05 00 00 e8 a9 45 fe ff b8 01
00
EIP: [<c0130113>] module_put+0x20/0x52 SS:ESP 0068:e0049f58
 <6>note: udevd[7608] exited with preempt_count 1
BUG: scheduling while atomic: udevd/0x10000001/7608
 [<c026f9d6>] __sched_text_start+0x56/0x965
 [<c011cc72>] irq_exit+0x37/0x42
 [<c010d1d7>] smp_apic_timer_interrupt+0x70/0x79
 [<c010369c>] apic_timer_interrupt+0x28/0x30
 [<c0114b01>] __cond_resched+0x12/0x2c
 [<c02708e9>] cond_resched+0x26/0x31
 [<c01404d2>] unmap_vmas+0x3d3/0x4df
 [<c0142cf5>] exit_mmap+0x7e/0x10a
 [<c0116bd7>] mmput+0x1d/0x78
 [<c011b322>] do_exit+0x1b2/0x6d8
 [<c011007b>] sys_vm86+0x99/0x21d
 [<c01040fc>] die+0x1f7/0x21c
 [<c011180e>] do_page_fault+0x442/0x510
 [<c01113cc>] do_page_fault+0x0/0x510
 [<c027230c>] error_code+0x7c/0x84
 [<c0130113>] module_put+0x20/0x52
 [<c0183a5b>] sysfs_release+0x2d/0x4c
 [<c0151253>] __fput+0x96/0x13c
 [<c014ed90>] filp_close+0x51/0x58
 [<c014fd89>] sys_close+0x70/0xa7
 [<c0102bce>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x6b3/0x965
 =======================

I would never have guessed THAT one :-) !!

Cheers,
Chris



		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
