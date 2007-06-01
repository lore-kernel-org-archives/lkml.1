Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbXFAWiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbXFAWiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXFAWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:37:51 -0400
Received: from sandeen.net ([209.173.210.139]:15697 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXFAWhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:37:50 -0400
Message-ID: <46609FBD.5040407@sandeen.net>
Date: Fri, 01 Jun 2007 17:37:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <20070601211036.GA23975@duck.suse.cz>
In-Reply-To: <20070601211036.GA23975@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Thanks for info - I'm now mostly out of email for a few days but I'll
> have a look at it as soon as I return.
> 
> 								Honza

Here we go:

[1]kdb> btp 3263
Stack traceback for pid 3263
0xffff81006f1b8100     3263     3247  1    0   R  0xffff81006f1b83d0 
lt-fsstress
rsp                rip                Function (args)
0xffff81006f335c48 0xffffffff8044b989 _spin_lock+0x7
0xffff81006f335c70 0xffffffff802a914b __mark_inode_dirty+0xe0
0xffff81006f335ca0 0xffffffff882d47d0 [udf]udf_write_aext+0x101
0xffff81006f335cd0 0xffffffff882dd95a [udf]extent_trunc+0xd6
0xffff81006f335d20 0xffffffff882dda81 [udf]udf_truncate_tail_extent+0xda
0xffff81006f335da0 0xffffffff882d7c26 [udf]udf_drop_inode+0x26
0xffff81006f335db0 0xffffffff8029f816 iput+0x74
0xffff81006f335dc0 0xffffffff8029d6a8 dentry_iput+0x8f
0xffff81006f335de0 0xffffffff8029d748 d_kill+0x21
0xffff81006f335e00 0xffffffff8029e450 prune_one_dentry+0x3a
0xffff81006f335e20 0xffffffff8029e5e8 prune_dcache+0xe3
0xffff81006f335e50 0xffffffff8029e6bf shrink_dcache_parent+0x21
0xffff81006f335e80 0xffffffff80294a27 dentry_unhash+0x1d
0xffff81006f335e90 0xffffffff80295d43 vfs_rmdir+0x88
0xffff81006f335eb0 0xffffffff80297d5b do_rmdir+0x9c
0xffff81006f335f40 0xffffffff8020ce23 syscall_trace_enter+0x8d
0xffff81006f335f70 0xffffffff80297dd4 sys_rmdir+0x11
0xffff81006f335f80 0xffffffff80209d5c tracesys+0xdc

going for the inode_lock twice?

-Eric
