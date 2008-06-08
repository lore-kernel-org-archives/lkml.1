Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYFHNTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYFHNTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYFHNSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:18:55 -0400
Received: from fb05-01.mta.terra.com.br ([200.154.152.90]:58763 "EHLO
	fb05-01.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYFHNSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:18:54 -0400
X-Greylist: delayed 1607 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 09:18:54 EDT
X-Terra-Karma: -2%
X-Terra-Hash: 187936a55da89b34bd1242f248ab22ae
Date: Sun, 8 Jun 2008 09:51:19 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24.7-rt13 Oops
Message-ID: <20080608125119.GS28755@unix.sh>
References: <1212723195.24785.40.camel@localhost.localdomain> <484BA2E3.9010305@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484BA2E3.9010305@cfl.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 05:14:11AM -0400, Mark Hounschell wrote:
> BUG: unable to handle kernel paging request at virtual address 00656c0c

It seems like you have just found a buffer overflow in vsnprintf... as the
requested address was "el\n" :)

I wonder where do this data came from. Could you please send us the log
lines around this oops? I have the impression something was printed right
before the oops.

Luis

> printing eip: c01cb82e *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: lp af_packet appletalk ax25 ipx p8023 udf ip6t_LOG 
> nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss 
> snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state 
> iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle 
> nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter ip6_tables 
> x_tables ipv6 fuse loop dm_mod snd_hda_intel snd_pcm snd_timer rtc_cmos snd 
> rtc_core osst ati_agp i2c_piix4 e1000 ide_cd soundcore parport_pc agpgart 
> rtc_lib cdrom sky2 k8temp snd_page_alloc st hwmon i2c_core parport ide_disk 
> sg ehci_hcd ohci_hcd usbcore ssb sd_mod edd ext3 mbcache jbd aic7xxx 
> scsi_transport_spi pata_jmicron atiixp ide_core ahci libata scsi_mod
>
> Pid: 9661, comm: v27 Not tainted (2.6.24.7-rt13 #3)
> EIP: 0060:[<c01cb82e>] EFLAGS: 00210097 CPU: 1
> EIP is at strnlen+0x6/0x18
> EAX: 00656c0c EBX: 00656c0c ECX: 00656c0c EDX: fffffffe
> ESI: c03c605c EDI: ebb2fdb0 EBP: ffffffff ESP: ebb2fccc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 preempt:00000002
> Process v27 (pid: 9661, ti=ebb2e000 task=f3ca1810 task.ti=ebb2e000)
> Stack: c01caf08 00200246 c0177fb3 f3c22b40 ebb2fd54 c4835a70 c4835a6c 
> 00000400
>        c03c604c c01c6572 c03c644c 00000000 ffffffff f4f573b6 00000400 
> 00656c0c
>        f325a9e0 c03c604c c01cb170 ebb2fda8 f4f5739c c011b8fd ebb2fda8 
> 00000b61
> Call Trace:
>  [<c01caf08>] vsnprintf+0x29d/0x46a
>  [<c0177fb3>] dput+0x2c/0xff
>  [<c01c6572>] __next_cpu+0x12/0x21
>  [<c01cb170>] vscnprintf+0x14/0x20
>  [<c011b8fd>] vprintk+0xdc/0x2c8
>  [<c010309a>] __switch_to+0x15/0x11f
>  [<c02b5505>] __spin_unlock+0xc/0x20
>  [<c011698b>] finish_task_switch+0x26/0x83
>  [<c011bb04>] printk+0x1b/0x1f
>  [<f4f4cf18>] ahc_linux_queue_recovery_cmd+0x6f/0x982 [aic7xxx]
>  [<c012e02e>] lock_hrtimer_base+0x15/0x2f
>  [<c01659a8>] kmem_cache_alloc+0x7d/0xb1
>  [<f4f4d839>] ahc_linux_dev_reset+0xe/0x2a [aic7xxx]
>  [<f482c801>] scsi_try_bus_device_reset+0x1d/0x3c [scsi_mod]
>  [<f482e152>] scsi_reset_provider+0x98/0x12a [scsi_mod]
>  [<c0159a52>] find_extend_vma+0x12/0x49
>  [<c0133aa8>] get_futex_key+0x6e/0x122
>  [<c0133e37>] futex_wait+0x1fc/0x2dc
>  [<c0134226>] futex_wahke+0xb8/0xc2
>  [<c0134dd0>] do_futex+0x7a/0x9eb
>  [<c012d99f>] hrtimer_forward+0xba/0xd0
>  [<f4e6c660>] sg_ioctl+0x8d3/0x9dd [sg]
>  [<c02b5505>] __spin_unlock+0xc/0x20
>  [<c01301d6>] getnstimeofday+0x2b/0xb2
>  [<c02b422f>] rt_mutex_lock+0x15/0x3f
>  [<c0137d4c>] rt_down+0xe/0x26
>  [<c017307c>] do_ioctl+0x4c/0x62
>  [<c01732c9>] vfs_ioctl+0x237/0x249
>  [<c0173320>] sys_ioctl+0x45/0x5d
>  [<c010402a>] sysenter_past_esp+0x5f/0x85
>  =======================
> ---------------------------
> | preempt count: 00000002 ]
> | 2-level deep critical section nesting:
> ----------------------------------------
> .. [<c011b832>] .... vprintk+0x11/0x2c8
> .....[<00000000>] ..   ( <= _stext+0x3feff000/0x14)
> .. [<c02b515e>] .... __spin_lock+0xd/0x23
> .....[<00000000>] ..   ( <= _stext+0x3feff000/0x14)
>
> Code: c9 74 0c f2 ae 74 05 bf 01 00 00 00 4f 89 fa 5f 89 d0 c3 85 c9 57 89 
> c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f c3 89 c1 89 c8 eb 06 <80> 38 00 74 
> 07 40 4a 83 fa ff 75 f4 29 c8 c3 90 90 90 57 83 c9
> EIP: [<c01cb82e>] strnlen+0x6/0x18 SS:ESP 0068:ebb2fccc
> ---[ end trace a30b09d6b0410b5f ]---
> note: v27[9661] exited with preempt_count 1
>
>
> What causes it:
>
>     rst_command = SG_SCSI_RESET_DEVICE;
>     if (ioctl(Q->DevSpec1, SG_SCSI_RESET, &rst_command) < 0)
>             perror("gen_rst: Scsi Device Reset");
>
>
> Regards
> Mark
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

-- 
[ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

