Return-Path: <linux-kernel-owner+w=401wt.eu-S1162120AbXECPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162120AbXECPDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162121AbXECPDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:03:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:43455 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162120AbXECPDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:03:40 -0400
Date: Thu, 3 May 2007 17:13:17 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070503151317.GB14562@duck.suse.cz>
References: <20070306164447.GC3661@duck.suse.cz> <4632710C.5030104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4632710C.5030104@sandeen.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 27-04-07 16:54:20, Eric Sandeen wrote:
> Jan Kara wrote:
> >   Hello,
> > 
> >   the patches attached to six following emails implement some cleanup and
> > fixes in the UDF code. The main two fixes are:
> >   1) UDF now works correctly for files larger than 1GB.
> >   2) Deleting a directory updates number of links to the parent directory
> >      correctly.
> > See headers of following patches for details.
> > 
> > The patches sustained some torturing so I hope that I did not introduce
> > more bugs than I've fixed ;).  Andrew, could you please put the patches
> > into -mm kernels for testing?  Thanks.
> > 
> > 									Honza
> > 
> 
> Jan -
> 
> I ran 2.6.21 + your udf patches from -mm through some udf tests which,
> oddly enough, can be found in the xfstests test suite in xfsprogs cvs
> from sgi.
> 
> It looks much better than before, but I was able to trip some of your
> asserts.  They were generated while fsx was running.  The good news,
> though, is that fsx passed.  :)  I haven't looked into it much further
> yet, but wanted to let you know.
  Thanks for the news. I'll try running fsx to see if I'll be able to
reproduce the problem (I think I was testing the patches with fsx but maybe
it didn't run long enough).

								Honza

> BUG: at /src/linux-2.6.21-rc5/fs/udf/truncate.c:123 udf_discard_prealloc()
>  [<de969274>] udf_discard_prealloc+0x2d8/0x2ed [udf]
>  [<de95eea5>] udf_release_file+0x15/0x1e [udf]
>  [<c046f5f0>] __fput+0xa5/0x15b
>  [<c046d0d2>] generic_file_open+0x0/0x45
>  [<c046d3f3>] __dentry_open+0x115/0x17a
>  [<c046d4d2>] nameidata_to_filp+0x24/0x33
>  [<c046d513>] do_filp_open+0x32/0x39
>  [<c046d278>] get_unused_fd+0x50/0xb6
>  [<c046d55c>] do_sys_open+0x42/0xbe
>  [<c046d611>] sys_open+0x1c/0x1e
>  [<c0404db8>] syscall_call+0x7/0xb
>  =======================
> BUG: at /src/linux-2.6.21-rc5/fs/udf/truncate.c:123 udf_discard_prealloc()
>  [<de969274>] udf_discard_prealloc+0x2d8/0x2ed [udf]
>  [<de9632ae>] udf_clear_inode+0x1b/0x34 [udf]
>  [<c047eb56>] clear_inode+0xb2/0x100
>  [<c0459a95>] truncate_inode_pages+0x17/0x1a
>  [<c047edfe>] dispose_list+0x33/0xb1
>  [<c047f1f3>] invalidate_inodes+0xa8/0xbd
>  [<c046fff2>] generic_shutdown_super+0x31/0xb7
>  [<c0470095>] kill_block_super+0x1d/0x2d
>  [<c047013d>] deactivate_super+0x52/0x65
>  [<c0480de8>] sys_umount+0x1f2/0x21a
>  [<c044e33f>] audit_syscall_entry+0x10d/0x137
>  [<c0480e27>] sys_oldumount+0x17/0x1a
>  [<c0404db8>] syscall_call+0x7/0xb
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
