Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYGQSOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYGQSOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760657AbYGQSOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:14:44 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:57668 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbYGQSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Oohp72Hp7W56btHyEjGHB2/D+F0mIV3wO+/+jjKNPUbSFxo2q8LaemBPLhVoV7zlJd
         d8wWqJm3ecwtZ4V/lGNSO8AoaqJR3wJGCQDfpqaJrsJgA33m4y6sXC7DCd4p4uApfKPo
         PEu6s3XalzJEkA4JaRLNQxej6hebpWkUdZ+c4=
Message-ID: <19f34abd0807171114i5201f41cs9f222e0e49592573@mail.gmail.com>
Date: Thu, 17 Jul 2008 20:14:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: reiserfs-devel@vger.kernel.org
Subject: latest -git: assertion !(n_file_size > ROUND_UP(n_new_file_size)) failed at fs/reiserfs/stree.c:1903
Cc: "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got this with an intentionally corrupted disk image:

ReiserFS: loop0: found reiserfs format "3.6" with standard journal
ReiserFS: loop0: warning: CONFIG_REISERFS_CHECK is set ON
ReiserFS: loop0: warning: - it is slow mode for debugging.
ReiserFS: loop0: using ordered data mode
ReiserFS: loop0: journal params: device loop0, size 8192, journal
first block 18, max trans len 1024, max batch 900, max commit age 30,
max trans age 30
ReiserFS: loop0: checking transaction log (loop0)
ReiserFS: loop0: journal-1153: found in header: first_unflushed_offset
81, last_flushed_trans_id 27
ReiserFS: loop0: journal-1206: Starting replay from offset
120259084369, trans_id 1024
ReiserFS: loop0: journal-1299: Setting newest_mount_id to 13
ReiserFS: loop0: Using r5 hash to sort names
Pid: 4274, comm: rm Not tainted 2.6.26-03414-g33af79d #43
 [<c020a2ea>] reiserfs_panic+0x1a/0x50
 [<c0216d0b>] reiserfs_do_truncate+0x56b/0x6a0
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c0216e72>] reiserfs_delete_object+0x32/0x70
 [<c01fefd6>] reiserfs_delete_inode+0xb6/0x110
 [<c01fef20>] ? reiserfs_delete_inode+0x0/0x110
 [<c01b9ba1>] generic_delete_inode+0x81/0x120
 [<c01b9d67>] generic_drop_inode+0x127/0x180
 [<c01b8be7>] iput+0x47/0x50
 [<c01af1bc>] do_unlinkat+0xec/0x170
 [<c01b185b>] ? vfs_readdir+0x6b/0xa0
 [<c01b1540>] ? filldir64+0x0/0xf0
 [<c044a0f8>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c01af383>] sys_unlinkat+0x23/0x50
 [<c010407f>] sysenter_past_esp+0x78/0xc5
 =======================
Kernel panic - not syncing: <0>REISERFS: panic (device Null
superblock): reiserfs[4274]: assertion !(n_file_size >
ROUND_UP(n_new_file_size)) failed at
fs/reiserfs/stree.c:1903:reiserfs_do_truncate: PAP-5680: truncate did
not finish: new_file_size 0, current 2147483648, oid 96

(Where did the register dump go? Will this get picked up by kerneloops.org?)

I can test patches.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
