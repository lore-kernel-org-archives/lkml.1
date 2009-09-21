Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZIUWoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZIUWoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 18:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZIUWoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 18:44:46 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49532 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZIUWop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 18:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <a4e6962a0909211413q7977284aj8453183e16f5f305@mail.gmail.com>
References: <1253400283-2575-1-git-send-email-adkulkar@umail.iu.edu>
	 <a4e6962a0909211413q7977284aj8453183e16f5f305@mail.gmail.com>
Date: Mon, 21 Sep 2009 16:44:48 -0600
Message-ID: <f6e1b7990909211544v49774c0dk3fbb7b18a5829389@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH 1/2] 9p: Add fscache support to 9p
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 3:13 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> Getting closer, I'm getting an error when I build with make allconfig though:
> (You should be checking with allmodconfig,allnoconfig,sparse, etc.
> before submitting, follow the checklist in
> Documentation/SubmitChecklist as much as you can)
> (Actually, just realized when I wasn't building with allcode, I wasn't
> testing your code, I can't build with 9P FS Cache enabled)
>
> ericvh@strongmad:~/src/linux/v9fs$ make O=../build/allconfig
>  Using /home/ericvh/src/linux/v9fs as source for kernel
>  GEN     /home/ericvh/src/linux/build/allconfig/Makefile
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-x86
>  CALL    /home/ericvh/src/linux/v9fs/scripts/checksyscalls.sh
>  CHK     include/linux/compile.h
>  VDSOSYM arch/x86/vdso/vdso-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>  VDSOSYM arch/x86/vdso/vdso32-syms.lds
>  LD      arch/x86/vdso/built-in.o
>  LD      arch/x86/built-in.o
>  CC [M]  fs/9p/cache.o
> /home/ericvh/src/linux/v9fs/fs/9p/cache.c: In function
> ‘v9fs_cache_session_get_key’:
> /home/ericvh/src/linux/v9fs/fs/9p/cache.c:119: error: implicit
> declaration of function ‘task_pid_nr’
> /home/ericvh/src/linux/v9fs/fs/9p/cache.c: In function
> ‘v9fs_cache_inode_now_uncached’:
> /home/ericvh/src/linux/v9fs/fs/9p/cache.c:234: error: implicit
> declaration of function ‘cond_resched’
>
> There also appears to be an error in the mount-time code if we can't
> connect to the server:
> (This one may be a latent regression from older code, I'm trying to
> track it down now)
>
> [  612.773569] 9p: p9_fd_create_tcp (4978): p9_trans_tcp: problem
> connecting socket to 9.3.61.77
> [  612.773660] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000008
> [  612.773774] IP: [<ffffffffa0292f06>] v9fs_session_close+0x56/0x80 [9p]
> [  612.773854] PGD 4251d1067 PUD 424d11067 PMD 0
> [  612.773983] Oops: 0002 [#1] SMP
> [  612.774083] last sysfs file: /sys/devices/virtual/block/dm-0/dev
> [  612.774128] CPU 3
> [  612.774196] Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc
> 9p 9pnet binfmt_misc ppdev bnep ipt_MASQUERADE iptable_nat nf_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
> xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm
> autofs4 video output lp parport snd_hda_codec_analog snd_hda_intel
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> iTCO_wdt snd_timer snd_seq_device iTCO_vendor_support snd soundcore
> psmouse i5000_edac edac_core ics932s401 shpchp serio_raw i5k_amb
> pcspkr snd_page_alloc ohci1394 floppy ieee1394 tg3
> [  612.776189] Pid: 4978, comm: mount Not tainted 2.6.31 #6 9228MC1
> [  612.776233] RIP: 0010:[<ffffffffa0292f06>]  [<ffffffffa0292f06>]
> v9fs_session_close+0x56/0x80 [9p]
> [  612.776319] RSP: 0018:ffff880424cd5d88  EFLAGS: 00010246
> [  612.776363] RAX: 0000000000000000 RBX: ffff88042c1bd720 RCX: ffffffffa0292ef2
> [  612.776408] RDX: 0000000000000000 RSI: ffffea000e79fe80 RDI: ffffffffa0296260
> [  612.776453] RBP: ffff880424cd5d98 R08: 0000000000000000 R09: ffffffffa0292ef2
> [  612.776498] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88042c1bd720
> [  612.776543] R13: ffffffffffffff91 R14: ffff880424c94000 R15: 0000000000000000
> [  612.776589] FS:  00007f9042524780(0000) GS:ffff880028380000(0000)
> knlGS:0000000000000000
> [  612.776644] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  612.776688] CR2: 0000000000000008 CR3: 000000042c429000 CR4: 00000000000026a0
> [  612.776733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  612.776778] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  612.776824] Process mount (pid: 4978, threadinfo ffff880424cd4000,
> task ffff88042e9796c0)
> [  612.776878] Stack:
> [  612.776918]  ffff880424c94000 00000000ffffff91 ffff880424cd5df8
> ffffffffa029111c
> [  612.777050] <0> ffff880424d16000 ffff88042d955e00 ffff880424d16000
> ffffffffa0295fa0
> [  612.777248] <0> 00000000fffffff4 ffff88042d955e00 0000000000000000
> ffffffffa0295fa0
> [  612.777483] Call Trace:
> [  612.777527]  [<ffffffffa029111c>] v9fs_get_sb+0xbc/0x260 [9p]
> [  612.777577]  [<ffffffff81118425>] vfs_kern_mount+0x75/0x150
> [  612.777621]  [<ffffffff8111856e>] do_kern_mount+0x4e/0x110
> [  612.777666]  [<ffffffff81131a68>] do_mount+0x6b8/0x950
> [  612.777710]  [<ffffffff81131dbb>] sys_mount+0xbb/0xe0
> [  612.777756]  [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
> [  612.777800] Code: 5d e1 e8 1e a2 e7 e0 48 8b 73 18 48 8b 3d 8b 09
> 5d e1 e8 0e a2 e7 e0 48 c7 c7 60 62 29 a0 e8 32 31 28 e1 48 8b 53 38
> 48 8b 43 40 <48> 89 42 08 48 89 10 48 c7 43 40 00 02 20 00 48 c7 43 38
> 00 01
> [  612.779748] RIP  [<ffffffffa0292f06>] v9fs_session_close+0x56/0x80 [9p]
> [  612.779823]  RSP <ffff880424cd5d88>
> [  612.779864] CR2: 0000000000000008
> [  612.779917] ---[ end trace a94bb7a705d776bf ]---
>
>

Sorry, this seems to have gotten through with the recent fsc patches.
v9fs_session_close() should be more cautious when tearing down
the session.

Does the attached patch fix the issue for you?

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index f4a5950..464fd0f 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -228,6 +228,10 @@ struct p9_fid *v9fs_session_init(struct
v9fs_session_info *v9ses,
                return ERR_PTR(-ENOMEM);
        }

+       spin_lock(&v9fs_sessionlist_lock);
+       list_add(&v9ses->slist, &v9fs_sessionlist);
+       spin_unlock(&v9fs_sessionlist_lock);
+
        v9ses->flags = V9FS_EXTENDED | V9FS_ACCESS_USER;
        strcpy(v9ses->uname, V9FS_DEFUSER);
        strcpy(v9ses->aname, V9FS_DEFANAME);
@@ -282,9 +286,6 @@ struct p9_fid *v9fs_session_init(struct
v9fs_session_info *v9ses,
        v9fs_cache_session_get_cookie(v9ses);
 #endif

-       spin_lock(&v9fs_sessionlist_lock);
-       list_add(&v9ses->slist, &v9fs_sessionlist);
-       spin_unlock(&v9fs_sessionlist_lock);
        return fid;

 error:
@@ -305,8 +306,10 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
        }

 #ifdef CONFIG_9P_FSCACHE
-       v9fs_cache_session_put_cookie(v9ses);
-       kfree(v9ses->cachetag);
+       if (v9ses->fscache) {
+               v9fs_cache_session_put_cookie(v9ses);
+               kfree(v9ses->cachetag);
+       }
 #endif
        __putname(v9ses->uname);
        __putname(v9ses->aname);


>
>
> On Sat, Sep 19, 2009 at 5:44 PM, Abhishek Kulkarni
> <adkulkar@umail.iu.edu> wrote:
>> This patch adds a persistent, read-only caching facility for
>> 9p clients using the FS-Cache caching backend.
>>
>> When the fscache facility is enabled, each inode is associated
>> with a corresponding vcookie which is an index into the FS-Cache
>> indexing tree. The FS-Cache indexing tree is indexed at 3 levels:
>> - session object associated with each mount.
>> - inode/vcookie
>> - actual data (pages)
>>
>> A cache tag is chosen randomly for each session. These tags can
>> be read off /sys/fs/9p/caches and can be passed as a mount-time
>> parameter to re-attach to the specified caching session.
>>
>> Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
>> ---
>>  fs/9p/Kconfig       |    9 +
>>  fs/9p/Makefile      |    3 +-
>>  fs/9p/cache.c       |  473 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/9p/cache.h       |  175 +++++++++++++++++++
>>  fs/9p/v9fs.c        |  191 ++++++++++++++++++---
>>  fs/9p/v9fs.h        |   13 +-
>>  fs/9p/v9fs_vfs.h    |    6 +
>>  fs/9p/vfs_addr.c    |   88 ++++++++++-
>>  fs/9p/vfs_file.c    |   10 +-
>>  fs/9p/vfs_inode.c   |   56 ++++++-
>>  fs/9p/vfs_super.c   |   16 +--
>>  include/net/9p/9p.h |    3 +
>>  12 files changed, 1001 insertions(+), 42 deletions(-)
>>  create mode 100644 fs/9p/cache.c
>>  create mode 100644 fs/9p/cache.h
>>
>> diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
>
