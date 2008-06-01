Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYFALGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYFALGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 07:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYFALFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 07:05:54 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:43679 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYFALFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 07:05:52 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops during hibernation - two times the same one
Date: Sun, 1 Jun 2008 13:05:40 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, pavel@ucw.cz
References: <200805282323.20679.linux@rainbow-software.org> <200805290827.12722.linux@rainbow-software.org> <200805291815.28469.linux@rainbow-software.org>
In-Reply-To: <200805291815.28469.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_HKoQIUjOA6oWesu"
Message-Id: <200806011305.43776.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_HKoQIUjOA6oWesu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 29 May 2008 18:15:26 Ondrej Zary wrote:
> On Thursday 29 May 2008 08:27:11 Ondrej Zary wrote:
> > On Thursday 29 May 2008, Andrew Morton wrote:
> > > On Thu, 29 May 2008 00:09:36 +0200
> > >
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > On Wednesday, 28 of May 2008, Ondrej Zary wrote:
> > > > > Hello,
> > > > > I'm using hibernation on my desktop machine every day instead of
> > > > > power off. It mostly works but sometimes aborts with "no space left
> > > > > on device" error. Closing some programs and trying again usually
> > > > > fixes it - but recently, I got two oopses instead. I'm sending them
> > > > > because they're the same, only some details are different. Does
> > > > > anyone know what might be wrong?
> > > >
> > > > Thanks for the report, but I have no idea of what could go wrong.
> > > >
> > > > Rafael
> > > >
> > > > > ------------[ cut here ]------------
> > > > > Kernel BUG at c015610b [verbose debug info unavailable]
> > >
> > > Looks like this is
> > >
> > > 	BUG_ON(inode->i_state == I_CLEAR);
> > >
> > > Please do enable CONFIG_DEBUG_BUGVERBOSE.  Turning off this stuff
> > > doesn't gain much.
> > >
> > > > > invalid opcode: 0000 [#1]
> > > > > Modules linked in: snd_sb16 ppdev snd_opl3_synth snd_seq_midi_emul
> > > > > snd_opl3_lib snd_hwdep snd_sb16_dsp snd_sb_common snd_mpu401_uart
> > > > > snd_rawmidi 3c509 de2104x sr_mod cdrom [last unloaded: snd_sb16]
> > > > >
> > > > > Pid: 8634, comm: bash Not tainted (2.6.25.3-pentium #3)
> > > > > EIP: 0060:[<c015610b>] EFLAGS: 00210246 CPU: 0
> > > > > EIP is at iput+0x19/0x61
> > > > > EAX: c02db808 EBX: cf402c08 ECX: 0001ec9e EDX: 00000000
> > > > > ESI: cf402ba0 EDI: cf987c00 EBP: 00000000 ESP: c9a4deb4
> > > > >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > > > > Process bash (pid: 8634, ti=c9a4c000 task=c3975000
> > > > > task.ti=c9a4c000) Stack: 00000000 c0163eb5 cf402bac ffffffe4
> > > > > c142b000 c0329881 cf80b6a0 c012e212 00000001 c38de7ac 00200286
> > > > > 00001000 00000000 00000001 00000000 00000000 c142b000 00000000
> > > > > 00000000 0001ec82 0001ec82 00200246 0001ec82 fffffa5d Call Trace:
> > > > >  [<c0163eb5>] __blkdev_put+0xc2/0xda
> > > > >  [<c012e212>] swsusp_write+0x307/0x311
> > > > >  [<c012c81b>] hibernate+0xb4/0x131
> > > > >  [<c012b9ad>] state_store+0x41/0xa3
> > > > >  [<c012b96c>] state_store+0x0/0xa3
> > > > >  [<c01babcb>] kobj_attr_store+0x18/0x1c
> > > > >  [<c0173dd0>] sysfs_write_file+0xab/0xd8
> > > > >  [<c0173d25>] sysfs_write_file+0x0/0xd8
> > > > >  [<c0148a58>] vfs_write+0x7f/0xec
> > > > >  [<c0148e9c>] sys_write+0x3c/0x63
> > > > >  [<c01039d2>] syscall_call+0x7/0xb
> > > > >  [<c02d0000>] i8042_probe+0x4c4/0x4db
> > > > >  =======================
> > > > > Code: 08 01 00 00 77 ff ff ff eb e5 e8 90 ad 17 00 31 c0 c3 53 85
> > > > > c0 89 c3 74 58 8b 80 8c 00 00 00 83 bb 08 01 00 00 40 8b 40 20 75
> > > > > 04 <0f> 0b eb fe 85 c0 74 0b 8b 50 10 85 d2 74 04 89 d8 ff d2 8d 43
> > > > > EIP: [<c015610b>] iput+0x19/0x61 SS:ESP 0068:c9a4deb4
> > >
> > > Beats me.  Somehow the swap device's blockdev inode got I_CLEAR set
> > > while swsusp_write() was playing with it.  Or during.
> > >
> > > I guess we could add I_CLEAR checks on resume_bdev into
> > > kernel/power/swap.c in various places.
> > >
> > > Had there been any swapoffs before or during this suspend?
> >
> > Yes, you're right. I almost forgot that. I have two swaps - one 256MB
> > swap partition (the machine has 256MB RAM) and one 128MB swap file. The
> > silly thing is that the partition fills up first while the swapfile
> > remains empty (ok, it's possible to change the priority - but haven't
> > tried that yet). So when the hibernation failed, I tried to free the swap
> > partition using swapoff and swapon. Sometimes, it crashes during the
> > swapoff - like yesterday (will post later).
>
> OK, here's the other crash. I was wrong, it was during swapon, not swapoff.
> I'll try to reproduce both of them.
>
> PM: Not enough free swap
> Restarting tasks ... done.
> ata2.01: configured for PIO2
> BUG: unable to handle kernel NULL pointer dereference at 00000030
> IP: [<c0163812>] bd_claim+0x14/0x3e
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: usbhid snd_opl3_lib snd_hwdep snd_sb16_dsp snd_sb_common
> snd_mpu401_uart snd_rawmidi 3c509 ppdev sr_mod cdrom de2104x [last
> unloaded: snd_sb16]
>
> Pid: 10517, comm: swapon Not tainted (2.6.25.3-pentium #3)
> EIP: 0060:[<c0153812>] EFLAGS: 00210207 CPU: 0
> EIP is at bd_claim+0x14/0x3e
> EAX: 00000000 EBX: cf402ca0 ECX: cf402ba0 EDX: c0142178
> ESI: 00000000 EDI: 00000000 EBP: c03daaac ESP: c7095f48
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process swapon (pid: 10517, ti=c7094000 task=c201a550 task.ti=c7094000)
> Stack: c0142308 c013b28c 00000000 000000cf 00000000 c70e7000 cf402ba0
> cd825340 cf435b40 0000095c c71cab7c 00000001 cf402c08 b7e57180 c201a550
> 00000004 c010c2d4 00000000 cf435b74 c7095fb8 cf435b40 00000000 1c9b5d63
> 0860d648 Call Trace:
>  [<c0142308>] sys_swapon+0x190/0x7be
>  [<c013b28c>] handle_mm_fault+0x202/0x438
>  [<c010c2d4>] do_page_fault+0x205/0x559
>  [<c01039d2>] syscall_call+0x7/0xb
>  =======================
> Code: 03 48 28 8d 42 a8 8b 50 58 8d 74 26 00 3d 34 67 37 c0 75 e3 89 c8 c3
> 89 c1 8b 40 30 39 d0 74 19 85 c0 75 2b 8b 41 40 39 c8 74 0e <8b> 40 30 3d
> fe 37 16 c0 74 04 85 c0 75 16 8b 41 40 ff 40 34 c7
> EIP: [<c0163812>] bd_claim+0x15/0x3e SS:ESP 0068:c7095f48
> ---[ end trace 24e66613592015ef ]---

It crashed again yesterday - during swapoff after failed hibernation. Have no 
dump as it completely crashed after entering "dmesg".
Although there were almost no applications running (KDE, Konsole and Pidgin), 
there was not enough swap space available, while I can sometimes hibernate 
fine with KMail and Konqueror running too. I suspect that something is 
leaking memory here. Don't know if the (attached) output from /proc/slabinfo 
and /proc/vmstat is enough to tell.


-- 
Ondrej Zary

--Boundary-00=_HKoQIUjOA6oWesu
Content-Type: text/plain;
  charset="iso-8859-1";
  name="slabinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="slabinfo.txt"

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
UNIX                 145    189    416    9    1 : tunables   54   27    0 : slabdata     21     21      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
scsi_sense_cache      40     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_cmd_cache        17     17    224   17    1 : tunables  120   60    0 : slabdata      1      1      0
cfq_io_context         0      0     88   44    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_queue              0      0     84   46    1 : tunables  120   60    0 : slabdata      0      0      0
udf_inode_cache        0      0    340   11    1 : tunables   54   27    0 : slabdata      0      0      0
fuse_request           0      0    360   11    1 : tunables   54   27    0 : slabdata      0      0      0
fuse_inode             0      0    352   11    1 : tunables   54   27    0 : slabdata      0      0      0
smb_request            0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
smb_inode_cache        0      0    308   13    1 : tunables   54   27    0 : slabdata      0      0      0
isofs_inode_cache      0      0    312   12    1 : tunables   54   27    0 : slabdata      0      0      0
fat_inode_cache        1     11    336   11    1 : tunables   54   27    0 : slabdata      1      1      0
fat_cache              1    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
journal_handle        16    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
journal_head          21     72     52   72    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_table           2    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ext3_inode_cache    1098   2025    420    9    1 : tunables   54   27    0 : slabdata    225    225      0
ext3_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_watch_cache    166    184     40   92    1 : tunables  120   60    0 : slabdata      2      2      0
kioctx                 0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    160   24    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           1    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
shmem_inode_cache   4613   4620    376   10    1 : tunables   54   27    0 : slabdata    462    462      0
nsproxy                0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
posix_timers_cache      0      0    124   31    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache              3     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
UDP-Lite               0      0    512    7    1 : tunables   54   27    0 : slabdata      0      0      0
tcp_bind_bucket        2    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
ip_fib_alias           0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ip_fib_hash           10    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
ip_dst_cache           0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
arp_cache              0      0    160   24    1 : tunables  120   60    0 : slabdata      0      0      0
RAW                    2      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
UDP                    5      7    512    7    1 : tunables   54   27    0 : slabdata      1      1      0
tw_sock_TCP            0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
TCP                    2      7   1152    7    2 : tunables   24   12    0 : slabdata      1      1      0
eventpoll_pwq          4    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
eventpoll_epi          4     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    0 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-16              2     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-8               4     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_bidi_sdb          0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    0 : slabdata      0      0      0
blkdev_queue          12     12    964    4    1 : tunables   54   27    0 : slabdata      3      3      0
blkdev_requests      129    189    184   21    1 : tunables  120   60    0 : slabdata      9      9      0
blkdev_ioc            65    168     44   84    1 : tunables  120   60    0 : slabdata      2      2      0
biovec-256             2      2   3072    2    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-128             2      5   1536    5    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-64              2      5    768    5    1 : tunables   54   27    0 : slabdata      1      1      0
biovec-16              2     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-4               2     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-1              62   2030     16  203    1 : tunables  120   60    0 : slabdata     10     10      0
bio                   96    708     64   59    1 : tunables  120   60    0 : slabdata     12     12      0
sock_inode_cache     185    264    320   12    1 : tunables   54   27    0 : slabdata     22     22      0
skbuff_fclone_cache      0      0    320   12    1 : tunables   54   27    0 : slabdata      0      0      0
skbuff_head_cache     65     96    160   24    1 : tunables  120   60    0 : slabdata      4      4      0
file_lock_cache        1     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
Acpi-Operand         469    552     40   92    1 : tunables  120   60    0 : slabdata      6      6      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-Namespace       286    338     20  169    1 : tunables  120   60    0 : slabdata      2      2      0
proc_inode_cache     247    247    300   13    1 : tunables   54   27    0 : slabdata     19     19      0
sigqueue               3     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node     1556   3159    288   13    1 : tunables   54   27    0 : slabdata    243    243      0
bdev_cache             8      9    416    9    1 : tunables   54   27    0 : slabdata      1      1      0
sysfs_dir_cache     6868   6972     44   84    1 : tunables  120   60    0 : slabdata     83     83      0
mnt_cache             22     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache          121    210    284   14    1 : tunables   54   27    0 : slabdata     15     15      0
dentry              6673   9579    124   31    1 : tunables  120   60    0 : slabdata    309    309      0
filp                1448   2160    128   30    1 : tunables  120   60    0 : slabdata     72     72      0
names_cache            3      3   4096    1    1 : tunables   24   12    0 : slabdata      3      3      0
idr_layer_cache      264    290    136   29    1 : tunables  120   60    0 : slabdata     10     10      0
buffer_head          740   1656     52   72    1 : tunables  120   60    0 : slabdata     23     23      0
mm_struct             66     70    384   10    1 : tunables   54   27    0 : slabdata      7      7      0
vm_area_struct      4096   5888     84   46    1 : tunables  120   60    0 : slabdata    128    128      0
fs_cache              65    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
files_cache           66    100    192   20    1 : tunables  120   60    0 : slabdata      5      5      0
signal_cache          88     90    416    9    1 : tunables   54   27    0 : slabdata     10     10      0
sighand_cache         84     84   1312    3    1 : tunables   24   12    0 : slabdata     28     28      0
task_struct           84     87   1360    3    1 : tunables   24   12    0 : slabdata     29     29      0
anon_vma            1234   2373      8  339    1 : tunables  120   60    0 : slabdata      7      7      0
pid                   91    118     64   59    1 : tunables  120   60    0 : slabdata      2      2      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             1      1  32768    1    8 : tunables    8    4    0 : slabdata      1      1      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384            10     10  16384    1    4 : tunables    8    4    0 : slabdata     10     10      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              6      6   8192    1    2 : tunables    8    4    0 : slabdata      6      6      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096             39     39   4096    1    1 : tunables   24   12    0 : slabdata     39     39      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048             40     40   2048    2    1 : tunables   24   12    0 : slabdata     20     20      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024            116    116   1024    4    1 : tunables   54   27    0 : slabdata     29     29      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             923    992    512    8    1 : tunables   54   27    0 : slabdata    124    124      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256              60     60    256   15    1 : tunables  120   60    0 : slabdata      4      4      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
size-192              60     60    192   20    1 : tunables  120   60    0 : slabdata      3      3      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
size-128             104    120    128   30    1 : tunables  120   60    0 : slabdata      4      4      0
size-96(DMA)           0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
size-96              372    680     96   40    1 : tunables  120   60    0 : slabdata     17     17      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
size-64             2941   4543     64   59    1 : tunables  120   60    0 : slabdata     77     77      0
size-32             5359   5537     32  113    1 : tunables  120   60    0 : slabdata     49     49      0
kmem_cache           130    160     96   40    1 : tunables  120   60    0 : slabdata      4      4      0

--Boundary-00=_HKoQIUjOA6oWesu
Content-Type: text/plain;
  charset="iso-8859-1";
  name="vmstat.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="vmstat.txt"

nr_free_pages 34149
nr_inactive 11901
nr_active 15004
nr_anon_pages 13388
nr_mapped 4720
nr_file_pages 26359
nr_dirty 10
nr_writeback 0
nr_slab_reclaimable 619
nr_slab_unreclaimable 1618
nr_page_table_pages 378
nr_unstable 0
nr_bounce 0
nr_vmscan_write 188914

--Boundary-00=_HKoQIUjOA6oWesu--
