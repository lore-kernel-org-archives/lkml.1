Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbXEPB6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbXEPB6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEPB61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:58:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754467AbXEPB60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:58:26 -0400
Date: Tue, 15 May 2007 18:53:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Clemens Schwaighofer <cs@tequila.co.jp>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
Message-Id: <20070515185350.2e77bf21.akpm@linux-foundation.org>
In-Reply-To: <464A4F56.6080108@tequila.co.jp>
References: <464A4F56.6080108@tequila.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 09:24:54 +0900 Clemens Schwaighofer <cs@tequila.co.jp> wrote:

> I have re-occurring oopses and panics in those above kernels. The error
> is always the same. I have the last Kernel Panic as a picture here:
> 
> http://dev.tequila.jp/clemens/R0010172.JPG
> 
> The oops have the same error style like this Panic. I tried to capture
> one, but right after copying it into vim, I got a Panic. So next time I
> try to.
> 
> I think it started with 2.6.19.2, I cannot remember I had any of those
> problems before. The box can work fine for about a week or more, or it
> looks up several times a day. I run a memtest for 10 h, but I had no errors.

shrink_dcache_memory->...sysfs_d_iput->BUG

                BUG_ON(sd->s_dentry != dentry);

a number of people have hit that, on and off.

We were close to having a fix, I think, but then we decided that great
chunks of sysfs needed rewriting and I believe that we believe that this
great rewrite will fix this bug.

But alas, it's all too late for 2.6.22.

How frequently do you see these failures?  If it's repeatable with any reliability
then it'd be great if you could test a patchset for us.  It's at:

http://userweb.kernel.org/~akpm/cs.gz

that's a single patch against 2.6.21-rc1, containing the following patches, which 
are from the forthcoming 2.6.21-rc1-mm1 lineup:

origin
gregkh-driver-uio
gregkh-driver-uio-documentation
gregkh-driver-uio-hilscher-cif-card-driver
gregkh-driver-idr-fix-obscure-bug-in-allocation-path
gregkh-driver-idr-separate-out-idr_mark_full
gregkh-driver-ida-implement-idr-based-id-allocator
gregkh-driver-sysfs-move-release_sysfs_dirent-to-dirc
gregkh-driver-sysfs-allocate-inode-number-using-ida
gregkh-driver-sysfs-make-sysfs_put-ignore-null-sd
gregkh-driver-sysfs-fix-error-handling-in-binattr-write
gregkh-driver-sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir
gregkh-driver-sysfs-flatten-and-fix-sysfs_rename_dir-error-handling
gregkh-driver-sysfs-consolidate-sysfs_dirent-creation-functions
gregkh-driver-sysfs-add-sysfs_dirent-s_parent
gregkh-driver-sysfs-add-sysfs_dirent-s_name
gregkh-driver-sysfs-make-sysfs_dirent-s_element-a-union
gregkh-driver-sysfs-implement-kobj_sysfs_assoc_lock
gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree
gregkh-driver-sysfs-implement-bin_buffer
gregkh-driver-sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect
gregkh-driver-sysfs-kill-attribute-file-orphaning
gregkh-driver-sysfs-separate-out-sysfs_attach_dentry
gregkh-driver-sysfs-reimplement-syfs_drop_dentry
gregkh-driver-sysfs-kill-unnecessary-attribute-owner
gregkh-driver-driver-core-make-devt_attr-and-uevent_attr-static
gregkh-driver-put_device-might_sleep
gregkh-driver-kobject-warn
gregkh-driver-warn-when-statically-allocated-kobjects-are-used
gregkh-driver-nozomi
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write

Thanks.
