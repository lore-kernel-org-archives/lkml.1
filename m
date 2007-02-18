Return-Path: <linux-kernel-owner+w=401wt.eu-S2992956AbXBRAxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992956AbXBRAxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992957AbXBRAxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:53:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:21780 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992956AbXBRAxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Lbj1Un3W6CaNY4wPYR2Yt8q9VLLP9YRuXHWkLkgOoRMv545VNciFxx0sEC3qYCVtIOaZWjcCPksYFfBefpTeqVpwC9shskD6jLs5KT50n8ZORCJB2WO1sp4NTM/PZokvbsx3xNv+DobSPasXYgNybZuEhiA17U1Hs8EQjYY6oTE=
Message-ID: <45D7A37C.3060306@googlemail.com>
Date: Sun, 18 Feb 2007 01:53:16 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded
References: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>	<45D74B37.1040507@googlemail.com>	<20070217114601.19544615.akpm@linux-foundation.org>	<6bffcb0e0702171158o5f384e60sacae4e45563d7321@mail.gmail.com>	<20070217120402.ec517938.akpm@linux-foundation.org>	<6bffcb0e0702171423y3440f8d3n1caa31904ee2eee9@mail.gmail.com> <20070217151210.f962716f.akpm@linux-foundation.org>
In-Reply-To: <20070217151210.f962716f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Sat, 17 Feb 2007 23:23:17 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> On 17/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Sat, 17 Feb 2007 20:58:55 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>>>
>>>> On 17/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>> On Sat, 17 Feb 2007 19:36:39 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>>>>
>>>>>> akpm@linux-foundation.org napisał(a):
>>>>>>> The mm snapshot broken-out-2007-02-17-03-25.tar.gz has been uploaded to
>>>>>>>
>>>>>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-17-03-25.tar.gz
>>>>>>>
>>>>>> BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
>>>>> hm, how did you make that happen?
>>>>>
>>>> I don't know. I can reproduce this bug.
>>>>
>>> Could you bisect it please?  The patches to suspect are
>> [..]
>>> For git-block, do
>>>
>>>         quilt pop scsi-megaraid_sas-return-sync-cache-call-with-success.patch
>>>
>>> and retest.  If that doesn't fail, do
>>>
>>>         quilt push git-block-xfs-barriers-broke.patch
>>>
>>> and retest.
>>>
>> Ok, this must be a git-block-* stuff.
>>
>> Jens, can you take a look at this bug?
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0702.2/0646.html
>>
> 
> I wonder why.  I can't make it happen on two machines, scsi, sata and IDE. 
> And afaict git-block isn't changed from 2.6.20-mm1.
> 
> Are you sure?
> 

Absolutely? No.

Do you believe in statistic?

10 clean boots
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-02-17-03-25/10_clean_boots_without_git_block_stuff.txt

10 boots with git-block-*
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-02-17-03-25/10_boots_with_git_bloack_stuff.txt

cat 10_boots_with_git_bloack_stuff.txt | grep "BUG: unable to handle kernel paging request at virtual address 6b6b6b6f" | wc -l
1

cat 10_boots_with_git_bloack_stuff.txt | grep "EIP"
EIP:    0060:[<c01df352>]    Not tainted VLI
EIP is at blk_unplug_current+0x4d/0x132
EIP: [<c01df352>] blk_unplug_current+0x4d/0x132 SS:ESP 0068:f6eabd54
EIP:    0060:[<c01df352>]    Not tainted VLI
EIP is at blk_unplug_current+0x4d/0x132
EIP: [<c01df352>] blk_unplug_current+0x4d/0x132 SS:ESP 0068:f6eabaf8
EIP:    0060:[<c01e2871>]    Not tainted VLI
EIP is at __make_request+0xeb/0x2e6
EIP: [<c01e2871>] __make_request+0xeb/0x2e6 SS:ESP 0068:f7e35cc0
EIP:    0060:[<c01e11ee>]    Not tainted VLI
EIP is at bio_attempt_back_merge+0x1b/0xb2
EIP: [<c01e11ee>] bio_attempt_back_merge+0x1b/0xb2 SS:ESP 0068:f6f31b88


----------------

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000108
 printing eip:
c01df352
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
last sysfs file: /block/sda/removable
Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev intel_agp snd_timer snd soundcore agpgart skge sk98lin snd_page_alloc i2c_i801 8139too mii ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c01df352>]    Not tainted VLI
EFLAGS: 00010202   (2.6.20 #8)
EIP is at blk_unplug_current+0x4d/0x132
eax: f7c2bce8   ebx: 00000001   ecx: f6eab000   edx: c56deae0
esi: f7c2bcd4   edi: 00000000   ebp: f6eabd90   esp: f6eabd54
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process vol_id (pid: 1313, ti=f6eab000 task=f6f800b0 task.ti=f6eab000)
Stack: 00000000 f6f800b0 c03159e5 00000000 f6eabd84 c013ca75 c6004fb0 f7c2bce8
       00000046 c6004fb0 c6004fb0 00000282 00000001 c044bda0 05bd5d80 f6eabda4
       c031377a f6eabdd0 f6eabdd0 c6004fb0 f6eabdac c01554d6 f6eabdc4 c03138d6
Call Trace:
 [<c010513d>] show_trace_log_lvl+0x1a/0x2f
 [<c01051ef>] show_stack_log_lvl+0x9d/0xa5
 [<c01053e4>] show_registers+0x1ed/0x32c
 [<c0105640>] die+0x11d/0x234
 [<c0119729>] do_page_fault+0x43a/0x50d
 [<c0315cac>] error_code+0x7c/0x84
 [<c031377a>] io_schedule+0x3d/0x9a
 [<c01554d6>] sleep_on_page+0x8/0xc
 [<c03138d6>] __wait_on_bit_lock+0x30/0x59
 [<c01554c7>] __lock_page+0x53/0x5a
 [<c0155bc4>] do_generic_mapping_read+0x1cd/0x41e
 [<c01578a3>] generic_file_aio_read+0x16a/0x197
 [<c0171441>] do_sync_read+0xc2/0xff
 [<c0171c51>] vfs_read+0xad/0x136
 [<c0172084>] sys_read+0x3d/0x61
 [<c0104164>] syscall_call+0x7/0xb
 =======================
Code: 75 04 0f 0b eb fe 48 89 46 0c 85 c0 0f 85 f6 00 00 00 8b 7e <4>AC'97 0 analog subsections not ready
1c c7 46 1c 00 00 00 00 8d 46 14 89 45 e0 39 46 14 0f 84 c3 00 00 00 <8b> 87 08 01 00 00 e8 c8 62 13 00 c7 45 e4 00 00 00 00 8b 5e 14
EIP: [<c01df352>] blk_unplug_current+0x4d/0x132 SS:ESP 0068:f6eabd54
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000108
 printing eip:
c01df352
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP
last sysfs file: /block/sdb/dev
Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev intel_agp snd_timer snd soundcore agpgart skge sk98lin snd_page_alloc i2c_i801 8139too mii ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c01df352>]    Not tainted VLI
EFLAGS: 00010202   (2.6.20 #8)
EIP is at blk_unplug_current+0x4d/0x132
eax: f7c2bce8   ebx: f6eabb5c   ecx: f6eabaec   edx: f7d9ce70
esi: f7c2bcd4   edi: 00000000   ebp: f6eabb34   esp: f6eabaf8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process vol_id (pid: 1313, ti=f6eab000 task=f6f800b0 task.ti=f6eab000)
Stack: c03eb58c c5fc4560 f6eabb24 c01591c1 c015b3eb 00000000 c03eb480 f7c2bce8
       00000000 00000000 00000000 00000000 f6eabb5c f7d9ce70 00000000 f6eabb48
       c015a320 0000000a f7d9ce70 f6eabb84 f6eabb90 c015610c 00000000 00000000
Call Trace:
 [<c010513d>] show_trace_log_lvl+0x1a/0x2f
 [<c01051ef>] show_stack_log_lvl+0x9d/0xa5
 [<c01053e4>] show_registers+0x1ed/0x32c
 [<c0105640>] die+0x11d/0x234
 [<c0119729>] do_page_fault+0x43a/0x50d
 [<c0315cac>] error_code+0x7c/0x84
 [<c015a320>] do_writepages+0x41/0x48
 [<c015610c>] __filemap_fdatawrite_range+0x5b/0x67
 [<c0156319>] filemap_fdatawrite+0x26/0x28
 [<c015632f>] filemap_write_and_wait+0x14/0x2d
 [<c018e04f>] sync_blockdev+0x17/0x1d
 [<c0191a24>] __blkdev_put+0x45/0x129
 [<c0191b12>] blkdev_put+0xa/0xc
 [<c01923b9>] blkdev_close+0x28/0x2b
 [<c017240e>] __fput+0xb9/0x163
 [<c01724cf>] fput+0x17/0x19
 [<c016feb1>] filp_close+0x54/0x5c
 [<c012373a>] put_files_struct+0x67/0xa9
 [<c01247ec>] do_exit+0x22b/0x702
 [<c0105731>] die+0x20e/0x234
 [<c0119729>] do_page_fault+0x43a/0x50d
 [<c0315cac>] error_code+0x7c/0x84
 [<c031377a>] io_schedule+0x3d/0x9a
 [<c01554d6>] sleep_on_page+0x8/0xc
 [<c03138d6>] __wait_on_bit_lock+0x30/0x59
 [<c01554c7>] __lock_page+0x53/0x5a
 [<c0155bc4>] do_generic_mapping_read+0x1cd/0x41e
 [<c01578a3>] generic_file_aio_read+0x16a/0x197
 [<c0171441>] do_sync_read+0xc2/0xff
 [<c0171c51>] vfs_read+0xad/0x136
 [<c0172084>] sys_read+0x3d/0x61
 [<c0104164>] syscall_call+0x7/0xb
 =======================
Code: 75 04 0f 0b eb fe 48 89 46 0c 85 c0 0f 85 f6 00 00 00 8b 7e 1c c7 46 1c 00 00 00 00 8d 46 14 89 45 e0 39 46 14 0f 84 c3 00 00 00 <8b> 87 08 01 00 00 e8 c8 62 13 00 c7 45 e4 00 00 00 00 8b 5e 14
EIP: [<c01df352>] blk_unplug_current+0x4d/0x132 SS:ESP 0068:f6eabaf8

0xc01df352 is in blk_unplug_current (block/ll_rw_blk.c:3739).
3734            ioc->plugged_queue = NULL;
3735            if (list_empty(&ioc->plugged_list))
3736                    goto out;
3737
3738            nr_unplug = 0;
3739            spin_lock_irq(q->queue_lock);
3740            do {
3741                    req = list_entry_rq(ioc->plugged_list.next);
3742                    list_del_init(&req->queuelist);
3743                    add_request(q, req);


------------[ cut here ]------------
kernel BUG at block/ll_rw_blk.c:2781!
invalid opcode: 0000 [#1]
PREEMPT SMP
last sysfs file: /block/hdd/dev
Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm skge evdev snd_timer snd intel_agp sk98lin soundcore agpgart snd_page_alloc i2c_i801 8139too mii ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c01e11ee>]    Not tainted VLI
EFLAGS: 00010282   (2.6.20 #8)
EIP is at bio_attempt_back_merge+0x1b/0xb2
eax: f7cb92c8   ebx: f7d32d60   ecx: f7d32d60   edx: f7fbf074
esi: f7fbf074   edi: f7cb92c8   ebp: f6f31ba8   esp: f6f31b88
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process vol_id (pid: 1320, ti=f6f31000 task=f6deca80 task.ti=f6f31000)
Stack: f7cb92c8 f7fb007b f7d3007b c61e00d8 ffffff10 f7fbf074 f7cb92c8 c61ed89c
       f6f31be0 c01e2855 f6f31bbc c031591f f7e032b0 f6f31c28 c016d6ec 00000000
       f7d32d60 f7d32d60 f7fbf074 00000008 f7d32d60 00000000 f6f31c50 c01e0295
Call Trace:
 [<c010513d>] show_trace_log_lvl+0x1a/0x2f
 [<c01051ef>] show_stack_log_lvl+0x9d/0xa5
 [<c01053e4>] show_registers+0x1ed/0x32c
 [<c0105640>] die+0x11d/0x234
 [<c01057d0>] do_trap+0x79/0x91
 [<c0106060>] do_invalid_op+0x97/0xa1
 [<c0315cac>] error_code+0x7c/0x84
 [<c01e2855>] __make_request+0xcf/0x2e6
 [<c01e0295>] generic_make_request+0x205/0x215
 [<c01e2448>] submit_bio+0xf0/0xf8
 [<c018d607>] submit_bh+0xbf/0xdc
 [<c018fc1f>] block_read_full_page+0x25e/0x26e
 [<c01915e1>] blkdev_readpage+0xf/0x11
 [<c015af00>] __do_page_cache_readahead+0x16f/0x1c0
 [<c015af9e>] blockable_page_cache_readahead+0x4d/0xa0
 [<c015b1b5>] page_cache_readahead+0x128/0x18f
 [<c0155b27>] do_generic_mapping_read+0x130/0x41e
 [<c01578a3>] generic_file_aio_read+0x16a/0x197
 [<c0171441>] do_sync_read+0xc2/0xff
 [<c0171c51>] vfs_read+0xad/0x136
 [<c0172084>] sys_read+0x3d/0x61
 [<c0104164>] syscall_call+0x7/0xb
 =======================
Code: ff ff ff e9 2c ff ff ff 83 c4 2c 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 14 89 c7 89 d6 89 cb f6 42 14 d8 75 06 83 7a 18 01 74 04 <0f> 0b eb fe e8 62 e3 ff ff 31 d2 85 c0 74 7e 8b bf ac 01 00 00
EIP: [<c01e11ee>] bio_attempt_back_merge+0x1b/0xb2 SS:ESP 0068:f6f31b88

0xc01e11ee is in bio_attempt_back_merge (block/ll_rw_blk.c:2781).
2776    }
2777
2778    static int bio_attempt_back_merge(request_queue_t *q, struct request *req,
2779                                      struct bio *bio)
2780    {
2781            BUG_ON(!rq_mergeable(req));
2782
2783            if (!ll_back_merge_fn(q, req, bio))
2784                    return 0;
2785


Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
