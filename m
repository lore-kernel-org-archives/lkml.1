Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339Ab0AZJD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0AZJD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845Ab0AZJD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:03:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:61826 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0AZJDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:in-reply-to:references:subject:date:to:mime-version
         :content-transfer-encoding:from:message-id:user-agent;
        b=r8TcZzdHSB/4XRHhTE2RWBi8Z7HfjG5YxU6zmTUIm5nUYJnMamVJ+Js+TVm1pCjzcl
         RsLHsl7CSL6X0/3GzMdqIKpi4hwxKdyNM1J2P3g1M+rCwBdxIUJ+z4dNuJvGfIgjgD9Q
         SK6gSdx1A7fZxCTQrYuCcqemnkXCSWQ3Lpp8I=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
In-Reply-To: <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
References: <20100125104728.4935.A69D9226@jp.fujitsu.com>
 <op.u63v1pxzasvm2a@kedge> <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Date: Tue, 26 Jan 2010 10:06:30 +0100
To: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u64t84zuasvm2a@kedge>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 06:19:23 +0100, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:

> (cc to lots related person)
>
>> On Mon, 25 Jan 2010 02:48:08 +0100, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> >> Hi,
>> >>
>> >> since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer
>> >> kills when I do hard disk intensive tasks (mainly in VirtualBox  
>> which is
>> >> running Windows XP) and IMHO it kills processes even if I have a lot  
>> of
>> >> free memory.
>> >>
>> >> Is this a known bug? I have self compiled kernel so I can try  
>> patches.
>> >
>> > Can you please post your .config?
>
> Hi all,
>
> Strangely, all reproduce machine are x86_64 with Intel i915. but I don't
> have any solid evidence.
> Can anyone please apply following debug patch and reproduce this issue?
>
> this patch write some debug message into /var/log/messages.
>

Here it is

Jan 26 09:34:32 kedge kernel: ->fault OOM shmem_fault 1 1
Jan 26 09:34:32 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,
oom_adj=0
Jan 26 09:34:32 kedge kernel: Pid: 1927, comm: X Not tainted 2.6.33-rc5 #3
Jan 26 09:34:32 kedge kernel: Call Trace:
Jan 26 09:34:32 kedge kernel: [<ffffffff8107feb4>] T.350+0x54/0x140
Jan 26 09:34:32 kedge kernel: [<ffffffff81080016>] T.349+0x76/0x140
Jan 26 09:34:32 kedge kernel: [<ffffffff81080200>]
__out_of_memory+0x120/0x190
Jan 26 09:34:32 kedge kernel: [<ffffffff81080388>]
pagefault_out_of_memory+0x48/0x90
Jan 26 09:34:32 kedge kernel: [<ffffffff81021eb0>] mm_fault_error+0x40/0xc0
Jan 26 09:34:33 kedge kernel: [<ffffffff810221f8>]
do_page_fault+0x2c8/0x2d0
Jan 26 09:34:35 kedge kernel: [<ffffffff815719df>] page_fault+0x1f/0x30
Jan 26 09:34:35 kedge kernel: Mem-Info:
Jan 26 09:34:35 kedge kernel: DMA per-cpu:
Jan 26 09:34:35 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan 26 09:34:35 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan 26 09:34:35 kedge kernel: DMA32 per-cpu:
Jan 26 09:34:35 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 135
Jan 26 09:34:35 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 119
Jan 26 09:34:35 kedge kernel: Normal per-cpu:
Jan 26 09:34:35 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 124
Jan 26 09:34:35 kedge kernel: CPU    1: hi:  186, btch:  31 usd:   0
Jan 26 09:34:35 kedge kernel: active_anon:299484 inactive_anon:124767
isolated_anon:32
Jan 26 09:34:35 kedge kernel: active_file:318642 inactive_file:192171
isolated_file:0
Jan 26 09:34:35 kedge kernel: unevictable:2 dirty:113272 writeback:19224
unstable:0
Jan 26 09:34:35 kedge kernel: free:6859 slab_reclaimable:19340
slab_unreclaimable:10057
Jan 26 09:34:35 kedge kernel: mapped:27902 shmem:50780 pagetables:4901
bounce:0
Jan 26 09:34:35 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:160kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15332kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Jan 26 09:34:35 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan 26 09:34:35 kedge kernel: DMA32 free:9792kB min:6084kB low:7604kB
high:9124kB active_anon:936684kB inactive_anon:237096kB
active_file:1032028kB inactive_file:636296kB unevictable:8kB
isolated(anon):0kB isolated(file):0kB present:3062688kB mlocked:8kB
dirty:381208kB writeback:65944kB mapped:68072kB shmem:70336kB
slab_reclaimable:54692kB slab_unreclaimable:18084kB kernel_stack:128kB
pagetables:2968kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:240 all_unreclaimable? no
Jan 26 09:34:35 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan 26 09:34:35 kedge kernel: Normal free:1868kB min:1924kB low:2404kB
high:2884kB active_anon:261252kB inactive_anon:261972kB
active_file:242540kB inactive_file:132228kB unevictable:0kB
isolated(anon):128kB isolated(file):0kB present:969600kB mlocked:0kB
dirty:71880kB writeback:10952kB mapped:43536kB shmem:132784kB
slab_reclaimable:22668kB slab_unreclaimable:22136kB kernel_stack:1984kB
pagetables:16636kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:100 all_unreclaimable? no
Jan 26 09:34:35 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan 26 09:34:35 kedge kernel: DMA: 0*4kB 2*8kB 1*16kB 2*32kB 1*64kB
2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15776kB
Jan 26 09:34:35 kedge kernel: DMA32: 158*4kB 7*8kB 10*16kB 6*32kB 1*64kB
0*128kB 4*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 9808kB
Jan 26 09:34:35 kedge kernel: Normal: 467*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1868kB
Jan 26 09:34:35 kedge kernel: 561725 total pagecache pages
Jan 26 09:34:35 kedge kernel: 77 pages in swap cache
Jan 26 09:34:35 kedge kernel: Swap cache stats: add 6320, delete 6243,
find 0/0
Jan 26 09:34:35 kedge kernel: Free swap  = 1982844kB
Jan 26 09:34:35 kedge kernel: Total swap = 2008116kB
Jan 26 09:34:35 kedge kernel: 1032192 pages RAM
Jan 26 09:34:35 kedge kernel: 49925 pages reserved
Jan 26 09:34:35 kedge kernel: 855983 pages shared
Jan 26 09:34:35 kedge kernel: 172671 pages non-shared
Jan 26 09:34:35 kedge kernel: Out of memory: kill process 1765 (hald)
score 10056 or a child
Jan 26 09:34:35 kedge kernel: Killed process 1766 (hald-runner)
vsz:17860kB, anon-rss:24kB, file-rss:732kB
