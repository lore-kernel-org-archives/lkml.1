Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZKDQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZKDQjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZKDQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:39:51 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35103 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbZKDQju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sWN7k13Bze7EzGitMdP//0NzDbFfIDheGjIrSEIzckVt5UFpLd4p1CtyxAXpvclSmq
         RjKtTPYxH5oS4Yq9FMx7LkTO59wzblvMQBm9P2s109c57H8fZ9IJHY8UtUhJaz6lPx5j
         1TQn/fkX/f85dgxrEO5sO/OmHAZfAK4zsUFdA=
MIME-Version: 1.0
In-Reply-To: <4AF1A198.1090709@gmail.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
	 <20091103222432.4a94bd8f.akpm@linux-foundation.org>
	 <4AF17DED.7080808@gmail.com> <4AF198E1.9010303@gmail.com>
	 <4AF1A198.1090709@gmail.com>
Date: Wed, 4 Nov 2009 08:39:55 -0800
Message-ID: <dd18b0c30911040839ice58f81v7c8aa10e79f5d1b8@mail.gmail.com>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
From: Justin Mattock <justinmattock@gmail.com>
To: Dave Korn <dave.korn.cygwin@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 7:45 AM, Dave Korn
<dave.korn.cygwin@googlemail.com> wrote:
> Justin P. Mattock wrote:
>
>> I can try, only issue I have is I don't
>> use a distro, so building anything requires me
>> to hand compile it
>
>  Oh, ouch!
>

I know.. I'm a horror for optimization

>> (hopefully not difficult for gdb).
>
>  Indeed, hopefully not.
>

you never know, some packages big/small turn into brain surgery
just to get going.(I'll try after I do some morning exercises)

>> So give me some time on this and I'll see if I can get this up
>> and running, and add that patch to kernel then go from there.
>
>  The one thing you can still try straight away for minimal effort is the
> -fmem-report option, but it's also the least informative...
>
>    cheers,
>      DaveK
>
>

O.k. here is the info from dmesg(with the patch added)
and what -fmem-report:


[  205.931940] kjournald starting.  Commit interval 5 seconds
[  205.931957] EXT3-fs warning: maximal mount count reached, running
e2fsck is recommended
[  205.935509] EXT3 FS on sdb1, internal journal
[  205.935513] EXT3-fs: mounted filesystem with writeback data mode.
[  205.956396] SELinux: initialized (dev sdb1, type ext3), uses xattr
[  434.205304] __ratelimit: 75 callbacks suppressed
[  434.205308] wicd-monitor invoked oom-killer: gfp_mask=0x201da,
order=0, oom_adj=0
[  434.205313] Pid: 1563, comm: wicd-monitor Tainted: P
2.6.32-rc5-00081-g964fe08-dirty #36
[  434.205316] Call Trace:
[  434.205325]  [<ffffffff810bc1af>] oom_kill_process+0x7c/0x243
[  434.205330]  [<ffffffff810bc6e0>] __out_of_memory+0x146/0x15d
[  434.205335]  [<ffffffff810bc909>] out_of_memory+0x6e/0x9d
[  434.205339]  [<ffffffff810bf7c0>] __alloc_pages_nodemask+0x498/0x5ce
[  434.205345]  [<ffffffff810c10e8>] __do_page_cache_readahead+0xa0/0x1a1
[  434.205350]  [<ffffffff810c1436>] ra_submit+0x1c/0x20
[  434.205353]  [<ffffffff810ba620>] filemap_fault+0x1a6/0x346
[  434.205359]  [<ffffffff810cf388>] __do_fault+0x4f/0x3d9
[  434.205363]  [<ffffffff810eec2e>] ? do_sync_read+0xe3/0x120
[  434.205369]  [<ffffffff811a2571>] ? file_has_perm+0x90/0x9e
[  434.205373]  [<ffffffff810d1cf7>] handle_mm_fault+0x3ab/0x6a7
[  434.205379]  [<ffffffff813d44a3>] do_page_fault+0x2bb/0x2d3
[  434.205383]  [<ffffffff813d23a5>] page_fault+0x25/0x30
[  434.205386] Mem-Info:
[  434.205388] DMA per-cpu:
[  434.205391] CPU    0: hi:    0, btch:   1 usd:   0
[  434.205394] CPU    1: hi:    0, btch:   1 usd:   0
[  434.205396] DMA32 per-cpu:
[  434.205399] CPU    0: hi:  186, btch:  31 usd: 125
[  434.205401] CPU    1: hi:  186, btch:  31 usd: 105
[  434.205404] Normal per-cpu:
[  434.205406] CPU    0: hi:  186, btch:  31 usd: 172
[  434.205409] CPU    1: hi:  186, btch:  31 usd: 154
[  434.205416] active_anon:708764 inactive_anon:266208 isolated_anon:0
[  434.205417]  active_file:71 inactive_file:11 isolated_file:0
[  434.205419]  unevictable:0 dirty:0 writeback:0 unstable:0 buffer:74
[  434.205420]  free:6961 slab_reclaimable:2782 slab_unreclaimable:16224
[  434.205421]  mapped:65 shmem:35 pagetables:2861 bounce:0
[  434.205430] DMA free:15944kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15360kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[  434.205438] lowmem_reserve[]: 0 2976 3986 3986
[  434.205449] DMA32 free:9976kB min:6020kB low:7524kB high:9028kB
active_anon:2360156kB inactive_anon:589924kB active_file:60kB
inactive_file:44kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3047792kB mlocked:0kB dirty:0kB
writeback:0kB mapped:88kB shmem:4kB slab_reclaimable:148kB
slab_unreclaimable:316kB kernel_stack:40kB pagetables:5952kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:225
all_unreclaimable? yes
[  434.205457] lowmem_reserve[]: 0 0 1010 1010
[  434.205468] Normal free:1924kB min:2040kB low:2548kB high:3060kB
active_anon:474900kB inactive_anon:474908kB active_file:224kB
inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:1034240kB mlocked:0kB dirty:0kB
writeback:0kB mapped:172kB shmem:136kB slab_reclaimable:10980kB
slab_unreclaimable:64572kB kernel_stack:824kB pagetables:5492kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:677
all_unreclaimable? yes
[  434.205476] lowmem_reserve[]: 0 0 0 0
[  434.205481] DMA: 2*4kB 2*8kB 3*16kB 2*32kB 3*64kB 2*128kB 2*256kB
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15944kB
[  434.205493] DMA32: 2*4kB 14*8kB 16*16kB 10*32kB 3*64kB 1*128kB
1*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9976kB
[  434.205505] Normal: 481*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1924kB
[  434.205516] 8029 total pagecache pages
[  434.205519] 7893 pages in swap cache
[  434.205521] Swap cache stats: add 112490, delete 104597, find 5058/5479
[  434.205524] Free swap  = 0kB
[  434.205526] Total swap = 431632kB
[  434.220125] 1048576 pages RAM
[  434.220127] 40493 pages reserved
[  434.220129] 170 pages shared
[  434.220131] 1000179 pages non-shared
[  434.220135] Out of memory: kill process 7925 (c++) score 539395 or a child
[  434.220141] Killed process 7926 (cc1plus) vsz:4280180kB,
anon-rss:3831924kB, file-rss:4kB
[  434.259045] cc1plus: page allocation failure. order:0, mode:0x280da
[  434.259051] Pid: 7926, comm: cc1plus Tainted: P
2.6.32-rc5-00081-g964fe08-dirty #36
[  434.259054] Call Trace:
[  434.259063]  [<ffffffff810bf874>] __alloc_pages_nodemask+0x54c/0x5ce
[  434.259070]  [<ffffffff810d1bc3>] handle_mm_fault+0x277/0x6a7
[  434.259076]  [<ffffffff813d44a3>] do_page_fault+0x2bb/0x2d3
[  434.259080]  [<ffffffff813d23a5>] page_fault+0x25/0x30
[  434.259083] Mem-Info:
[  434.259085] DMA per-cpu:
[  434.259088] CPU    0: hi:    0, btch:   1 usd:   0
[  434.259090] CPU    1: hi:    0, btch:   1 usd:   0
[  434.259092] DMA32 per-cpu:
[  434.259095] CPU    0: hi:  186, btch:  31 usd: 125
[  434.259098] CPU    1: hi:  186, btch:  31 usd: 105
[  434.259100] Normal per-cpu:
[  434.259103] CPU    0: hi:  186, btch:  31 usd: 172
[  434.259106] CPU    1: hi:  186, btch:  31 usd: 154
[  434.259113] active_anon:708764 inactive_anon:266208 isolated_anon:0
[  434.259115]  active_file:71 inactive_file:11 isolated_file:0
[  434.259116]  unevictable:0 dirty:0 writeback:0 unstable:0 buffer:74
[  434.259117]  free:6961 slab_reclaimable:2782 slab_unreclaimable:16224
[  434.259119]  mapped:65 shmem:35 pagetables:2861 bounce:0
[  434.259128] DMA free:15944kB min:28kB low:32kB high:40kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15360kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[  434.259135] lowmem_reserve[]: 0 2976 3986 3986
[  434.259147] DMA32 free:9976kB min:6020kB low:7524kB high:9028kB
active_anon:2360156kB inactive_anon:589924kB active_file:60kB
inactive_file:44kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3047792kB mlocked:0kB dirty:0kB
writeback:0kB mapped:88kB shmem:4kB slab_reclaimable:148kB
slab_unreclaimable:316kB kernel_stack:40kB pagetables:5952kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:225
all_unreclaimable? yes
[  434.259154] lowmem_reserve[]: 0 0 1010 1010
[  434.259166] Normal free:1924kB min:2040kB low:2548kB high:3060kB
active_anon:474900kB inactive_anon:474908kB active_file:224kB
inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:1034240kB mlocked:0kB dirty:0kB
writeback:0kB mapped:172kB shmem:136kB slab_reclaimable:10980kB
slab_unreclaimable:64572kB kernel_stack:824kB pagetables:5492kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:677
all_unreclaimable? yes
[  434.259173] lowmem_reserve[]: 0 0 0 0
[  434.259178] DMA: 2*4kB 2*8kB 3*16kB 2*32kB 3*64kB 2*128kB 2*256kB
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15944kB
[  434.259190] DMA32: 2*4kB 14*8kB 16*16kB 10*32kB 3*64kB 1*128kB
1*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9976kB
[  434.259202] Normal: 481*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1924kB
[  434.259214] 8029 total pagecache pages
[  434.259216] 7893 pages in swap cache
[  434.259219] Swap cache stats: add 112490, delete 104597, find 5058/5480
[  434.259221] Free swap  = 0kB
[  434.259223] Total swap = 431632kB
[  434.273830] 1048576 pages RAM
[  434.273832] 40493 pages reserved
[  434.273834] 170 pages shared
[  434.273836] 1000179 pages non-shared




/********** and -fmem-report **************/




Memory still allocated at the end of the compilation process
Size   Allocated        Used    Overhead
8             56k         43k       1680
16           196k         81k       4312
32           188k         40k       3384
64           336k        232k       5376
128          132k        128k       1848
512           28k         13k        392
1024          20k       9216         280
2048          16k       8192         224
4096         348k        348k       4872
8192          56k         56k        392
16384         16k         16k         56
32768         64k         64k        112
24           256k         53k       4608
40           256k        199k       4096
48           800k        579k         12k
56            92k       6608        1472
72            72k       5040        1008
80          8192        1440         112
88          8192         704         112
96           940k        580k         12k
112           80k         39k       1120
120           16k        840         224
192          192k        157k       2688
136          600k        580k       8400
160          200k        172k       2800
176          976k        795k         13k
152           84k         33k       1176
104          120k         28k       1680
256         1040k       1019k         14k
144         4096         144          56
Total       7200k       5293k        104k

String pool
entries         9928
identifiers     6178 (62.23%)
slots           16384
deleted         3726
bytes           86k (17592186044415M overhead)
table size      128k
coll/search     0.3177
ins/search      0.1518
avg. entry      8.92 bytes (+/- 9.51)
longest entry   112

??? tree nodes created

(No per-node statistics)
Type hash: size 4093, 2550 elements, 1.102267 collisions
DECL_DEBUG_EXPR  hash: size 1021, 0 elements, 0.015692 collisions
DECL_VALUE_EXPR  hash: size 1021, 0 elements, 0.000000 collisions
no search statistics
No gimple statistics

Alias oracle query stats:
  refs_may_alias_p: 11 disambiguations, 29 queries
  ref_maybe_used_by_call_p: 0 disambiguations, 62 queries
  call_may_clobber_ref_p: 0 disambiguations, 0 queries

PTA query stats:
  pt_solution_includes: 7 disambiguations, 166 queries
  pt_solutions_intersect: 0 disambiguations, 507 queries
jsxml.cpp
c++ -o jsxml.o -c  -DOSTYPE=\"Linux2.6\" -DOSARCH=Linux
-DEXPORT_JS_API  -DJS_USE_SAFE_ARENA
-I/home/name/LFS/firefox/mozilla-1.9.2/js/src -I.
-I./../../dist/include -I./../../dist/include/nsprpub
-I/usr/include/nspr
-I/home/name/LFS/firefox/mozilla-1.9.2/js/src    -fPIC   -fno-rtti
-fno-exceptions -Wall -Wpointer-arith -Woverloaded-virtual
-Wsynth -Wno-ctor-dtor-privacy -Wno-non-virtual-dtor -Wcast-align
-Wno-invalid-offsetof -Wno-variadic-macros -Wno-long-long
-pedantic -fno-strict-aliasing -pthread -pipe  -DNDEBUG -DTRIMMED -m64
-mtune=core2 -march=core2 -O2 -pipe -fmem-report
-fomit-frame-pointer   -DMOZILLA_CLIENT -include ./js-confdefs.h
-Wp,-MD,.deps/jsxml.pp
/home/name/LFS/firefox/mozilla-1.9.2/js/src/jsxml.cpp
{standard input}: Assembler messages:
{standard input}:271839: Warning: end of file not at end of a line;
newline inserted
{standard input}:271896: Error: suffix or operands invalid for `movq'
{standard input}:271896: Error: open CFI at the end of file; missing
.cfi_endproc directive
c++: Internal error: Killed (program cc1plus)
Please submit a full bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[4]: *** [jsxml.o] Error 1
make[4]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu/js/src'
make[3]: *** [libs_tier_js] Error 2
make[3]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu'
make[2]: *** [tier_js] Error 2
make[2]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu'
make[1]: *** [default] Error 2
make[1]: Leaving directory
`/home/name/LFS/firefox/mozilla-1.9.2/obj-x86_64-unknown-linux-gnu'
make: *** [build] Error 2




-- 
Justin P. Mattock
