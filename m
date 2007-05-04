Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXEDO6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXEDO6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXEDO6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:58:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:3664 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbXEDO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VQqhcLQV6u8w/34dDQUpKQGDYtCiN/DeTpMnhJKCMLXEyNCkcYxnSf8TyaN5GT1gY3yyJKTzBh5+BROhzCe5IfHAqoDuuV8STsQN2uyRyKQqnMc5U0LbbmHIjAZ08T/N4FSmkBHWUdA24HBh3mstzzlXm2Apq3MYcMyf0jV4Mm8=
Message-ID: <463B4A05.7060504@gmail.com>
Date: Fri, 04 May 2007 16:58:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
CC: stable@kernel.org, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 2.6.21-mm1: many processes end up in D state
References: <46360DA7.6040003@gmail.com> <46371128.4060101@gmail.com>
In-Reply-To: <46371128.4060101@gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-ide@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>

Jiri Slaby napsal(a):
> Cc: stable@kernel.org
> 
> Jiri Slaby napsal(a):
>> Hi,
>>
>> I have a problem with higher disk loads (e.g. running git-log or yum update).
>> Many processes end up in D state and system is unusable -- I'm not able to run
>> anything but smooth mouse moving when this happens.
>>
>> If I wait for a 20-30sec it becomes usable. This happens in 2.6.21-rc7-mm2 and
>> also in 2007-04-28-05-06 broken-out snapshot. I think 2.6.21-rc6-mm1 worked
>> fine, but I'm uncertain. If it is important, let me know to re-test.
>>
>> sysrq-t:
>>
>> yum           D 0000004C     0  2976   2955 (NOTLB)
>>        c455bd00 00200082 8c68ea9e 0000004c 00000000 00000000 c455bcdc c455bc9c
>>        c455bc9c c2d6a580 8c68ea9e 0000004c c455bcc0 c2d6a694 c1809980 00000000
>>        c455bcd0 c4640c80 000036a0 00000001 c455bcf0 c02a7132 c3682164 00001cde
>> Call Trace:
>>  [<c037834c>] io_schedule+0x21/0x2e
>>  [<c014d505>] sync_page+0x38/0x43
>>  [<c0378581>] __wait_on_bit_lock+0x40/0x63
>>  [<c014d4b6>] __lock_page+0x54/0x5c
>>  [<c014da81>] do_generic_mapping_read+0x1dc/0x57e
>>  [<c014fc84>] generic_file_aio_read+0xc9/0x1b5
>>  [<c016c31c>] do_sync_read+0xd0/0x106
>>  [<c016cada>] vfs_read+0x89/0x11d
>>  [<c016d02c>] sys_pread64+0x64/0x68
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<47176012>] 0x47176012
>>  =======================
>> xterm         S 00000051     0  2980      1 (NOTLB)
>>        c4678ae0 00000082 b2fbf0ce 00000051 00000000 00000000 00000000 00000000
>>        c4678b30 c469d540 b2fbf0ce 00000051 c4678ab0 c469d654 c1813980 00000001
>>        c4678ad0 c47f0e40 c4678b00 00000286 c4678ae0 c012c077 00000001 00003286
>> Call Trace:
>>  [<c03784ad>] schedule_timeout+0x44/0xa4
>>  [<c0177ee3>] do_select+0x46d/0x55b
>>  [<c017816f>] core_sys_select+0x19e/0x2c0
>>  [<c01786f3>] sys_select+0xd3/0x18d
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<47180f98>] 0x47180f98
>>  =======================
>> bash          S 0000004A     0  2982   2980 (NOTLB)
>>        c50b3e80 00000086 ccf4cc7e 0000004a 00000000 c021bed9 00000000 c45c0030
>>        c50b3e30 c45c0030 ccf4cc7e 0000004a c50b3e50 c45c0144 c1809980 00000000
>>        c1809e44 c4517900 00000000 000000b3 c50b3e90 c014f841 c477cb40 c2d79000
>> Call Trace:
>>  [<c03784d3>] schedule_timeout+0x6a/0xa4
>>  [<c0221960>] read_chan+0x1b9/0x5b9
>>  [<c021e48f>] tty_read+0x75/0xaa
>>  [<c016cada>] vfs_read+0x89/0x11d
>>  [<c016cf3d>] sys_read+0x3d/0x64
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<4717883e>] 0x4717883e
>>  =======================
>> metacity      S 00000050     0  3005   2429 (NOTLB)
>>        c2fd5bb0 00000086 5205656d 00000050 00000000 00000000 00000000 c441c51c
>>        00000246 c45c0540 5205656d 00000050 c2fd5b80 c45c0654 c1809980 00000000
>>        c1813e44 c27f4900 00002cb8 00000246 c2fd5ba0 c0135a80 c2fd5ba8 00002cb2
>> Call Trace:
>>  [<c03784d3>] schedule_timeout+0x6a/0xa4
>>  [<c0177905>] do_sys_poll+0x33f/0x46d
>>  [<c0177a74>] sys_poll+0x41/0x43
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<4717e3a6>] 0x4717e3a6
>>  =======================
>> ccpd          D 0000004C     0  3009   2010 (NOTLB)
>>        c50abbb0 00000082 f08ef585 0000004c 00000000 00000000 c180abc0 c22fc788
>>        c50abba0 c505d070 f08ef585 0000004c 00000000 c505d184 c1809980 00000000
>>        c21167f0 c2fc6740 c5794e3c c31eff74 c5794310 c22fc788 00000002 00001e64
>> Call Trace:
>>  [<c01b64d9>] do_get_write_access+0x310/0x4f5
>>  [<c01b66d9>] journal_get_write_access+0x1b/0x2a
>>  [<c01b59ce>] __ext3_journal_get_write_access+0x19/0x3f
>>  [<c01aa5f6>] ext3_reserve_inode_write+0x53/0x6c
>>  [<c01aa62f>] ext3_mark_inode_dirty+0x20/0x37
>>  [<c01ad350>] ext3_dirty_inode+0x6b/0x6d
>>  [<c01868fb>] __mark_inode_dirty+0x2a/0x16d
>>  [<c017eacc>] touch_atime+0x84/0xd8
>>  [<c014dd08>] do_generic_mapping_read+0x463/0x57e
>>  [<c014fc84>] generic_file_aio_read+0xc9/0x1b5
>>  [<c016c31c>] do_sync_read+0xd0/0x106
>>  [<c016cada>] vfs_read+0x89/0x11d
>>  [<c016fc6e>] kernel_read+0x36/0x48
>>  [<c016fd32>] prepare_binprm+0xb2/0xdf
>>  [<c0171322>] do_execve+0xe6/0x1e1
>>  [<c0102715>] sys_execve+0x2e/0x7f
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<471474da>] 0x471474da
>>  =======================
>> bash          D 0000004D     0  3011   2859 (NOTLB)
>>        c471dc90 00000082 08f8373c 0000004d 00000000 00000000 c471dc30 c471dc2c
>>        c471dc2c c4670540 08f8373c 0000004d c471dc50 c4670654 c1809980 00000000
>>        c471dc60 c2f3f040 00000005 00000001 c471dc80 c02a7132 c591af64 00001eea
>> Call Trace:
>>  [<c037834c>] io_schedule+0x21/0x2e
>>  [<c014d505>] sync_page+0x38/0x43
>>  [<c0378581>] __wait_on_bit_lock+0x40/0x63
>>  [<c014d4b6>] __lock_page+0x54/0x5c
>>  [<c014da81>] do_generic_mapping_read+0x1dc/0x57e
>>  [<c014fc84>] generic_file_aio_read+0xc9/0x1b5
>>  [<c016c31c>] do_sync_read+0xd0/0x106
>>  [<c016cada>] vfs_read+0x89/0x11d
>>  [<c016fc6e>] kernel_read+0x36/0x48
>>  [<c016fd32>] prepare_binprm+0xb2/0xdf
>>  [<c0171322>] do_execve+0xe6/0x1e1
>>  [<c0102715>] sys_execve+0x2e/0x7f
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<471474da>] 0x471474da
>>  =======================
>> bash          D 0000004D     0  3012   2884 (NOTLB)
>>        c50d5a80 00000082 a21bfc35 0000004d 00000000 00000000 c180abc0 c2033dd4
>>        c50d5a70 c2f4f070 a21bfc35 0000004d 00000000 c2f4f184 c1809980 00000000
>>        c21167bc c47f0c80 c2033310 c22fc788 c5794e3c c2033dd4 00000002 0000216d
>> Call Trace:
>>  [<c01b64d9>] do_get_write_access+0x310/0x4f5
>>  [<c01b66d9>] journal_get_write_access+0x1b/0x2a
>>  [<c01b59ce>] __ext3_journal_get_write_access+0x19/0x3f
>>  [<c01aa5f6>] ext3_reserve_inode_write+0x53/0x6c
>>  [<c01aa62f>] ext3_mark_inode_dirty+0x20/0x37
>>  [<c01ad350>] ext3_dirty_inode+0x6b/0x6d
>>  [<c01868fb>] __mark_inode_dirty+0x2a/0x16d
>>  [<c017eacc>] touch_atime+0x84/0xd8
>>  [<c017499a>] __link_path_walk+0x893/0xca4
>>  [<c0174df1>] link_path_walk+0x46/0xc3
>>  [<c0175038>] do_path_lookup+0x86/0x1b0
>>  [<c0175ad0>] __path_lookup_intent_open+0x44/0x7f
>>  [<c0175b83>] path_lookup_open+0x21/0x27
>>  [<c016fd86>] open_exec+0x27/0xa2
>>  [<c01993a3>] load_elf_binary+0x1482/0x1acf
>>  [<c016fa1d>] search_binary_handler+0x6e/0x19f
>>  [<c0171386>] do_execve+0x14a/0x1e1
>>  [<c0102715>] sys_execve+0x2e/0x7f
>>  [<c0103ffc>] syscall_call+0x7/0xb
>>  [<471474da>] 0x471474da
>>  =======================
>>
>> Note that yum works on lvm on raid0 and git too, but on the another md volume.
>> Both ext3s. Drivers are sata_promise and ata_piix (sata disk); CFQ scheduler.
>> Using noop is no change (but seems to be harder to reproduce with it). I figured
>> out that it probably happens when 2+ processes are on both "processors" (HT on
>> P4) and are IO wait (multiload-applet shows red above the half).
>>
>> Swap usage is 0 all the time.
> 
> I'm able to reproduce this in the latest git (dc87c3985e9b442c). Going to bisect.

Is it possible, that
Commit: 176efb054422bffe6b5a34194ffad134366c7f7e
Author: Mikael Pettersson <mikpe@it.uu.se> Wed, 14 Mar 2007 09:51:35 +0100

    sata_promise: decode and report error reasons

    This patch adds much needed error reason decoding and
    reporting to sata_promise. It's simplistic but should
    log all relevant error info the controller provides.

    Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

causes this? When I change this:
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index f56549b..a0024ae 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -668,10 +668,8 @@ static inline unsigned int pdc_host_intr( struct ata_port *ap,
        else
                err_mask &= ~PDC2_ERR_MASK;
        port_status = readl(port_mmio + PDC_GLOBAL_CTL);
-       if (unlikely(port_status & err_mask)) {
+       if (unlikely(port_status & err_mask))
                pdc_error_intr(ap, qc, port_status, err_mask);
-               return 1;
-       }

        switch (qc->tf.protocol) {
        case ATA_PROT_DMA:
the problem disappears.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
