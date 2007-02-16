Return-Path: <linux-kernel-owner+w=401wt.eu-S1422817AbXBPARJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbXBPARJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422816AbXBPARJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:17:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817AbXBPARG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:17:06 -0500
Date: Thu, 15 Feb 2007 16:16:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.20-mm1
Message-Id: <20070215161650.2e9ca8a8.akpm@linux-foundation.org>
In-Reply-To: <45D4EBB3.2060800@googlemail.com>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D47020.1010309@googlemail.com>
	<20070215140232.0aba86a7.akpm@linux-foundation.org>
	<45D4EBB3.2060800@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 00:24:35 +0100
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton napisa__(a):
> > On Thu, 15 Feb 2007 15:37:20 +0100
> > Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > 
> >> Andrew Morton napisa__(a):
> >>> Temporarily at
> >>>
> >>>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> >>>
> >>> Will appear later at
> >>>
> >>>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/
> >>>
> >>>
> >> BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/mm/slab.c:3043
> >> in_atomic():1, irqs_disabled():0
> >> 1 lock held by artsd/3819:
> >>  #0:  (&new->lock){--..}, at: [<c01d5b7c>] ipc_lock+0x35/0x4f
> >>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
> >>  [<c0105a25>] show_trace+0x12/0x14
> >>  [<c0105ae7>] dump_stack+0x16/0x18
> >>  [<c011db4a>] __might_sleep+0xc9/0xcf
> >>  [<c017c37a>] kmem_cache_zalloc+0x28/0xe5
> >>  [<c01d8c7d>] do_shmat+0x111/0x372
> >>  [<c0109151>] sys_ipc+0x148/0x1b5
> >>  [<c010432c>] syscall_call+0x7/0xb
> > 
> > That's shm-make-sysv-ipc-shared-memory-use-stacked-files.patch, brought to
> > us by Eric-who-hasnt-read-Documentation/SubmitChecklist.
> > 
> > Like this, I guess:
> > 
> > diff -puN ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-fix ipc/shm.c
> 
> I might be drunk...
> 
> This patch still doesn't solve the problem.
> 
> BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/mm/slab.c:3043
> in_atomic():1, irqs_disabled():0
> 1 lock held by Xorg/2885:
>  #0:  (&new->lock){--..}, at: [<c01d5b7c>] ipc_lock+0x35/0x4f
>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
>  [<c0105a25>] show_trace+0x12/0x14
>  [<c0105ae7>] dump_stack+0x16/0x18
>  [<c011db4a>] __might_sleep+0xc9/0xcf
>  [<c017c45f>] kmem_cache_alloc+0x28/0xbf
>  [<c01814c3>] get_empty_filp+0x6a/0x173
>  [<c01d8ca2>] do_shmat+0x136/0x390
>  [<c0109151>] sys_ipc+0x148/0x1b5
>  [<c010432c>] syscall_call+0x7/0xb

yes, that's the other one, which Eric will be looking at.

>  =======================
> BUG: MAX_LOCK_DEPTH too low!
> turning off the locking correctness validator.
> do_IRQ: stack overflow: -52
>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
>  [<c0105a25>] show_trace+0x12/0x14
>  [<c0105ae7>] dump_stack+0x16/0x18
>  [<c0106cc0>] do_IRQ+0x95/0xc1
> BUG: unable to handle kernel paging request at virtual address 0e200034
>  printing eip:
> c01052e2
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP
> last sysfs file: /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/vendor
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_timer skge snd 8139too intel_agp sk98lin agpgart soundcore mii i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
> CPU:    0
> EIP:    0060:[<c01052e2>]    Not tainted VLI
> EFLAGS: 00013046   (2.6.20-mm1 #16)
> EIP is at dump_trace+0x88/0x9e
> eax: 00000000   ebx: f412c01c   ecx: c0429344   edx: c03cf8fa
> BUG: unable to handle kernel paging request at virtual address 8d17ca6c
>  printing eip:
> c011d927
> *pde = 00000000
> esi: 0e200000   edi: c03daed2   ebp: f412bfd0   esp: f412bfc0
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process Xorg (pid: 2885, ti=f412a000 task=f4a58aa0 task.ti=f412c000)
> Stack: c7422ac0 c03daed2 00000011 00000000 f412bfe4 c0105312 c0429344 c03daed2
>        00000004 f412bff0 c0105a25 c03daed2 f412bffc c0105ae7 f412c008 f412c01c
> Call Trace:
>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
>  [<c01053c4>] show_stack_log_lvl+0x9d/0xac
>  [<c01055c0>] show_registers+0x1ed/0x34c
>  [<c010583c>] die+0x11d/0x234
>  [<c011b8d1>] do_page_fault+0x47c/0x55b
>  [<c033aaac>] error_code+0x7c/0x84
>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
>  [<c0105a25>] show_trace+0x12/0x14
>  [<c0105ae7>] dump_stack+0x16/0x18
>  [<c0106cc0>] do_IRQ+0x95/0xc1
> BUG: unable to handle kernel paging request at virtual address 0e200034

ooh, we broke lockdep.
