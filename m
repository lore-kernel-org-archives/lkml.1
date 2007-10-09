Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXJINJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXJINJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 09:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXJINJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 09:09:28 -0400
Received: from mail.syneticon.net ([213.239.212.131]:48528 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbXJINJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:09:27 -0400
Message-ID: <470B7D7E.5070901@wpkg.org>
Date: Tue, 09 Oct 2007 15:09:18 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, nickpiggin@yahoo.com.au,
       kernel@nn7.de
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:

>> Fixing recursive fault but reboot is needed!
> 
> Hmmhh, so now I rebooted and again tried to
> 
> $ make
> 
> the new kernel which again triggered this(?) BUG:

I had a similar issue with 2.6.22.9, but as I had a proprietary nvidia 
module loaded, I didn't report it. X was not enabled, though.

At this moment, the machine was spawning quite a bit of bash / awk etc. 
processes with large variables (50 MB or so), and used memory and CPU a lot.

Normally, it's my desktop machine, and it's rarely on for more than ~12 
hours, but this time, I left it on for a couple of days.

After this happened, these bash / awk processes died. After I restarted 
the script again, I lost ssh access to the machine, and I saw no more 
entries in the syslog. The machine was pingable though, and had it's 
network sockets still open (I could telnet to ssh port).
I used SysRq to reboot the machine.



Oct  3 10:14:09 tomek kernel: Eeek! page_mapcount(page) went negative! (-1)
Oct  3 10:14:09 tomek kernel:   page pfn = 13aa
Oct  3 10:14:10 tomek kernel:   page->flags = 40000400
Oct  3 10:14:10 tomek kernel:   page->count = 1
Oct  3 10:14:10 tomek kernel:   page->mapping = 00000000
Oct  3 10:14:10 tomek kernel:   vma->vm_ops = 0x0
Oct  3 10:14:10 tomek kernel: ------------[ cut here ]------------
Oct  3 10:14:10 tomek syslogd: /dev/tty12: Interrupted system call
Oct  3 10:14:10 tomek kernel: kernel BUG at mm/rmap.c:628!
Oct  3 10:14:10 tomek kernel: invalid opcode: 0000 [#1]
Oct  3 10:14:10 tomek kernel: PREEMPT
Oct  3 10:14:10 tomek kernel: Modules linked in: nvidia(P) iptable_nat 
nf_nat ipt_ULOG ipt_recent af_packet nf_conntrack_ipv4 xt_state 
nf_conntrack nfnetli
nk ipt_REJECT xt_tcpudp iptable_filter ip_tables snd_seq_dummy x_tables 
snd_seq_oss snd_seq_midi_event snd_seq usblp loop dm_mod video thermal 
sbs fan cont
ainer dock battery ac floppy cpufreq_conservative cpufreq_powersave 
processor snd_pcm_oss snd_mixer_oss snd_via82xx snd_ac97_codec ac97_bus 
snd_pcm snd_tim
er snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd 
soundcore ehci_hcd i2c_viapro i2c_core via_rhine uhci_hcd tsdev evdev 
usbcore via_agp agpg
art 8139cp 8139too mii sg
Oct  3 10:14:10 tomek kernel: CPU:    0
Oct  3 10:14:10 tomek kernel: EIP:    0060:[<c015a434>]    Tainted: P 
     VLI
Oct  3 10:14:10 tomek kernel: EFLAGS: 00010246   (2.6.22.9-3 #1)
Oct  3 10:14:10 tomek kernel: EIP is at page_remove_rmap+0xd7/0x105
Oct  3 10:14:10 tomek kernel: eax: 00000000   ebx: c1027540   ecx: 
e8a2e000   edx: 00000002
Oct  3 10:14:10 tomek kernel: esi: c4226f20   edi: c3ab828c   ebp: 
e8a2fea4   esp: e8a2fe94
Oct  3 10:14:10 tomek kernel: ds: 007b   es: 007b   fs: 0000  gs: 0000 
ss: 0068
Oct  3 10:14:10 tomek kernel: Process bash (pid: 28682, ti=e8a2e000 
task=db280000 task.ti=e8a2e000)
Oct  3 10:14:10 tomek kernel: Stack: c0346d1d 00000000 c1027540 0b4a3000 
e8a2ff00 c0154edc e8a2e000 28b98fff
Oct  3 10:14:10 tomek kernel:        013aaa80 00000000 c4226f20 e8a2ff18 
00000001 00000000 00000000 0b800000
Oct  3 10:14:10 tomek kernel:        c21330b4 c21330b4 d896d780 c03f2200 
00000000 ffffffff 28b99000 00000000
Oct  3 10:14:10 tomek kernel: Call Trace:
Oct  3 10:14:10 tomek kernel:  [<c0104d19>] show_trace_log_lvl+0x1a/0x2f
Oct  3 10:14:10 tomek kernel:  [<c0104dc9>] show_stack_log_lvl+0x9b/0xa3
Oct  3 10:14:10 tomek kernel:  [<c0104fa8>] show_registers+0x1d7/0x30c
Oct  3 10:14:10 tomek kernel:  [<c01051db>] die+0xfe/0x1d6
Oct  3 10:14:10 tomek kernel:  [<c02be0af>] do_trap+0x89/0xa2
Oct  3 10:14:10 tomek kernel:  [<c0105605>] do_invalid_op+0x88/0x92
Oct  3 10:14:10 tomek kernel:  [<c02bde8a>] error_code+0x6a/0x70
Oct  3 10:14:10 tomek kernel:  [<c0154edc>] unmap_vmas+0x236/0x425
Oct  3 10:14:10 tomek kernel:  [<c0157a49>] exit_mmap+0x68/0xf0
Oct  3 10:14:10 tomek kernel:  [<c0117553>] mmput+0x1e/0x88
Oct  3 10:14:10 tomek kernel:  [<c011aa52>] exit_mm+0xbb/0xc1
Oct  3 10:14:10 tomek kernel:  [<c011be51>] do_exit+0x1f0/0x720
Oct  3 10:14:12 tomek kernel:  [<c011c3ef>] sys_exit_group+0x0/0x11
Oct  3 10:14:12 tomek kernel:  [<c011c3fe>] sys_exit_group+0xf/0x11
Oct  3 10:14:12 tomek kernel:  [<c0103da2>] sysenter_past_esp+0x5f/0x99
Oct  3 10:14:12 tomek kernel:  =======================
Oct  3 10:14:12 tomek kernel: Code: c0 74 0d 8b 50 08 b8 4d 6d 34 c0 e8 
ea 0f fe ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 6c 6d 
34 c0 e8 cf
  0f fe ff <0f> 0b eb fe 8b 53 10 8b 03 83 e2 01 c1 e8 1e f7 da 83 c2 04 69
Oct  3 10:14:12 tomek kernel: EIP: [<c015a434>] 
page_remove_rmap+0xd7/0x105 SS:ESP 0068:e8a2fe94
Oct  3 10:14:12 tomek kernel: Fixing recursive fault but reboot is needed!
Oct  3 10:14:12 tomek kernel: BUG: scheduling while atomic: 
bash/0x00000002/28682
Oct  3 10:14:12 tomek kernel: INFO: lockdep is turned off.
Oct  3 10:14:12 tomek kernel:  [<c0104d19>] show_trace_log_lvl+0x1a/0x2f
Oct  3 10:14:12 tomek kernel:  [<c01057b1>] show_trace+0x12/0x14
Oct  3 10:14:12 tomek kernel:  [<c0105837>] dump_stack+0x15/0x17
Oct  3 10:14:12 tomek kernel:  [<c02baf0e>] __sched_text_start+0x6e/0x5d5
Oct  3 10:14:12 tomek kernel:  [<c011bd52>] do_exit+0xf1/0x720
Oct  3 10:14:12 tomek kernel:  [<c01052ab>] die+0x1ce/0x1d6
Oct  3 10:14:12 tomek kernel:  [<c02be0af>] do_trap+0x89/0xa2
Oct  3 10:14:12 tomek kernel:  [<c0105605>] do_invalid_op+0x88/0x92
Oct  3 10:14:12 tomek kernel:  [<c02bde8a>] error_code+0x6a/0x70
Oct  3 10:14:12 tomek kernel:  [<c0154edc>] unmap_vmas+0x236/0x425
Oct  3 10:14:12 tomek kernel:  [<c0157a49>] exit_mmap+0x68/0xf0
Oct  3 10:14:12 tomek kernel:  [<c0117553>] mmput+0x1e/0x88
Oct  3 10:14:12 tomek kernel:  [<c011aa52>] exit_mm+0xbb/0xc1
Oct  3 10:14:12 tomek kernel:  [<c011be51>] do_exit+0x1f0/0x720
Oct  3 10:14:12 tomek kernel:  [<c011c3ef>] sys_exit_group+0x0/0x11
Oct  3 10:14:12 tomek kernel:  [<c011c3fe>] sys_exit_group+0xf/0x11
Oct  3 10:14:12 tomek kernel:  [<c0103da2>] sysenter_past_esp+0x5f/0x99
Oct  3 10:14:12 tomek kernel:  =======================



-- 
Tomasz Chmielewski
http://blog.wpkg.org
