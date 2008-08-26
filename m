Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYHZWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYHZWmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYHZWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:42:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:43463 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYHZWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HWGsBb6jEeHagQAtQ936Meo2HndkDxOLL0FT0px3+9Oukdon8QPYfLMpp4oG8CmJ3g
         S28Omlespyt7xnLUsYdHQt6AQYKLNrtAIqQZTK/eK+aWFempZKq31MoaE60XFETaskaF
         fCPL/gVcvIeoY+OD+bPj85cVzDcE5/1SjcF38=
Message-ID: <84144f020808261542x417d0bcao9d54ee3d75fc406c@mail.gmail.com>
Date: Wed, 27 Aug 2008 01:42:21 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, linux@youmustbejoking.demon.co.uk,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Oopses below shrink_slab
In-Reply-To: <4FDA7ACAE0%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4FDA7ACAE0%linux@youmustbejoking.demon.co.uk>
X-Google-Sender-Auth: 64a95da352e45e7f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Tue, Aug 26, 2008 at 10:31 PM, Darren Salt
<linux@youmustbejoking.demon.co.uk> wrote:
> I've had a few odd oopses recently, both while the computer was busy. The
> first was with 2.6.25.9 (while loading resources for a game; uptime was a
> little over 49 days), and the second was with 2.6.25.16 (in the middle of a
> dpkg run; uptime was a day or so).
>
> "Full" kernel log (less some likely-irrelevant USB & DVD stuff) & config
> attached for .16.
>
> (I'll switch to 2.6.26.current soonish, probably when I next *need* to
> reboot.)
>
>
> This one with 2.6.25.9:
>
> -- BUG: unable to handle kernel NULL pointer dereference at 000000000000008e
> IP: [<ffffffff80274b14>] dentry_iput+0x63/0x8b
> PGD 3c7a1067 PUD a43e067 PMD 0
> Oops: 0000 [1]
> CPU 0
> Modules linked in: vfat fat usb_storage sd_mod mt2060 dvb_usb_dib0700 dib7000p dib7000m dvb_usb dib3000mc dibx000_common dib0070 radeon drm ip6t_LOG xt_tcpudp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack ip6table_mangle ip6table_filter ip6_tables x_tables snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul dvb_pll cx22702 cx88_dvb videobuf_dvb dvb_core snd_emu10k1 snd_seq_midi snd_rawmidi snd_util_mem snd_hwdep cx8800 cx8802 cx88xx ir_common compat_ioctl32 tveeprom videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc sata_nv libata dock snd_intel8x0 snd_ac97_codec ac97_bus
> Pid: 237, comm: kswapd0 Not tainted 2.6.25.9 #1
> RIP: 0010:[<ffffffff80274b14>]  [<ffffffff80274b14>] dentry_iput+0x63/0x8b
> RSP: 0000:ffff81003fae3d30  EFLAGS: 00010206
> RAX: 0000000000000066 RBX: ffff81002f7e3a80 RCX: ffff81002f7e3ae8
> RDX: ffff810004432a48 RSI: ffff8100047ed808 RDI: ffff81002f7e3a80
> RBP: ffff810004432a18 R08: 0000000000002b5e R09: ffff81003fae3d50
> R10: 0000000000000080 R11: ffffffff80277610 R12: 0000000000000000
> R13: 0000000000000049 R14: 00000000000000d0 R15: 0000000000035aad
> FS:  00007fc28ffac6f0(0000) GS:ffffffff8063f000(0000) knlGS:00000000f74cb720
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 000000000000008e CR3: 000000001efda000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> Process kswapd0 (pid: 237, threadinfo ffff81003fae2000, task ffff81003fab4080)
> Stack:  ffffe200006a9398 ffff81002f7e3a80 ffff81003f3b2870 ffffffff80274bc8
>  ffff81003fae3d50 ffff81002f7e3a80 0000000000000000 ffffffff80274c9a
>  ffff81002f7e3a80 ffffffff80274da7 ffff81003fae3d80 ffffffff806104a0
> Call Trace:
>  [<ffffffff80274bc8>] ? d_kill+0x34/0x55
>  [<ffffffff80274c9a>] ? prune_one_dentry+0xb1/0xbf
>  [<ffffffff80274da7>] ? prune_dcache+0xff/0x14e
>  [<ffffffff80274e0d>] ? shrink_dcache_memory+0x17/0x35
>  [<ffffffff802515ac>] ? shrink_slab+0xd6/0x13d
>  [<ffffffff80251977>] ? kswapd+0x364/0x46f
>  [<ffffffff802504a7>] ? isolate_pages_global+0x0/0x2f
>  [<ffffffff80236780>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff80251613>] ? kswapd+0x0/0x46f
>  [<ffffffff802363aa>] ? kthread+0x47/0x73
>  [<ffffffff80224a60>] ? schedule_tail+0x18/0x4d
>  [<ffffffff8020b828>] ? child_rip+0xa/0x12
>  [<ffffffff80236363>] ? kthread+0x0/0x73
>  [<ffffffff8020b81e>] ? child_rip+0x0/0x12
>
> Code: 00 75 1c 48 89 ef 45 31 c0 31 c9 31 d2 be 00 04 00 00 e8 c4 56 01 00 48 89
>  ef e8 0d 58 01 00 48 8b 83 80 00 00 00 48 85 c0 74 19 <48> 8b 40 28 48 85 c0 74
>  10 41 58 48 89 df 48 89 ee 49 89 c3 5b
> RIP  [<ffffffff80274b14>] dentry_iput+0x63/0x8b
>  RSP <ffff81003fae3d30>
> CR2: 000000000000008e

Looking at disassembly of the code:

     123:       48 8b 83 88 00 00 00    mov    0x88(%rbx),%rax
     12a:       48 85 c0                test   %rax,%rax
     12d:       74 19                   je     148 <dentry_iput+0x83>
     12f:       48 8b 40 28             mov    0x28(%rax),%rax <-- oops

The offset of dentry->d_op is 0x88 and the offset of d_op->d_iput is
0x28, so the oops happens in dentry_iput::fs/dcache.c:

    if (dentry->d_op && dentry->d_op->d_iput)
            dentry->d_op->d_iput(dentry, inode);

The culprit here seems to be that dentry->d_op contains a totally
bogus pointer ("0x66") in %rax.

> This one with 2.6.25.16:
>
> Bad page state in process 'kswapd0'
> page:ffff8100279219ee flags:0x0000000000000000 mapping:0000000000000000 mapcount
> :1 count:0
> Trying to fix it up, but a reboot is needed
> Backtrace:
> Pid: 237, comm: kswapd0 Not tainted 2.6.25.16 #1
>
> Call Trace:
>  [<ffffffff8024f1ce>] remove_mapping+0x86/0x99
>  [<ffffffff8024b0de>] bad_page+0x71/0x9b
>  [<ffffffff8024b6b3>] free_hot_cold_page+0x6e/0x132
>  [<ffffffff8024b7a0>] __pagevec_free+0x29/0x3b
>  [<ffffffff8024dd68>] release_pages+0x124/0x131
>  [<ffffffff8024e9fd>] isolate_lru_pages+0x7a/0x204
>  [<ffffffff8024e08a>] __pagevec_release+0x19/0x22
>  [<ffffffff8024e5a9>] __invalidate_mapping_pages+0xc3/0x106
>  [<ffffffff8024cb35>] get_dirty_limits+0x1d/0x1a6
>  [<ffffffff80274a74>] shrink_icache_memory+0xe8/0x1c7
>  [<ffffffff8024fc12>] shrink_slab+0xd9/0x13f
>  [<ffffffff80250229>] kswapd+0x30d/0x3ec
>  [<ffffffff8024eb87>] isolate_pages_global+0x0/0x2f
>  [<ffffffff80235b0f>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8024ff1c>] kswapd+0x0/0x3ec
>  [<ffffffff80235937>] kthread+0x47/0x74
>  [<ffffffff802232c9>] schedule_tail+0x18/0x4c
>  [<ffffffff8020b758>] child_rip+0xa/0x12
>  [<ffffffff802358f0>] kthread+0x0/0x74
>  [<ffffffff8020b74e>] child_rip+0x0/0x12
>
> BUG: unable to handle kernel paging request at 00000fff805298a8
> IP: [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f
> PGD 0
> Oops: 0000 [1]
> CPU 0
> Modules linked in: vfat fat usb_storage sd_mod radeon drm ip6t_LOG xt_tcpudp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack ip6table_mangle ip6table_filter ip6_tables x_tables dvb_pll cx22702 cx88_dvb videobuf_dvb dvb_core snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_seq_midi snd_rawmidi snd_util_mem snd_hwdep cx8800 sata_nv cx8802 libata cx88xx ir_common tveeprom compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc dock snd_intel8x0 snd_ac97_codec ac97_bus
> Pid: 237, comm: kswapd0 Tainted: G    B    2.6.25.16 #1
> RIP: 0010:[<ffffffff8024ad0e>]  [<ffffffff8024ad0e>] get_pageblock_flags_group+0
> x31/0x8f
> RSP: 0018:ffff81003fb83b88  EFLAGS: 00010016
> RAX: 000001fffffc8925 RBX: ffff8100279219ee RCX: ffffffff806064b8
> RDX: fffffe4492fe099b RSI: 0000000000000000 RDI: 0001fffffc8925fc
> RBP: ffffffff806064a8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000000 R12: ffffffff80606470
> R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f0116b74780(0000) GS:ffffffff80637000(0000) knlGS:00000000f74c0720
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000fff805298a8 CR3: 00000000279bb000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> Process kswapd0 (pid: 237, threadinfo ffff81003fb82000, task ffff81003fa50040)
> Stack:  ffffffff8024b73e 0000000000000000 ffff81003fb83bf0 0000000000000001
>  0000000000000001 ffff81003fb83cc0 ffffffff8024b7a0 ffffe20000072840
>  ffff81003fb83cc0 ffff81003fb83cd8 0000000000000001 0000000000000001
> Call Trace:
>  [<ffffffff8024b73e>] ? free_hot_cold_page+0xf9/0x132
>  [<ffffffff8024b7a0>] ? __pagevec_free+0x29/0x3b
>  [<ffffffff8024dd68>] ? release_pages+0x124/0x131
>  [<ffffffff8024e9fd>] ? isolate_lru_pages+0x7a/0x204
>  [<ffffffff8024e08a>] ? __pagevec_release+0x19/0x22
>  [<ffffffff8024e5a9>] ? __invalidate_mapping_pages+0xc3/0x106
>  [<ffffffff8024cb35>] ? get_dirty_limits+0x1d/0x1a6
>  [<ffffffff80274a74>] ? shrink_icache_memory+0xe8/0x1c7
>  [<ffffffff8024fc12>] ? shrink_slab+0xd9/0x13f
>  [<ffffffff80250229>] ? kswapd+0x30d/0x3ec
>  [<ffffffff8024eb87>] ? isolate_pages_global+0x0/0x2f
>  [<ffffffff80235b0f>] ? autoremove_wake_function+0x0/0x2e
>  [<ffffffff8024ff1c>] ? kswapd+0x0/0x3ec
>  [<ffffffff80235937>] ? kthread+0x47/0x74
>  [<ffffffff802232c9>] ? schedule_tail+0x18/0x4c
>  [<ffffffff8020b758>] ? child_rip+0xa/0x12
>  [<ffffffff802358f0>] ? kthread+0x0/0x74
>  [<ffffffff8020b74e>] ? child_rip+0x0/0x12
>
> Code: 00 1e 00 00 41 89 d2 48 8d 14 07 48 b8 b7 6d db b6 6d db b6 6d 48 c1 fa 03
>  48 0f af d0 48 89 d0 48 89 d7 48 c1 e8 17 48 c1 ef 0f <48> 8b 0c c5 80 4f 6e 80
>  31 c0 48 85 c9 74 0c 48 0f b6 c7 48 c1
> RIP  [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f
>  RSP <ffff81003fb83b88>
> CR2: 00000fff805298a8

OK, this looks very scary. I get the following code when disassembling
a local copy of mm/page_alloc.o:

    2215:       48 89 d7                mov    %rdx,%rdi
    2218:       48 c1 e8 17             shr    $0x17,%rax
    221c:       48 c1 ef 0f             shr    $0xf,%rdi
    2220:       48 8b 0c c5 00 00 00    mov    0x0(,%rax,8),%rcx
    2227:       00

But the code in your oops disassemble to:

  23:   48 c1 e8 17             shr    $0x17,%rax
  27:   48 c1 ef 0f             shr    $0xf,%rdi
   0:   48 8b 0c c5 80 4f 6e    mov    -0x7f91b080(,%rax,8),%rcx
   7:   80

Which looks very wrong indeed. The value of %rax
("0x000001fffffc8925") looks fairly interesting as well. The code in
question seem to be get_pageblock_flags_group() ->
get_pageblock_bitmap() -> __pfn_to_section() -> __nr_to_section():

        if (!mem_section[SECTION_NR_TO_ROOT(nr)])
                return NULL;

However, as this is a common page allocator path (we call
get_pageblock_flags_group() from the free_hot_cold_page() function),
you should probably be hitting this problem early on which makes me
think we're looking at bad hardware.

                             Pekka
