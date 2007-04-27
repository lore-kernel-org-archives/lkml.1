Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXD0Vz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXD0Vz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbXD0Vz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:55:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbXD0Vyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:54:52 -0400
Message-ID: <4632710C.5030104@sandeen.net>
Date: Fri, 27 Apr 2007 16:54:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
References: <20070306164447.GC3661@duck.suse.cz>
In-Reply-To: <20070306164447.GC3661@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   Hello,
> 
>   the patches attached to six following emails implement some cleanup and
> fixes in the UDF code. The main two fixes are:
>   1) UDF now works correctly for files larger than 1GB.
>   2) Deleting a directory updates number of links to the parent directory
>      correctly.
> See headers of following patches for details.
> 
> The patches sustained some torturing so I hope that I did not introduce
> more bugs than I've fixed ;).  Andrew, could you please put the patches
> into -mm kernels for testing?  Thanks.
> 
> 									Honza
> 

Jan -

I ran 2.6.21 + your udf patches from -mm through some udf tests which,
oddly enough, can be found in the xfstests test suite in xfsprogs cvs
from sgi.

It looks much better than before, but I was able to trip some of your
asserts.  They were generated while fsx was running.  The good news,
though, is that fsx passed.  :)  I haven't looked into it much further
yet, but wanted to let you know.

Thanks,
-Eric


BUG: at /src/linux-2.6.21-rc5/fs/udf/truncate.c:123 udf_discard_prealloc()
 [<de969274>] udf_discard_prealloc+0x2d8/0x2ed [udf]
 [<de95eea5>] udf_release_file+0x15/0x1e [udf]
 [<c046f5f0>] __fput+0xa5/0x15b
 [<c046d0d2>] generic_file_open+0x0/0x45
 [<c046d3f3>] __dentry_open+0x115/0x17a
 [<c046d4d2>] nameidata_to_filp+0x24/0x33
 [<c046d513>] do_filp_open+0x32/0x39
 [<c046d278>] get_unused_fd+0x50/0xb6
 [<c046d55c>] do_sys_open+0x42/0xbe
 [<c046d611>] sys_open+0x1c/0x1e
 [<c0404db8>] syscall_call+0x7/0xb
 =======================
BUG: at /src/linux-2.6.21-rc5/fs/udf/truncate.c:123 udf_discard_prealloc()
 [<de969274>] udf_discard_prealloc+0x2d8/0x2ed [udf]
 [<de9632ae>] udf_clear_inode+0x1b/0x34 [udf]
 [<c047eb56>] clear_inode+0xb2/0x100
 [<c0459a95>] truncate_inode_pages+0x17/0x1a
 [<c047edfe>] dispose_list+0x33/0xb1
 [<c047f1f3>] invalidate_inodes+0xa8/0xbd
 [<c046fff2>] generic_shutdown_super+0x31/0xb7
 [<c0470095>] kill_block_super+0x1d/0x2d
 [<c047013d>] deactivate_super+0x52/0x65
 [<c0480de8>] sys_umount+0x1f2/0x21a
 [<c044e33f>] audit_syscall_entry+0x10d/0x137
 [<c0480e27>] sys_oldumount+0x17/0x1a
 [<c0404db8>] syscall_call+0x7/0xb
