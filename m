Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZBCT65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZBCT65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZBCT6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:58:47 -0500
Received: from host198.200-117-154.telecom.net.ar ([200.117.154.198]:37325
	"EHLO integratech.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbZBCT6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:58:44 -0500
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 14:58:40 EST
Message-ID: <4988A034.20406@lugmen.org.ar>
Date: Tue, 03 Feb 2009 17:51:16 -0200
From: Federico Cuello <fedux@lugmen.org.ar>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
References: <20090127093533.GB7037@charite.de> <497F77F6.40905@lugmen.org.ar> <200902031209.12615.nickpiggin@yahoo.com.au>
In-Reply-To: <200902031209.12615.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 28 January 2009 08:09:10 Federico Cuello wrote:
>   
>> Ralf Hildebrandt escribió:
>>     
>>> I recently installed 2.6.28.2 on our postfix/dovecot-based
>>> mailboxserver. Previously, 2.6.28 and 2.6.28.1 have been running there
>>> without a hitch.
>>>
>>> Now with 2.6.28.2 I had two major lockups: All writes to the users'
>>> Maildirs (on ext4) would stall, the load would rise, "sync" would never
>>> return.
>>>
>>> I had to "reboot -f -n" to get the machine back. All hanging processes
>>> were unkillable, even with kill -9.
>>> [...]
>>>       
>> The same is happening to me, but I have some logs taken with sysrq.
>>
>> Here is my vmstat output:
>>
>> procs -----------memory---------- ---swap-- -----io---- -system--
>> ----cpu----
>>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
>> id wa
>>  0  2  99028  46536  26356 1569400    0    0     0     0 1400  437  0
>> 3  0 96
>>  0  2  99028  46536  26356 1569400    0    0     0     0 1344  355  0
>> 6  0 94
>>  0  2  99028  46536  26356 1569400    0    0     0     0 1373  387  0
>> 0  0 100
>>  0  2  99028  46536  26364 1569400    0    0     0    12 1403  384  1
>> 0  0 99
>>  0  2  99028  46536  26364 1569400    0    0     0     0 1370  378  0
>> 0  0 100
>>  0  2  99028  46536  26364 1569400    0    0     0     0 1351  346  0
>> 0  0 100
>>  0  2  99028  46536  26364 1569400    0    0     0     0 1395  412  0
>> 0  0 100
>>  0  2  99028  46536  26364 1569400    0    0     0     0 1349  332  0
>> 0  0 100
>>  0  2  99028  46536  26368 1569400    0    0     4     0 1407  387  0
>> 0  0 100
>>
>> Notice the 100% iowait.
>>
>> I also managed to reproduce it doing a rsync from one partition to a USB
>> drive. After the lockup I can't read any file from the source partition,
>> but the other partitions can be accessed normally.
>>     
>
> Hm, thanks for reporting, can you guys get a sysrq+W trace when the system
> reaches this state?

Here it is, if you need something else please ask:

Jan 26 23:44:38 kaoz [10117.763822] SysRq : Show Memory
Jan 26 23:44:38 kaoz [10117.765692] Mem-Info:
Jan 26 23:44:38 kaoz [10117.767141] DMA per-cpu:
Jan 26 23:44:38 kaoz [10117.769184] CPU    0: hi:    0, btch:   1 usd:   0
Jan 26 23:44:38 kaoz [10117.769184] CPU    1: hi:    0, btch:   1 usd:   0
Jan 26 23:44:38 kaoz [10117.769184] DMA32 per-cpu:
Jan 26 23:44:38 kaoz [10117.769184] CPU    0: hi:  186, btch:  31 usd:  42
Jan 26 23:44:38 kaoz [10117.769184] CPU    1: hi:  186, btch:  31 usd:  31
Jan 26 23:44:38 kaoz [10117.769184] Active_anon:24752 active_file:11041
inactive_anon:10001
Jan 26 23:44:38 kaoz [10117.769184]  inactive_file:396899 unevictable:0
dirty:70 writeback:0 unstable:0
Jan 26 23:44:38 kaoz [10117.769184]  free:43547 slab:15243 mapped:7057
pagetables:1711 bounce:0
Jan 26 23:44:38 kaoz [10117.769184] DMA free:8092kB min:28kB low:32kB
high:40kB active_anon:0kB inactive_anon:12kB active_file:2360kB
inactive_file:1324kB unevictable:0kB present:11100kB pages_scanned:0
all_unreclaimable? no
Jan 26 23:44:38 kaoz [10117.785214] lowmem_reserve[]: 0 2004 2004 2004
Jan 26 23:44:38 kaoz [10117.785214] DMA32 free:165928kB min:5712kB
low:7140kB high:8568kB active_anon:99008kB inactive_anon:39992kB
active_file:41804kB inactive_file:1586396kB unevictable:0kB
present:2052128kB pages_scanned:0 all_unreclaimable? no
Jan 26 23:44:38 kaoz [10117.785214] lowmem_reserve[]: 0 0 0 0
Jan 26 23:44:38 kaoz [10117.785214] DMA: 15*4kB 24*8kB 20*16kB 21*32kB
19*64kB 10*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8092kB
Jan 26 23:44:38 kaoz [10117.785214] DMA32: 5284*4kB 5258*8kB 995*16kB
486*32kB 336*64kB 127*128kB 40*256kB 19*512kB 9*1024kB 2*2048kB 0*4096kB
= 165712kB
Jan 26 23:44:38 kaoz [10117.785214] 409973 total pagecache pages
Jan 26 23:44:38 kaoz [10117.785214] 1917 pages in swap cache
Jan 26 23:44:38 kaoz [10117.785214] Swap cache stats: add 38607, delete
36690, find 9693/11511
Jan 26 23:44:38 kaoz [10117.785214] Free swap  = 1037804kB
Jan 26 23:44:38 kaoz [10117.785214] Total swap = 1048568kB
Jan 26 23:44:38 kaoz [10117.785214] 524240 pages RAM
Jan 26 23:44:38 kaoz [10117.785214] 9080 pages reserved
Jan 26 23:44:38 kaoz [10117.785214] 192696 pages shared
Jan 26 23:44:38 kaoz [10117.785214] 286249 pages non-shared
Jan 26 23:44:38 kaoz [10123.434993] SysRq : Emergency Remount R/O
Jan 26 23:44:38 kaoz [10127.036454] SysRq : HELP : loglevel0-8 reBoot
tErm Full kIll saK aLlcpus showMem Nice powerOff showPc
show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks
Jan 26 23:44:38 kaoz [10136.390066] SysRq : Show Blocked State
Jan 26 23:44:38 kaoz [10136.391430]   task                        PC
stack   pid father
Jan 26 23:44:38 kaoz [10136.392801] kjournald2    D ffff880001014c20
 0  4635      2
Jan 26 23:44:38 kaoz [10136.393391]  ffff88007e5e7d50 0000000000000046
ffff8800581e9d00 ffff88007e5e38a0
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88007ea6ad80
ffffffff80544340 ffff88007ea6afe8
Jan 26 23:44:38 kaoz [10136.393391]  0000000000000000 000000010023bf96
ffff88007ea6afe8 ffff88007c5df090
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022e140>]
update_curr+0xd0/0x140
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031d561>]
jbd2_journal_commit_transaction+0x171/0x1240
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80474ef7>]
thread_return+0x3d/0x5e6
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80246204>]
lock_timer_base+0x34/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80246294>]
try_to_del_timer_sync+0x54/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80322548>]
kjournald2+0xd8/0x230
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80322470>]
kjournald2+0x0/0x230
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802519b7>] kthread+0x47/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802386c7>]
schedule_tail+0x27/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251970>] kthread+0x0/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Jan 26 23:44:38 kaoz [10136.393391] quasselcore   D ffff88000100ad98
 0  6054      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88006d2e5bb8 0000000000000082
ffff88007c5dec00 ffffffff80496fd0
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88007c52b8e0
ffff88005597c9f0 ffff88007c52bb48
Jan 26 23:44:38 kaoz [10136.393391]  0000000100000004 000000010023b9b0
ffff88007c52bb48 ffffffff802fa6a1
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fa6a1>]
ext4_da_write_end+0x141/0x280
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffffa008c6cc>]
dm_table_unplug_all+0x3c/0x90 [dm_mod]
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f940>] sync_page+0x0/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff804754d7>]
io_schedule+0x37/0x50
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f975>]
sync_page+0x35/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8047585a>]
__wait_on_bit_lock+0x4a/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f91e>]
__lock_page+0x5e/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251db0>]
wake_bit_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80276d1d>]
write_cache_pages+0x1ed/0x3d0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fbea0>]
__mpage_da_writepage+0x0/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fbc57>]
ext4_da_writepages+0x237/0x3b0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fd1b0>]
ext4_da_get_block_write+0x0/0x160
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80276f50>]
do_writepages+0x20/0x40
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8027077d>]
__filemap_fdatawrite_range+0x4d/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802c12c5>] do_fsync+0x45/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802c138e>]
__do_fsync+0x2e/0x50
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] klauncher     D ffff880001020c20
 0  7760      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff880060b65cf0 0000000000000086
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8cc9f0
ffff88007f862220 ffff88005b8ccc58
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 00000001002ce821
ffff88005b8ccc58 ffff880060b65cc8
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802476c0>]
do_sigaction+0x130/0x1c0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] kded4         D ffff880001020c20
 0  7762      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff880060999cf0 0000000000000086
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8b8000
ffff88007f862220 ffff88005b8b8268
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 00000001002c4165
ffff88005b8b8268 ffff880060999e08
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8028eda5>]
free_pages_and_swap_cache+0x85/0xb0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802867a0>]
unmap_region+0x180/0x1a0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] ksmserver     D ffff8800583319c8
 0  7773      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88005bb99cf0 0000000000000086
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8bb8e0
ffff88007c52e0b0 ffff88005b8bbb48
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 ffffe200006b6fe0
ffff88005b8bbb48 ffff88005bb99cc8
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251c60>]
bit_waitqueue+0x10/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802b0673>] d_kill+0x53/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] kwin          D ffff8800583319c8
 0  7775   7773
Jan 26 23:44:38 kaoz [10136.393391]  ffff88005ba6bcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8bf1c0
ffff88007c52e660 ffff88005b8bf428
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 ffffe200008c8618
ffff88005b8bf428 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] nepomukserver D ffff8800583319c8
 0  7778      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88007c0bfcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8b9110
ffff88007c52e660 ffff88005b8b9378
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 ffffe200005c0370
ffff88005b8b9378 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] plasma        D ffff880001020c20
 0  7781      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88005b8ddcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8be660
ffff88007f862220 ffff88005b8be8c8
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 00000001002c24a1
ffff88005b8be8c8 ffff88005b8dde08
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a3350>]
vfs_lstat_fd+0x20/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] mysqld        D 0000000000000002
 0  7820   7804
Jan 26 23:44:38 kaoz [10136.393391]  ffff880063a39b58 0000000000000082
ffff880063a39ad8 ffffffff80236cbb
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8cb8e0
ffff88005597f770 ffff88005b8cbb48
Jan 26 23:44:38 kaoz [10136.393391]  0000000163a39b98 ffffffff80474ef7
ffff88005b8cbb48 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80236cbb>]
finish_task_switch+0x2b/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80474ef7>]
thread_return+0x3d/0x5e6
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f9bc6>]
ext4_dirty_inode+0x36/0xb0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802be294>]
__mark_inode_dirty+0x34/0x1d0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802b33a0>]
file_update_time+0x110/0x130
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80270fd6>]
__generic_file_aio_write_nolock+0x246/0x470
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80280382>]
__do_fault+0x202/0x4c0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b64>]
generic_file_aio_write+0x64/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80223b50>]
flat_send_IPI_mask+0x0/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] pdflush       D ffff880001014c20
 0  9198      2
Jan 26 23:44:38 kaoz [10136.393391]  ffff88003c311a20 0000000000000046
ffff88007ea00000 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005597d550
ffffffff80544340 ffff88005597d7b8
Jan 26 23:44:38 kaoz [10136.393391]  0000000000000000 000000010023b9b6
ffff88005597d7b8 ffff88005591d900
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8032f3c7>]
generic_make_request+0x207/0x340
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffffa008c6cc>]
dm_table_unplug_all+0x3c/0x90 [dm_mod]
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f940>] sync_page+0x0/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff804754d7>]
io_schedule+0x37/0x50
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f975>]
sync_page+0x35/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8047585a>]
__wait_on_bit_lock+0x4a/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f91e>]
__lock_page+0x5e/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251db0>]
wake_bit_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802786ca>]
pagevec_lookup_tag+0x1a/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80276d1d>]
write_cache_pages+0x1ed/0x3d0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fbea0>]
__mpage_da_writepage+0x0/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031bb5f>]
jbd2_journal_stop+0x17f/0x200
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fbc57>]
ext4_da_writepages+0x237/0x3b0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022e6a7>]
dequeue_task+0x57/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80236cbb>]
finish_task_switch+0x2b/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802fd1b0>]
ext4_da_get_block_write+0x0/0x160
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80276f50>]
do_writepages+0x20/0x40
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802bd526>]
__writeback_single_inode+0xa6/0x470
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802bdeb0>]
generic_sync_sb_inodes+0x370/0x4d0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802be1cd>]
writeback_inodes+0x4d/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802775e3>]
background_writeout+0xb3/0xf0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80277d1b>]
pdflush+0x15b/0x240
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80277530>]
background_writeout+0x0/0xf0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80277bc0>] pdflush+0x0/0x240
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802519b7>] kthread+0x47/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802386c7>]
schedule_tail+0x27/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251970>] kthread+0x0/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Jan 26 23:44:38 kaoz [10136.393391] krunner_lock  D 0000000000000002
 0  9309      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88005b843b58 0000000000000082
ffff88005b843ad8 ffffffff8022e140
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88006d3eec10
ffff88007c52a7d0 ffff88006d3eee78
Jan 26 23:44:38 kaoz [10136.393391]  000000015b843b08 ffffffff8022f9f8
ffff88006d3eee78 ffff8800010252f0
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022e140>]
update_curr+0xd0/0x140
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022f9f8>]
dequeue_entity+0x18/0x190
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022f958>]
set_next_entity+0x38/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f9bc6>]
ext4_dirty_inode+0x36/0xb0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802be294>]
__mark_inode_dirty+0x34/0x1d0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802b33a0>]
file_update_time+0x110/0x130
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80270fd6>]
__generic_file_aio_write_nolock+0x246/0x470
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80280382>]
__do_fault+0x202/0x4c0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b64>]
generic_file_aio_write+0x64/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8028eda5>]
free_pages_and_swap_cache+0x85/0xb0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802867a0>]
unmap_region+0x180/0x1a0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] krunner_lock  D ffff8800583319c8
 0  9310   9309
Jan 26 23:44:38 kaoz [10136.393391]  ffff88007fa9bcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88006d3ee660
ffff8800708d9c70 ffff88006d3ee8c8
Jan 26 23:44:38 kaoz [10136.393391]  00000001805e19e0 ffffe200010d3fb0
ffff88006d3ee8c8 ffff88007fa9bed8
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8024940f>]
kill_pid_info+0x4f/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802496c2>]
sys_kill+0xa2/0x1c0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] kblankscrn.ks D ffff880001020c20
 0  9313   9310
Jan 26 23:44:38 kaoz [10136.393391]  ffff88004c291cf0 0000000000000082
ffffe200010d3fb0 ffffffff805e19e0
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88006d3eb8e0
ffff88007f862220 ffff88006d3ebb48
Jan 26 23:44:38 kaoz [10136.393391]  0000000180279245 000000010024fa44
ffff88006d3ebb48 ffffffff80570008
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80286726>]
unmap_region+0x106/0x1a0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] less          D ffff880001014c20
 0  9633      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88003ba2bec0 0000000000000086
ffff88003ba2be68 0000000000008000
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff8800708d96c0
ffffffff80544340 ffff8800708d9928
Jan 26 23:44:38 kaoz [10136.393391]  0000000000000001 0000000100282d66
ffff8800708d9928 000000000000fe03
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a06ff>]
generic_file_llseek+0x2f/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029f31e>]
sys_lseek+0x7e/0x90
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029da9b>]
do_sys_open+0xeb/0x110
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] pdflush       D ffffffff80552468
 0  9675      2
Jan 26 23:44:38 kaoz [10136.393391]  ffff880041ac9e38 0000000000000046
ffffffff80270658 ffff880041ac9dc0
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8bbe90
ffff88007f863330 ffff88005b8bc0f8
Jan 26 23:44:38 kaoz [10136.393391]  000000017f85ff00 ffff880041ac9de0
ffff88005b8bc0f8 ffffffff805e5b80
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80270658>]
wait_on_page_writeback_range+0x78/0x130
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80276f50>]
do_writepages+0x20/0x40
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a15c3>]
sync_filesystems+0x13/0x130
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802c145e>] do_sync+0x1e/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80277d1b>]
pdflush+0x15b/0x240
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802c1440>] do_sync+0x0/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80277bc0>] pdflush+0x0/0x240
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802519b7>] kthread+0x47/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802386c7>]
schedule_tail+0x27/0x70
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251970>] kthread+0x0/0x80
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Jan 26 23:44:38 kaoz [10136.393391] shutdown      D ffff880001020c20
 0 10071      1
Jan 26 23:44:38 kaoz [10136.393391]  ffff88003ac5de68 0000000000000086
ffff88003ac5de78 ffffffff80474ef7
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005b8bad80
ffff88007f862220 ffff88005b8bafe8
Jan 26 23:44:38 kaoz [10136.393391]  000000017f862220 00000001002c243e
ffff88005b8bafe8 00000001002c2435
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80474ef7>]
thread_return+0x3d/0x5e6
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031d1fe>]
jbd2_journal_force_commit+0xe/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a1687>]
sync_filesystems+0xd7/0x130
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802c1465>] do_sync+0x25/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802c14ae>] sys_sync+0xe/0x20
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10136.393391] kdm           D ffff880001014c20
 0 10137   6943
Jan 26 23:44:38 kaoz [10136.393391]  ffff88005b953cd8 0000000000000086
ffffffff80570008 ffff880062e76a28
Jan 26 23:44:38 kaoz [10136.393391]  ffffffff805de000 ffff88005bbf5b00
ffffffff80544340 ffff88005bbf5d68
Jan 26 23:44:38 kaoz [10136.393391]  0000000000000012 00000001002ce9e5
ffff88005bbf5d68 ffffffff805e19e0
Jan 26 23:44:38 kaoz [10136.393391] Call Trace:
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802b2557>]
__d_lookup+0xc7/0x140
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff80301cf5>]
ext4_create+0x85/0x120
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a904e>]
vfs_create+0xae/0xf0
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802ac836>]
do_filp_open+0x856/0x960
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8022e140>]
update_curr+0xd0/0x140
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802a33c3>]
vfs_stat_fd+0x23/0x60
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff802b5c42>]
alloc_fd+0x122/0x150
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8029da30>]
do_sys_open+0x80/0x110
Jan 26 23:44:38 kaoz [10136.393391]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.340218] SysRq : Show Blocked State
Jan 26 23:44:38 kaoz [10141.341232]   task                        PC
stack   pid father
Jan 26 23:44:38 kaoz [10141.342274] kjournald2    D ffff880001014c20
 0  4635      2
Jan 26 23:44:38 kaoz [10141.343331]  ffff88007e5e7d50 0000000000000046
ffff8800581e9d00 ffff88007e5e38a0
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88007ea6ad80
ffffffff80544340 ffff88007ea6afe8
Jan 26 23:44:38 kaoz [10141.343544]  0000000000000000 000000010023bf96
ffff88007ea6afe8 ffff88007c5df090
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022e140>]
update_curr+0xd0/0x140
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031d561>]
jbd2_journal_commit_transaction+0x171/0x1240
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80474ef7>]
thread_return+0x3d/0x5e6
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80246204>]
lock_timer_base+0x34/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80246294>]
try_to_del_timer_sync+0x54/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80322548>]
kjournald2+0xd8/0x230
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80322470>]
kjournald2+0x0/0x230
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802519b7>] kthread+0x47/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802386c7>]
schedule_tail+0x27/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251970>] kthread+0x0/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Jan 26 23:44:38 kaoz [10141.343544] quasselcore   D ffff88000100ad98
 0  6054      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88006d2e5bb8 0000000000000082
ffff88007c5dec00 ffffffff80496fd0
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88007c52b8e0
ffff88005597c9f0 ffff88007c52bb48
Jan 26 23:44:38 kaoz [10141.343544]  0000000100000004 000000010023b9b0
ffff88007c52bb48 ffffffff802fa6a1
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fa6a1>]
ext4_da_write_end+0x141/0x280
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffffa008c6cc>]
dm_table_unplug_all+0x3c/0x90 [dm_mod]
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f940>] sync_page+0x0/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff804754d7>]
io_schedule+0x37/0x50
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f975>]
sync_page+0x35/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8047585a>]
__wait_on_bit_lock+0x4a/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f91e>]
__lock_page+0x5e/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251db0>]
wake_bit_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80276d1d>]
write_cache_pages+0x1ed/0x3d0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fbea0>]
__mpage_da_writepage+0x0/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fbc57>]
ext4_da_writepages+0x237/0x3b0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fd1b0>]
ext4_da_get_block_write+0x0/0x160
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80276f50>]
do_writepages+0x20/0x40
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8027077d>]
__filemap_fdatawrite_range+0x4d/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802c12c5>] do_fsync+0x45/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802c138e>]
__do_fsync+0x2e/0x50
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] klauncher     D ffff880001020c20
 0  7760      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff880060b65cf0 0000000000000086
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8cc9f0
ffff88007f862220 ffff88005b8ccc58
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 00000001002ce821
ffff88005b8ccc58 ffff880060b65cc8
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802476c0>]
do_sigaction+0x130/0x1c0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] kded4         D ffff880001020c20
 0  7762      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff880060999cf0 0000000000000086
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8b8000
ffff88007f862220 ffff88005b8b8268
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 00000001002c4165
ffff88005b8b8268 ffff880060999e08
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8028eda5>]
free_pages_and_swap_cache+0x85/0xb0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802867a0>]
unmap_region+0x180/0x1a0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] ksmserver     D ffff8800583319c8
 0  7773      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88005bb99cf0 0000000000000086
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8bb8e0
ffff88007c52e0b0 ffff88005b8bbb48
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 ffffe200006b6fe0
ffff88005b8bbb48 ffff88005bb99cc8
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251c60>]
bit_waitqueue+0x10/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802b0673>] d_kill+0x53/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] kwin          D ffff8800583319c8
 0  7775   7773
Jan 26 23:44:38 kaoz [10141.343544]  ffff88005ba6bcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8bf1c0
ffff88007c52e660 ffff88005b8bf428
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 ffffe200008c8618
ffff88005b8bf428 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022f783>]
__wake_up+0x43/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] nepomukserver D ffff8800583319c8
 0  7778      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88007c0bfcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8b9110
ffff88007c52e660 ffff88005b8b9378
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 ffffe200005c0370
ffff88005b8b9378 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] plasma        D ffff880001020c20
 0  7781      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88005b8ddcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8be660
ffff88007f862220 ffff88005b8be8c8
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 00000001002c24a1
ffff88005b8be8c8 ffff88005b8dde08
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a3350>]
vfs_lstat_fd+0x20/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] mysqld        D 0000000000000002
 0  7820   7804
Jan 26 23:44:38 kaoz [10141.343544]  ffff880063a39b58 0000000000000082
ffff880063a39ad8 ffffffff80236cbb
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8cb8e0
ffff88005597f770 ffff88005b8cbb48
Jan 26 23:44:38 kaoz [10141.343544]  0000000163a39b98 ffffffff80474ef7
ffff88005b8cbb48 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80236cbb>]
finish_task_switch+0x2b/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80474ef7>]
thread_return+0x3d/0x5e6
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f9bc6>]
ext4_dirty_inode+0x36/0xb0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802be294>]
__mark_inode_dirty+0x34/0x1d0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802b33a0>]
file_update_time+0x110/0x130
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80270fd6>]
__generic_file_aio_write_nolock+0x246/0x470
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80280382>]
__do_fault+0x202/0x4c0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b64>]
generic_file_aio_write+0x64/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80223b50>]
flat_send_IPI_mask+0x0/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] pdflush       D ffff880001014c20
 0  9198      2
Jan 26 23:44:38 kaoz [10141.343544]  ffff88003c311a20 0000000000000046
ffff88007ea00000 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005597d550
ffffffff80544340 ffff88005597d7b8
Jan 26 23:44:38 kaoz [10141.343544]  0000000000000000 000000010023b9b6
ffff88005597d7b8 ffff88005591d900
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8032f3c7>]
generic_make_request+0x207/0x340
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffffa008c6cc>]
dm_table_unplug_all+0x3c/0x90 [dm_mod]
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f940>] sync_page+0x0/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff804754d7>]
io_schedule+0x37/0x50
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f975>]
sync_page+0x35/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8047585a>]
__wait_on_bit_lock+0x4a/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f91e>]
__lock_page+0x5e/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251db0>]
wake_bit_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802786ca>]
pagevec_lookup_tag+0x1a/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80276d1d>]
write_cache_pages+0x1ed/0x3d0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fbea0>]
__mpage_da_writepage+0x0/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031bb5f>]
jbd2_journal_stop+0x17f/0x200
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fbc57>]
ext4_da_writepages+0x237/0x3b0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022e6a7>]
dequeue_task+0x57/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80236cbb>]
finish_task_switch+0x2b/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802fd1b0>]
ext4_da_get_block_write+0x0/0x160
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80276f50>]
do_writepages+0x20/0x40
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802bd526>]
__writeback_single_inode+0xa6/0x470
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802bdeb0>]
generic_sync_sb_inodes+0x370/0x4d0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802be1cd>]
writeback_inodes+0x4d/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802775e3>]
background_writeout+0xb3/0xf0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80277d1b>]
pdflush+0x15b/0x240
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80277530>]
background_writeout+0x0/0xf0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80277bc0>] pdflush+0x0/0x240
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802519b7>] kthread+0x47/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802386c7>]
schedule_tail+0x27/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251970>] kthread+0x0/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Jan 26 23:44:38 kaoz [10141.343544] krunner_lock  D 0000000000000002
 0  9309      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88005b843b58 0000000000000082
ffff88005b843ad8 ffffffff8022e140
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88006d3eec10
ffff88007c52a7d0 ffff88006d3eee78
Jan 26 23:44:38 kaoz [10141.343544]  000000015b843b08 ffffffff8022f9f8
ffff88006d3eee78 ffff8800010252f0
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022e140>]
update_curr+0xd0/0x140
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022f9f8>]
dequeue_entity+0x18/0x190
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022f958>]
set_next_entity+0x38/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f9bc6>]
ext4_dirty_inode+0x36/0xb0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802be294>]
__mark_inode_dirty+0x34/0x1d0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802b33a0>]
file_update_time+0x110/0x130
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80270fd6>]
__generic_file_aio_write_nolock+0x246/0x470
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80280382>]
__do_fault+0x202/0x4c0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b64>]
generic_file_aio_write+0x64/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8028eda5>]
free_pages_and_swap_cache+0x85/0xb0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802867a0>]
unmap_region+0x180/0x1a0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] krunner_lock  D ffff8800583319c8
 0  9310   9309
Jan 26 23:44:38 kaoz [10141.343544]  ffff88007fa9bcf0 0000000000000082
ffffffff8026f7ad 0000000000000000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88006d3ee660
ffff8800708d9c70 ffff88006d3ee8c8
Jan 26 23:44:38 kaoz [10141.343544]  00000001805e19e0 ffffe200010d3fb0
ffff88006d3ee8c8 ffff88007fa9bed8
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8026f7ad>]
find_get_page+0x8d/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8024940f>]
kill_pid_info+0x4f/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802496c2>]
sys_kill+0xa2/0x1c0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] kblankscrn.ks D ffff880001020c20
 0  9313   9310
Jan 26 23:44:38 kaoz [10141.343544]  ffff88004c291cf0 0000000000000082
ffffe200010d3fb0 ffffffff805e19e0
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88006d3eb8e0
ffff88007f862220 ffff88006d3ebb48
Jan 26 23:44:38 kaoz [10141.343544]  0000000180279245 000000010024fa44
ffff88006d3ebb48 ffffffff80570008
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80271b4f>]
generic_file_aio_write+0x4f/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802f67e8>]
ext4_file_write+0x58/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f69b>]
do_sync_write+0xdb/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80227320>]
do_page_fault+0x300/0x970
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80286726>]
unmap_region+0x106/0x1a0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a00bb>]
vfs_write+0xcb/0x170
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a0263>]
sys_write+0x53/0xa0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] less          D ffff880001014c20
 0  9633      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88003ba2bec0 0000000000000086
ffff88003ba2be68 0000000000008000
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff8800708d96c0
ffffffff80544340 ffff8800708d9928
Jan 26 23:44:38 kaoz [10141.343544]  0000000000000001 0000000100282d66
ffff8800708d9928 000000000000fe03
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a06ff>]
generic_file_llseek+0x2f/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029f31e>]
sys_lseek+0x7e/0x90
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029da9b>]
do_sys_open+0xeb/0x110
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] pdflush       D ffffffff80552468
 0  9675      2
Jan 26 23:44:38 kaoz [10141.343544]  ffff880041ac9e38 0000000000000046
ffffffff80270658 ffff880041ac9dc0
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8bbe90
ffff88007f863330 ffff88005b8bc0f8
Jan 26 23:44:38 kaoz [10141.343544]  000000017f85ff00 ffff880041ac9de0
ffff88005b8bc0f8 ffffffff805e5b80
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80270658>]
wait_on_page_writeback_range+0x78/0x130
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80276f50>]
do_writepages+0x20/0x40
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475c25>]
__mutex_lock_slowpath+0x75/0xc0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80475a5a>]
mutex_lock+0xa/0x10
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a15c3>]
sync_filesystems+0x13/0x130
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802c145e>] do_sync+0x1e/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80277d1b>]
pdflush+0x15b/0x240
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802c1440>] do_sync+0x0/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80277bc0>] pdflush+0x0/0x240
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802519b7>] kthread+0x47/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802386c7>]
schedule_tail+0x27/0x70
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251970>] kthread+0x0/0x80
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Jan 26 23:44:38 kaoz [10141.343544] shutdown      D ffff880001020c20
 0 10071      1
Jan 26 23:44:38 kaoz [10141.343544]  ffff88003ac5de68 0000000000000086
ffff88003ac5de78 ffffffff80474ef7
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005b8bad80
ffff88007f862220 ffff88005b8bafe8
Jan 26 23:44:38 kaoz [10141.343544]  000000017f862220 00000001002c243e
ffff88005b8bafe8 00000001002c2435
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80474ef7>]
thread_return+0x3d/0x5e6
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031d1fe>]
jbd2_journal_force_commit+0xe/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a1687>]
sync_filesystems+0xd7/0x130
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802c1465>] do_sync+0x25/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802c14ae>] sys_sync+0xe/0x20
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10141.343544] kdm           D ffff880001014c20
 0 10137   6943
Jan 26 23:44:38 kaoz [10141.343544]  ffff88005b953cd8 0000000000000086
ffffffff80570008 ffff880062e76a28
Jan 26 23:44:38 kaoz [10141.343544]  ffffffff805de000 ffff88005bbf5b00
ffffffff80544340 ffff88005bbf5d68
Jan 26 23:44:38 kaoz [10141.343544]  0000000000000012 00000001002ce9e5
ffff88005bbf5d68 ffffffff805e19e0
Jan 26 23:44:38 kaoz [10141.343544] Call Trace:
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802b2557>]
__d_lookup+0xc7/0x140
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031cebb>]
start_this_handle+0x33b/0x450
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80251d80>]
autoremove_wake_function+0x0/0x30
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8031d1a6>]
jbd2_journal_start+0x96/0xe0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff80301cf5>]
ext4_create+0x85/0x120
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a904e>]
vfs_create+0xae/0xf0
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802ac836>]
do_filp_open+0x856/0x960
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8022e140>]
update_curr+0xd0/0x140
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802a33c3>]
vfs_stat_fd+0x23/0x60
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff802b5c42>]
alloc_fd+0x122/0x150
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8029da30>]
do_sys_open+0x80/0x110
Jan 26 23:44:38 kaoz [10141.343544]  [<ffffffff8020b8cb>]
system_call_fastpath+0x16/0x1b
Jan 26 23:44:38 kaoz [10155.129152] SysRq : HELP : loglevel0-8 reBoot
tErm Full kIll saK aLlcpus showMem Nice powerOff showPc
show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks
Jan 26 23:44:38 kaoz [10161.699932] SysRq : Show clockevent devices &
pending hrtimers (no others)
Jan 26 23:44:38 kaoz [10161.701338] Timer List Version: v0.4
Jan 26 23:44:38 kaoz [10161.702747] HRTIMER_MAX_CLOCK_BASES: 2
Jan 26 23:44:38 kaoz [10161.703258] now at 10161701339810 nsecs
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258] cpu: 0
Jan 26 23:44:38 kaoz [10161.703258]  clock 0:
Jan 26 23:44:38 kaoz [10161.703258]   .base:       ffff880001015428
Jan 26 23:44:38 kaoz [10161.703258]   .index:      0
Jan 26 23:44:38 kaoz [10161.703258]   .resolution: 1 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .get_time:   ktime_get_real
Jan 26 23:44:38 kaoz [10161.703258]   .offset:     1233010481853079954 nsecs
Jan 26 23:44:38 kaoz [10161.703258] active timers:
Jan 26 23:44:38 kaoz [10161.703258]  clock 1:
Jan 26 23:44:38 kaoz [10161.703258]   .base:       ffff880001015468
Jan 26 23:44:38 kaoz [10161.703258]   .index:      1
Jan 26 23:44:38 kaoz [10161.703258]   .resolution: 1 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .get_time:   ktime_get
Jan 26 23:44:38 kaoz [10161.703258]   .offset:     0 nsecs
Jan 26 23:44:38 kaoz [10161.703258] active timers:
Jan 26 23:44:38 kaoz [10161.703258]  #0: <ffff880001015500>,
tick_sched_timer, S:01
Jan 26 23:44:38 kaoz [10161.703258]  # expires at
10162345650432-10162345650432 nsecs [in 644310622 to 644310622 nsecs]
Jan 26 23:44:38 kaoz [10161.703258]  #1: <ffff88005bb220e8>, it_real_fn,
S:01
Jan 26 23:44:38 kaoz [10161.703258]  # expires at
32702039507086-32702039507086 nsecs [in 22540338167276 to 22540338167276
nsecs]
Jan 26 23:44:38 kaoz [10161.703258]   .expires_next   : 10162345650432 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .hres_active    : 1
Jan 26 23:44:38 kaoz [10161.703258]   .nr_events      : 1715455
Jan 26 23:44:38 kaoz [10161.703258]   .nohz_mode      : 2
Jan 26 23:44:38 kaoz [10161.703258]   .idle_tick      : 10161348983865 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .tick_stopped   : 1
Jan 26 23:44:38 kaoz [10161.703258]   .idle_jiffies   : 4297925700
Jan 26 23:44:38 kaoz [10161.703258]   .idle_calls     : 2284355
Jan 26 23:44:38 kaoz [10161.703258]   .idle_sleeps    : 164609
Jan 26 23:44:38 kaoz [10161.703258]   .idle_entrytime : 10161737675287 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .idle_waketime  : 10161737671047 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .idle_exittime  : 10161345670207 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .idle_sleeptime : 8728154262894 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .last_jiffies   : 4297925817
Jan 26 23:44:38 kaoz [10161.703258]   .next_jiffies   : 4297926000
Jan 26 23:44:38 kaoz [10161.703258]   .idle_expires   : 10162345650432 nsecs
Jan 26 23:44:38 kaoz [10161.703258] jiffies: 4297925817
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258] cpu: 1
Jan 26 23:44:38 kaoz [10161.703258]  clock 0:
Jan 26 23:44:38 kaoz [10161.703258]   .base:       ffff880001021428
Jan 26 23:44:38 kaoz [10161.703258]   .index:      0
Jan 26 23:44:38 kaoz [10161.703258]   .resolution: 1 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .get_time:   ktime_get_real
Jan 26 23:44:38 kaoz [10161.703258]   .offset:     1233010481853079954 nsecs
Jan 26 23:44:38 kaoz [10161.703258] active timers:
Jan 26 23:44:38 kaoz [10161.703258]  clock 1:
Jan 26 23:44:38 kaoz [10161.703258]   .base:       ffff880001021468
Jan 26 23:44:38 kaoz [10161.703258]   .index:      1
Jan 26 23:44:38 kaoz [10161.703258]   .resolution: 1 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .get_time:   ktime_get
Jan 26 23:44:38 kaoz [10161.703258]   .offset:     0 nsecs
Jan 26 23:44:38 kaoz [10161.703258] active timers:
Jan 26 23:44:38 kaoz [10161.703258]  #0: <ffff88007f85d9a8>,
hrtimer_wakeup, S:01
Jan 26 23:44:38 kaoz [10161.703258]  # expires at
10161860916333-10161865916331 nsecs [in 159576523 to 164576521 nsecs]
Jan 26 23:44:38 kaoz [10161.703258]  #1: <ffff880001021500>,
tick_sched_timer, S:01
Jan 26 23:44:38 kaoz [10161.703258]  # expires at
10161878983812-10161878983812 nsecs [in 177644002 to 177644002 nsecs]
Jan 26 23:44:38 kaoz [10161.703258]   .expires_next   : 10161865916331 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .hres_active    : 1
Jan 26 23:44:38 kaoz [10161.703258]   .nr_events      : 2322638
Jan 26 23:44:38 kaoz [10161.703258]   .nohz_mode      : 2
Jan 26 23:44:38 kaoz [10161.703258]   .idle_tick      : 10161683150498 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .tick_stopped   : 1
Jan 26 23:44:38 kaoz [10161.703258]   .idle_jiffies   : 4297925800
Jan 26 23:44:38 kaoz [10161.703258]   .idle_calls     : 13381452
Jan 26 23:44:38 kaoz [10161.703258]   .idle_sleeps    : 5700675
Jan 26 23:44:38 kaoz [10161.703258]   .idle_entrytime : 10161699594129 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .idle_waketime  : 10161699926354 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .idle_exittime  : 10161676129546 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .idle_sleeptime : 7638933463214 nsecs
Jan 26 23:44:38 kaoz [10161.703258]   .last_jiffies   : 4297925806
Jan 26 23:44:38 kaoz [10161.703258]   .next_jiffies   : 4297925860
Jan 26 23:44:38 kaoz [10161.703258]   .idle_expires   : 10161878983812 nsecs
Jan 26 23:44:38 kaoz [10161.703258] jiffies: 4297925826
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258] Tick Device: mode:     1
Jan 26 23:44:38 kaoz [10161.703258] Broadcast device
Jan 26 23:44:38 kaoz [10161.703258] Clock Event Device: hpet
Jan 26 23:44:38 kaoz [10161.703258]  max_delta_ns:   85899346200
Jan 26 23:44:38 kaoz [10161.703258]  min_delta_ns:   5000
Jan 26 23:44:38 kaoz [10161.703258]  mult:           107374182
Jan 26 23:44:38 kaoz [10161.703258]  shift:          32
Jan 26 23:44:38 kaoz [10161.703258]  mode:           3
Jan 26 23:44:38 kaoz [10161.703258]  next_event:     9223372036854775807
nsecs
Jan 26 23:44:38 kaoz [10161.703258]  set_next_event: hpet_legacy_next_event
Jan 26 23:44:38 kaoz [10161.703258]  set_mode:       hpet_legacy_set_mode
Jan 26 23:44:38 kaoz [10161.703258]  event_handler:
tick_handle_oneshot_broadcast
Jan 26 23:44:38 kaoz [10161.703258] tick_broadcast_mask: 00000000
Jan 26 23:44:38 kaoz [10161.703258] tick_broadcast_oneshot_mask: 00000000
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258] Tick Device: mode:     1
Jan 26 23:44:38 kaoz [10161.703258] Per CPU device: 0
Jan 26 23:44:38 kaoz [10161.703258] Clock Event Device: lapic
Jan 26 23:44:38 kaoz [10161.703258]  max_delta_ns:   671049102
Jan 26 23:44:38 kaoz [10161.703258]  min_delta_ns:   1199
Jan 26 23:44:38 kaoz [10161.703258]  mult:           53690248
Jan 26 23:44:38 kaoz [10161.703258]  shift:          32
Jan 26 23:44:38 kaoz [10161.703258]  mode:           3
Jan 26 23:44:38 kaoz [10161.703258]  next_event:     10162345650432 nsecs
Jan 26 23:44:38 kaoz [10161.703258]  set_next_event: lapic_next_event
Jan 26 23:44:38 kaoz [10161.703258]  set_mode:       lapic_timer_setup
Jan 26 23:44:38 kaoz [10161.703258]  event_handler:  hrtimer_interrupt
Jan 26 23:44:38 kaoz [10161.703258]
Jan 26 23:44:38 kaoz [10161.703258] Tick Device: mode:     1
Jan 26 23:44:38 kaoz [10161.703258] Per CPU device: 1
Jan 26 23:44:38 kaoz [10161.703258] Clock Event Device: lapic
Jan 26 23:44:38 kaoz [10161.703258]  max_delta_ns:   671049102
Jan 26 23:44:38 kaoz [10161.703258]  min_delta_ns:   1199
Jan 26 23:44:38 kaoz [10161.703258]  mult:           53690248
Jan 26 23:44:38 kaoz [10161.703258]  shift:          32
Jan 26 23:44:38 kaoz [10161.703258]  mode:           3
Jan 26 23:44:38 kaoz [10161.703258]  next_event:     10161865916331 nsecs
Jan 26 23:44:38 kaoz [10161.703258]  set_next_event: lapic_next_event
Jan 26 23:44:38 kaoz [10161.703258]  set_mode:       lapic_timer_setup
Jan 26 23:44:38 kaoz [10161.703258]  event_handler:  hrtimer_interrupt
Jan 26 23:44:38 kaoz [10161.703258]





