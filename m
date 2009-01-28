Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZA1BBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZA1BBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZA1BB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:01:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:47889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZA1BB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:01:26 -0500
Message-ID: <497FAB17.3080607@kernel.org>
Date: Wed, 28 Jan 2009 09:47:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, cornelia.huck@de.ibm.com
Subject: Re: [PATCH] sysfs: Reference sysfs_dirent from sysfs inodes.
References: <m13afch1sw.fsf@fess.ebiederm.org>	<m1k58nffqm.fsf@fess.ebiederm.org>	<497964CC.8070004@kernel.org> <20090127154437.9e7118f7.akpm@linux-foundation.org>
In-Reply-To: <20090127154437.9e7118f7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 01:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 23 Jan 2009 15:33:48 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Eric W. Biederman wrote:
>>> The sysfs_dirent serves as both an inode and a directory entry
>>> for sysfs.  To prevent the sysfs inode numbers from being freed
>>> prematurely hold a reference to sysfs_dirent from the sysfs inode.
>>>
>>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> Thanks for working on this.  Can you please add a comment explaining
>> it on top of sysfs_delete_inode()?
> 
> Like this?
> 
> --- a/fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix
> +++ a/fs/sysfs/inode.c
> @@ -215,6 +215,13 @@ struct inode * sysfs_get_inode(struct sy
>  	return inode;
>  }
>  
> +/*
> + * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
> + * To prevent the sysfs inode numbers from being freed prematurely we take a
> + * reference to sysfs_dirent from the sysfs inode.  A
> + * super_operations.delete_inode() implementation is needed to drop that
> + * reference upon inode destruction.
> + */
>  void sysfs_delete_inode(struct inode *inode)
>  {
>  	struct sysfs_dirent *sd  = inode->i_private;

Yeap, looks good to me.  :-)

Thanks.

-- 
tejun

