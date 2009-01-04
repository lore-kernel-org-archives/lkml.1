Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZADBX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZADBX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZADBXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:23:50 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4550 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZADBXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:23:50 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2009 20:23:49 EST
Message-ID: <49600DE6.2080108@shikadi.net>
Date: Sun, 04 Jan 2009 11:16:22 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.18) Gecko/20081215 Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: XFS internal error xfs_da_do_buf(1) at line 2015 of file fs/xfs/xfs_da_btree.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm having a recurring problem with XFS which started about a day ago.  All of 
a sudden when reading a certain part of the disk (not sure where, but my 
nightly backups trigger it) I get an infinite loop of these messages appearing 
in my logs:

xfs_da_do_buf: bno 8388608
dir: inode 3087268096
Filesystem "md0": XFS internal error xfs_da_do_buf(1) at line 2015 of file 
fs/xfs/xfs_da_btree.c.  Caller 0xffffffff802eba63
Pid: 4445, comm: metalog Tainted: P           2.6.28-rc2 #3
Call Trace:
  [<ffffffff802eba63>] xfs_da_read_buf+0x24/0x29
  [<ffffffff802eb6aa>] xfs_da_do_buf+0x2d2/0x621
  [<ffffffff80267fb0>] balance_dirty_pages_ratelimited_nr+0x300/0x329
  [<ffffffff802a52af>] block_write_end+0x4a/0x54
  [<ffffffff802eba63>] xfs_da_read_buf+0x24/0x29
  [<ffffffff802ecd0a>] xfs_da_node_lookup_int+0x5b/0x225
  [<ffffffff802ecd0a>] xfs_da_node_lookup_int+0x5b/0x225
  [<ffffffff802f2908>] xfs_dir2_node_lookup+0x43/0xe7
  [<ffffffff802edbff>] xfs_dir2_isleaf+0x19/0x4a
  [<ffffffff802ee357>] xfs_dir_lookup+0x10f/0x14f
  [<ffffffff80297a74>] __d_lookup+0x11a/0x143
  [<ffffffff80314b4b>] xfs_lookup+0x48/0xa5
  [<ffffffff8031d06e>] xfs_vn_lookup+0x3c/0x78
  [<ffffffff8028fafa>] __lookup_hash+0xfa/0x11e
  [<ffffffff8029288d>] do_filp_open+0x159/0x7d7
  [<ffffffff80507856>] _spin_unlock+0x10/0x2a
  [<ffffffff8029a608>] alloc_fd+0x112/0x123
  [<ffffffff8028701e>] do_sys_open+0x48/0xcc
  [<ffffffff8020b3bb>] system_call_fastpath+0x16/0x1b

It doesn't seem to interfere with filesystem use, but metalog is logging 
thousands of these messages into the system log files (the log files grow at 
about 1MB/minute.)

Does anyone know what this error means?  Do I need to reformat the filesystem?

I've restarted a few times and the error goes away until the next nightly 
backup triggers it again.  Killing metalog does seem to stop the messages, so 
perhaps one of the log files is the culprit?  I'm not sure how to map that 
inode or bno back to a filename.  It's always the same bno/inode and always 
reports metalog as the offending program.

Any suggestions how to go about diagnosing this problem?

Many thanks,
Adam.
