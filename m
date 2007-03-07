Return-Path: <linux-kernel-owner+w=401wt.eu-S2992735AbXCGX3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992735AbXCGX3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992732AbXCGX3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:29:11 -0500
Received: from web52909.mail.yahoo.com ([206.190.49.19]:39071 "HELO
	web52909.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992735AbXCGX3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:29:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=aeO3r9w7Hzxw/HAmUvzbCDbr5iv3NwdYAe1oh3PGUe6ARC5MCEjOyRvj0F5TARXEweZrZgUVKDAZg8yKpHQRqkZ17Vc4J58VJd7GFfF2WlnBc8jxnQIosdAh96Zmn9WG7pbWBSzKHcfBf75vlj3qpuDv9m7zhfeFD9OAwMsriwo=;
X-YMail-OSG: EuBFzF0VM1n4MGYiL_ARP_belJH3OrJ1orfnIc0MguV68cLHFqcz5qqullMBCWqGjZzi5OkvWoNQ_dpPNCnNXSucPqGOOp8RSHSTVQloqEhzrIsx9tAeErbWYenQCwF4
Date: Wed, 7 Mar 2007 23:29:07 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703011330330.29829@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <982669.87281.qm@web52909.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Please apply this patch to your kernel and try to reproduce:
>
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/gregkh-driver-sysfs-crash-debugging.patch
> 
> It should give us a better clue which sysfs file is causing the oops.

And again, except with a completely different sysfs file this time. It looks like it's Wine rather
than WoW that is triggering this - all I did was execute "winecfg" this time:

BUG: unable to handle kernel paging request at virtual address 6b6b6deb
 printing eip:
c0130113
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
last sysfs file: /class/usb_endpoint/usbdev1.3_ep84/dev
Modules linked in: radeon drm pwc eeprom cpufreq_ondemand p4_clockmod speedstep_lib nfsd exportfs
ipv6 autofs4 nfs lockd sunrpc af_packet firmware_class binfmt_misc video thermal processor fan
button ac lp parport_pc parport nvram video1394 raw1394 eth1394 sd_mod sg compat_ioctl32 videodev
v4l2_common v4l1_compat snd_usb_audio snd_usb_lib snd_emu10k1_synth snd_emux_synth snd_seq_virmidi
snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus ohci1394 snd_seq_dummy
snd_seq_oss snd_seq_midi_event ieee1394 snd_seq e1000 sata_sil snd_pcm_oss snd_mixer_oss ehci_hcd
snd_pcm uhci_hcd libata e7xxx_edac serio_raw snd_seq_device snd_timer snd_page_alloc snd_util_mem
snd_hwdep snd soundcore scsi_mod edac_mc ide_cd psmouse intel_agp i2c_i801 i2c_core agpgart cdrom
pcspkr usbcore ext3 jbd
CPU:    2
EIP:    0060:[<c0130113>]    Not tainted VLI
EFLAGS: 00010206   (2.6.20.1 #3)
EIP is at module_put+0x20/0x52
eax: 6b6b6deb   ebx: 6b6b6b6b   ecx: 00000001   edx: e8b24000
esi: ed7667b0   edi: 6b6b6b6b   ebp: e88b162c   esp: e8b24f58
ds: 007b   es: 007b   ss: 0068
Process udevd (pid: 4457, ti=e8b24000 task=f7fa6560 task.ti=e8b24000)
Stack: e8b39640 c0183a5b 00000010 ed4a2cb4 e9cf2978 c0151253 00000000 00000000
       f7ff2208 ed4a2cb4 f787e678 00000000 ed4a2cb4 c014ed90 00000003 00000003
       f787e678 f787e6f8 c014fd89 00000003 00000007 00000003 e8b24000 c0102bce
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
EIP: [<c0130113>] module_put+0x20/0x52 SS:ESP 0068:e8b24f58
 <6>note: udevd[4457] exited with preempt_count 1
BUG: scheduling while atomic: udevd/0x10000001/4457
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




		
___________________________________________________________ 
All New Yahoo! Mail – Tired of unwanted email come-ons? Let our SpamGuard protect you. http://uk.docs.yahoo.com/nowyoucan.html
