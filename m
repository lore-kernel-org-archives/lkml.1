Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYDAPis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYDAPis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYDAPij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:38:39 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:41215 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYDAPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Mgfo4d6Dzfu9l4lpADIn9gWperJo13dwvY/bXr4w/ki6UpcdcLg2TstXjhz9vGmQuQxre0/gxLyCKnuOsQbjaTtYZWVfthgU0Dyr7IYaUo8ClYS+FVS/KeNBo0s2Df5LzscGit8UzI1C56vYjZf1ofygZEw49C0TXvrocaxeAWw=
Message-ID: <8bf247760804010838x3c631f3csc021fe5d9778269@mail.gmail.com>
Date: Tue, 1 Apr 2008 21:08:32 +0530
From: Ram <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: how to debug: processes with -D (uninterruptible sleep)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am using linux 2.6.22. I am testing my nand driver/nand device.
   I am using a arm based processor.

   To test my nand device, i am using fs-tests package that comes
   with mtd-utils git tree.

   These are standard filesystem regression tests.

   I am running the test to test a particular partition.

   During one of the tests: The test process hangs.
   When i do a ps -eal i get a -D against that process.
   That particular process remains in that state forever.

   I have eliminated all the infinte loops (checks for busy/read pin/nand reset)
   in my nand driver. I have tried to put debug prints to print
failures in my nand
   device. I dont see any failure prints when i run the tests.

   I tried doing "echo t > /proc/sysrq-trigger" i am appending the results.

   Basically, i am trying to isolate the code that is causing the process
   to go into an uniterruptible sleep state.

   It is to be noted that - When the fs-tests process has gone into
"uninterruptible
   sleep state" accessing the partion under test makes that process
   also go into the uninterruptible sleep state"

   What i am trying to say is - If i try to copy something to the
"partition under test"
   that process (cp) also goes into that state.

   In other words,  Once the fs-test process goes into -D state
("uninterruptible sleep state")
   I cannot access the partition under test.

   However, i can access other partitions in the nand device without
any problem.

    I need some suggestions/advices to debug the issue.
    How does one debug such a issue.

   please advice.

Thanks and Regards,
   sriram




Output of echo t > /proc/sysrq-trigger
-----------------------------------------------------



test_2        D C022BB54     0   267    248 (NOTLB)
[<c022b620>] (schedule+0x0/0x608) from [<c022c434>] (io_schedule+0x2c/0x48)
[<c022c408>] (io_schedule+0x0/0x48) from [<c0077eb4>] (sync_page+0x50/0x5c)
 r5:00000000 r4:c38a3a34
[<c0077e64>] (sync_page+0x0/0x5c) from [<c022c62c>] (__wait_on_bit+0x64/0xa8)
[<c022c5c8>] (__wait_on_bit+0x0/0xa8) from [<c0078258>]
(wait_on_page_bit+0xa8/0xb8)
[<c00781b0>] (wait_on_page_bit+0x0/0xb8) from [<c0079e60>]
(read_cache_page+0x38/0x58)
 r6:00007080 r5:c0340a80 r4:00000000
[<c0079e28>] (read_cache_page+0x0/0x58) from [<c0113c50>]
(jffs2_gc_fetch_page+0x28/0x60)
 r5:00007000 r4:c38a3afc
[<c0113c28>] (jffs2_gc_fetch_page+0x0/0x60) from [<c011128c>]
(jffs2_garbage_collect_pass+0x1130/0x185c)
 r4:00007850
[<c011015c>] (jffs2_garbage_collect_pass+0x0/0x185c) from [<c010b358>]
(jffs2_reserve_space+0x134/0x1d0)
[<c010b224>] (jffs2_reserve_space+0x0/0x1d0) from [<c010dd18>]
(jffs2_write_inode_range+0x60/0x37c)
[<c010dcb8>] (jffs2_write_inode_range+0x0/0x37c) from [<c0108f08>]
(jffs2_commit_write+0x130/0x264)
[<c0108dd8>] (jffs2_commit_write+0x0/0x264) from [<c007a5c4>]
(generic_file_buffered_write+0x41c/0x610)
[<c007a1ac>] (generic_file_buffered_write+0x4/0x610) from [<c007af84>]
(__generic_file_aio_write_nolock+0x51c/0x54c)
[<c007aa68>] (__generic_file_aio_write_nolock+0x0/0x54c) from
[<c007b034>] (generic_file_aio_write+0x80/0xf4)
[<c007afb8>] (generic_file_aio_write+0x4/0xf4) from [<c0097d10>]
(do_sync_write+0xc0/0x110)
[<c0097c50>] (do_sync_write+0x0/0x110) from [<c0097e2c>] (vfs_write+0xcc/0x150)
 r9:c38a2000 r8:00000000 r7:00000190 r6:c38a3f78 r5:bec68b1c
r4:c3d313e0
[<c0097d60>] (vfs_write+0x0/0x150) from [<c0097f70>] (sys_write+0x4c/0x74)
 r7:00007850 r6:c38a3f78 r5:c3d313e0 r4:c3d31400
[<c0097f24>] (sys_write+0x0/0x74) from [<c0038de0>] (ret_fast_syscall+0x0/0x2c)
 r8:c0038f84 r7:00000004 r6:00800000 r5:bec68cac r4:00000000
