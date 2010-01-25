Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343Ab0AYWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0AYWKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776Ab0AYWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:10:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:41752 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0AYWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:cc:references:subject:to:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=mwRMY5H9pRviL8CQM/og/T3vWeJV/2VSttCgWpbu13OSkVjX1PD2KOZNro5+jZE1U+
         DmjE2jJgdcPIomwmnrysfj2Ug9JwGKXk6Gl2lgBfUOvCnhnCM+AZsLstloA0Y75NqERQ
         kaoxav3rhjlRC7GIaJVr1J5rtKVfqdRJ54G00=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: linux-kernel@vger.kernel.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <op.u6ixswy6asvm2a@kedge>
 <alpine.DEB.2.00.1001221623480.12712@chino.kir.corp.google.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
To: "David Rientjes" <rientjes@google.com>
Date: Mon, 25 Jan 2010 23:12:38 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u63zzcz6asvm2a@kedge>
In-Reply-To: <alpine.DEB.2.00.1001221623480.12712@chino.kir.corp.google.com>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010 01:40:17 +0100, David Rientjes <rientjes@google.com>
wrote:

> On Thu, 14 Jan 2010, Roman Jarosz wrote:
>
>> Hi,
>>
>> since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer  
>> kills
>> when I do hard disk intensive tasks (mainly in VirtualBox which is  
>> running
>> Windows XP) and IMHO it kills processes even if I have a lot of free  
>> memory.
>>
>> Is this a known bug? I have self compiled kernel so I can try patches.
>>
>> Regards
>> Roman Jarosz
>>
>> PS. Please CC me.
>>
>> Jan  7 12:39:27 kedge kernel: X invoked oom-killer: gfp_mask=0x0,  
>> order=0,
>> oom_adj=0
>
> The gfp_mask of 0x0 and order of 0 indicate these are triggered by
> pagefaults that end up returning VM_FAULT_OOM.  Prior to 2.6.29, the
> current task (X in all cases from your log) would have been SIGKILLed; we
> now call the oom killer instead of kill a memory hogging task so that the
> fault is retried with more success.  If you've upgraded from a 2.6.29 or
> later kernel and are only now experiencing these errors, it may indicate  
> a
> regression in VM that we need to investigate (and, if so, you may want to
> try merging f50de2d38 from 2.6.33 to see if it helps keep more  
> ZONE_NORMAL
> memory available so that such drastic measures aren't necessary).

I only have logs since 2.6.31-rc7 and there is one oom-kill in 2.6.32-rc7
and then the kills in 2.6.32.2.

Nov 25 13:49:04 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,
oom_adj=0
Nov 25 13:49:04 kedge kernel: Pid: 1883, comm: X Not tainted 2.6.32-rc7 #1
Nov 25 13:49:04 kedge kernel: Call Trace:
Nov 25 13:49:04 kedge kernel: [<ffffffff8107a66d>] ? 0xffffffff8107a66d
Nov 25 13:49:04 kedge kernel: [<ffffffff8107a953>] ? 0xffffffff8107a953
Nov 25 13:49:04 kedge kernel: [<ffffffff8107aac7>] ? 0xffffffff8107aac7
Nov 25 13:49:04 kedge kernel: [<ffffffff8155453f>] ? 0xffffffff8155453f
Nov 25 13:49:04 kedge kernel: Mem-Info:
Nov 25 13:49:04 kedge kernel: DMA per-cpu:
Nov 25 13:49:04 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Nov 25 13:49:04 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Nov 25 13:49:04 kedge kernel: DMA32 per-cpu:
Nov 25 13:49:04 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 178
Nov 25 13:49:04 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 174
Nov 25 13:49:04 kedge kernel: Normal per-cpu:
Nov 25 13:49:04 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 153
Nov 25 13:49:04 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  81
Nov 25 13:49:04 kedge kernel: active_anon:135012 inactive_anon:77065
isolated_anon:0
Nov 25 13:49:04 kedge kernel: active_file:332368 inactive_file:411112
isolated_file:32
Nov 25 13:49:04 kedge kernel: unevictable:0 dirty:139692 writeback:2395
unstable:0
Nov 25 13:49:04 kedge kernel: free:6869 slab_reclaimable:15618
slab_unreclaimable:7026
Nov 25 13:49:04 kedge kernel: mapped:31999 shmem:26786 pagetables:4497
bounce:0
Nov 25 13:49:04 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:1
60kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_rec
laimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaima
ble? no
Nov 25 13:49:04 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Nov 25 13:49:04 kedge kernel: DMA32 free:9856kB min:6084kB low:7604kB
high:9124kB active_anon:327516kB inactive_anon:87488kB active_file:112
2804kB inactive_file:1374360kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3062688kB mlocked:0kB dirty:440312kB writeback:
5556kB mapped:24652kB shmem:57952kB slab_reclaimable:42492kB
slab_unreclaimable:10528kB kernel_stack:472kB pagetables:3464kB
unstable:0kB bo
unce:0kB writeback_tmp:0kB pages_scanned:384 all_unreclaimable? no
Nov 25 13:49:04 kedge kernel: lowmem_reserve[]: 0 0 946 946
Nov 25 13:49:04 kedge kernel: Normal free:1844kB min:1924kB low:2404kB
high:2884kB active_anon:212532kB inactive_anon:220772kB active_file:2
06668kB inactive_file:269928kB unevictable:0kB isolated(anon):0kB
isolated(file):128kB present:969600kB mlocked:0kB dirty:118456kB writeback
:4024kB mapped:103344kB shmem:49192kB slab_reclaimable:19980kB
slab_unreclaimable:17568kB kernel_stack:1608kB pagetables:14524kB
unstable:0k
B bounce:0kB writeback_tmp:0kB pages_scanned:448 all_unreclaimable? no
Nov 25 13:49:04 kedge kernel: lowmem_reserve[]: 0 0 0 0
Nov 25 13:49:04 kedge kernel: DMA: 0*4kB 2*8kB 1*16kB 2*32kB 1*64kB
2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15776kB
Nov 25 13:49:04 kedge kernel: DMA32: 300*4kB 4*8kB 29*16kB 1*32kB 1*64kB
1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 9856kB
Nov 25 13:49:04 kedge kernel: Normal: 461*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1844kB
Nov 25 13:49:04 kedge kernel: 754208 total pagecache pages
Nov 25 13:49:04 kedge kernel: 64 pages in swap cache
Nov 25 13:49:04 kedge kernel: Swap cache stats: add 357, delete 293, find
2/8
Nov 25 13:49:04 kedge kernel: Free swap  = 2006888kB
Nov 25 13:49:04 kedge kernel: Total swap = 2008116kB
Nov 25 13:49:04 kedge kernel: 1032192 pages RAM
Nov 25 13:49:04 kedge kernel: 36869 pages reserved
Nov 25 13:49:04 kedge kernel: 377334 pages shared
Nov 25 13:49:04 kedge kernel: 705565 pages non-shared
Nov 25 13:49:04 kedge kernel: Out of memory: kill process 6816
(services.exe) score 1652318 or a child
Nov 25 13:49:04 kedge kernel: Killed process 6818 (winedevice.exe)

>> Jan  7 12:39:27 kedge kernel: Pid: 1954, comm: X Not tainted 2.6.32.2 #1
>> Jan  7 12:39:27 kedge kernel: Call Trace:
>> Jan  7 12:39:27 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
>> Jan  7 12:39:27 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
>> Jan  7 12:39:27 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
>> Jan  7 12:39:27 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df
>
> Can you find out what these symbols are?

Can I somehow get the symbols without recompiling kernel?
I have the source tree with *.o files and other stuff which was created
during compilation.

I've also got the kill in 2.6.33-rc5, what do I have to do to get the  
symbols?
Is "Load all symbols for debugging/ksymoops (KALLSYMS)" and
"Compile the kernel with frame pointers (FRAME_POINTER)" enough?

Jan 25 15:51:45 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,
oom_adj=0
Jan 25 15:51:45 kedge kernel: Pid: 1904, comm: X Not tainted 2.6.33-rc5 #1
Jan 25 15:51:45 kedge kernel: Call Trace:
Jan 25 15:51:45 kedge kernel: [<ffffffff8107e1a4>] 0xffffffff8107e1a4
Jan 25 15:51:45 kedge kernel: [<ffffffff8107e306>] 0xffffffff8107e306
Jan 25 15:51:45 kedge kernel: [<ffffffff8107e4f0>] 0xffffffff8107e4f0
Jan 25 15:51:45 kedge kernel: [<ffffffff8107e678>] 0xffffffff8107e678
Jan 25 15:51:45 kedge kernel: [<ffffffff81021e60>] 0xffffffff81021e60
Jan 25 15:51:45 kedge kernel: [<ffffffff810221a8>] 0xffffffff810221a8
Jan 25 15:51:45 kedge kernel: [<ffffffff8156f95f>] 0xffffffff8156f95f
Jan 25 15:51:45 kedge kernel: Mem-Info:
Jan 25 15:51:45 kedge kernel: DMA per-cpu:
Jan 25 15:51:45 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jan 25 15:51:45 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jan 25 15:51:45 kedge kernel: DMA32 per-cpu:
Jan 25 15:51:45 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 152
Jan 25 15:51:45 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 171
Jan 25 15:51:45 kedge kernel: Normal per-cpu:
Jan 25 15:51:45 kedge kernel: CPU    0: hi:  186, btch:  31 usd:  44
Jan 25 15:51:45 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 167
Jan 25 15:51:45 kedge kernel: active_anon:303490 inactive_anon:130718
isolated_anon:32
Jan 25 15:51:45 kedge kernel: active_file:308170 inactive_file:183887
isolated_file:0
Jan 25 15:51:45 kedge kernel: unevictable:0 dirty:172639 writeback:8741
unstable:0
Jan 25 15:51:45 kedge kernel: free:6871 slab_reclaimable:26390
slab_unreclaimable:11635
Jan 25 15:51:45 kedge kernel: mapped:38879 shmem:29781 pagetables:5198
bounce:0
Jan 25 15:51:45 kedge kernel: DMA free:15764kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:4kB inactive_file:156kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15332kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:4kB slab_unreclaimable:16kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Jan 25 15:51:45 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937
Jan 25 15:51:45 kedge kernel: DMA32 free:9832kB min:6084kB low:7604kB
high:9124kB active_anon:970168kB inactive_anon:242576kB
active_file:1015796kB inactive_file:619228kB unevictable:0kB
isolated(anon):128kB isolated(file):0kB present:3062688kB mlocked:0kB
dirty:584004kB writeback:31268kB mapped:35252kB shmem:43448kB
slab_reclaimable:85656kB slab_unreclaimable:25596kB kernel_stack:264kB
pagetables:4724kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:238 all_unreclaimable? no
Jan 25 15:51:45 kedge kernel: lowmem_reserve[]: 0 0 946 946
Jan 25 15:51:45 kedge kernel: Normal free:1888kB min:1924kB low:2404kB
high:2884kB active_anon:243792kB inactive_anon:280296kB
active_file:216880kB inactive_file:116164kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:969600kB mlocked:0kB
dirty:106552kB writeback:3696kB mapped:120264kB shmem:75676kB
slab_reclaimable:19900kB slab_unreclaimable:20928kB kernel_stack:1920kB
pagetables:16068kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:33 all_unreclaimable? no
Jan 25 15:51:45 kedge kernel: lowmem_reserve[]: 0 0 0 0
Jan 25 15:51:45 kedge kernel: DMA: 1*4kB 2*8kB 2*16kB 3*32kB 2*64kB
3*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB = 15764kB
Jan 25 15:51:45 kedge kernel: DMA32: 1108*4kB 1*8kB 2*16kB 0*32kB 0*64kB
2*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 9848kB
Jan 25 15:51:45 kedge kernel: Normal: 472*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1888kB
Jan 25 15:51:45 kedge kernel: 522113 total pagecache pages
Jan 25 15:51:45 kedge kernel: 274 pages in swap cache
Jan 25 15:51:45 kedge kernel: Swap cache stats: add 5340, delete 5066,
find 0/0
Jan 25 15:51:45 kedge kernel: Free swap  = 1986756kB
Jan 25 15:51:45 kedge kernel: Total swap = 2008116kB
Jan 25 15:51:45 kedge kernel: 1032192 pages RAM
Jan 25 15:51:45 kedge kernel: 49813 pages reserved
Jan 25 15:51:45 kedge kernel: 821582 pages shared
Jan 25 15:51:45 kedge kernel: 260542 pages non-shared
Jan 25 15:51:45 kedge kernel: Out of memory: kill process 1746 (hald)
score 10058 or a child
Jan 25 15:51:45 kedge kernel: Killed process 1747 (hald-runner)
vsz:17860kB, anon-rss:24kB, file-rss:1044kB
