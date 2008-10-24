Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYJXKmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYJXKmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYJXKl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:41:56 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49684 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbYJXKlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:41:55 -0400
Date: Fri, 24 Oct 2008 06:41:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: ext3: fix ext3_dx_readdir hash collision handling - Regression
Message-ID: <20081024104152.GB8658@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20081024042851.GA2360@gentoox2.trippelsdorf.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 06:28:51AM +0200, Markus Trippelsdorf wrote:
> 
> Notice that I don't use "rm -rf" but "rm -r". The problem only occurs
> when I run "rm -r" without the "-f" switch.
> 

Still having trouble reproducing it.  I'll try to look more at your
.config.  One difference i can see right off the bat is that I'm still
using an 32-bit x86 system, not a 64-bit x86 system.  That shouldn't
make a difference, though....

							- Ted

Script started on Fri 24 Oct 2008 06:36:47 AM EDT
Top-level shell (parent script)
Using forwarded ssh authentication socket
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
498# mke2fs -t ext3 /dev/thunk/testext4
mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 22 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
499# debugfs -w /dev/thunk/testext4
debugfs 1.41.3 (12-Oct-2008)
debugfs:  ssv s_hash_seed c3188d40-b161-4458-b3f9-22ca7788110f
debugfs:  ssv s_def_hash_version tea
debugfs:  q
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
500# mount /dev/thunk/testext4 /mnt
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
501# tar -C /mnt -xjf /usr/projects/linux/linux-2.6.27.2.tar.bz2 
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
502# /bin/rm -r /mnt/linux-2.6.27.2/
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
503# umount /mnt/
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
504# uname -a
Linux closure 2.6.27-00067-g5593f6c-dirty #13 SMP Thu Oct 23 22:22:03 EDT 2008 i686 GNU/Linux
<tytso.root@closure> {/usr/projects/linux/ext4}  [btree-debug]
505# exit

Script done on Fri 24 Oct 2008 06:39:22 AM EDT
