Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYJWGh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYJWGh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJWGhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:37:48 -0400
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1106 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752181AbYJWGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:37:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 29553
Date: Thu, 23 Oct 2008 08:37:40 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: ext3: fix ext3_dx_readdir hash collision handling - Regression
Message-ID: <20081023063740.GA2438@gentoox2.trippelsdorf.de>
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023032832.GE10369@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:28:32PM -0400, Theodore Tso wrote:
> On Wed, Oct 22, 2008 at 11:32:01AM +0200, Markus Trippelsdorf wrote:
> > Commit 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d 
> > "ext3: fix ext3_dx_readdir hash collision handling" causes a regression
> > when deleting big directories.
> > 
> > I'm using an ext3 filesystem in data=writeback mode as my root fs.
> > When I untar a kernel tarball and then rm -r the files, this is what
> > happens on my machine (latest git):
> > 
> > markus@gentoox2 ~ % tar xjf  linux-2.6.27.2.tar.bz2
> > markus@gentoox2 ~ % rm -r linux-2.6.27.2
> > rm: cannot remove `linux-2.6.27.2/arch/alpha/include/asm/statfs.h': No such file or directory...
> 
> I haven't been able to replicate this.  Does it matter which kernel
> tarball you use?  And can you send me the output of "dumpe2fs -h
> /dev/hdXX", where hdXX is the device of the filesystem where this was
> failing?

No, it happens with _every_ tarball from a certain size on. 
Ext4 is also affected due to d015641734cde55d2fce48a6db3983c8a029fe05 .

This is the output of dumpe2fs -h /dev/sda1:

dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   /
Last mounted on:          <not available>
Filesystem UUID:          9a6c302d-e3f3-4fea-96d8-dad6890780a9
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery sparse_super large_file
Filesystem flags:         signed_directory_hash
Default mount options:    journal_data_writeback
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              6406144
Block count:              25599569
Reserved block count:     1279978
Free blocks:              19067411
Free inodes:              5642168
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1017
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Filesystem created:       Sat May  3 13:22:22 2008
Last mount time:          Thu Oct 23 08:27:43 2008
Last write time:          Thu Oct 23 08:27:43 2008
Mount count:              40
Maximum mount count:      -1
Last checked:             Wed Oct 15 20:42:58 2008
Check interval:           0 (<none>)
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Journal inode:            8
First orphan inode:       2233455
Default directory hash:   tea
Directory Hash Seed:      c3188d40-b161-4458-b3f9-22ca7788110f
Journal backup:           inode blocks
Journal size:             128M

-- 
Markus
