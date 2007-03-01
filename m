Return-Path: <linux-kernel-owner+w=401wt.eu-S965563AbXCAUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbXCAUX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030200AbXCAUX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:23:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43964 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbXCAUX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:23:28 -0500
Message-ID: <45E73637.1000508@garzik.org>
Date: Thu, 01 Mar 2007 15:23:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit K. Arora wrote:
> This is to give a heads up on few patches that we will be soon coming up
> with. These patches implement a new system call sys_fallocate() and a
> new inode operation "fallocate", for persistent preallocation. The new
> system call, as Andrew suggested, will look like:
> 
>   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
> 
> As we are developing and testing the required patches, we decided to
> post a preliminary patch and get inputs from the community to give it
> a right direction and shape. First, a little description on the feature.
>  
> Persistent preallocation is a file system feature using which an
> application (say, relational database servers) can explicitly
> preallocate blocks to a particular file. This feature can be used to
> reserve space for a file to get mainly the following benefits:
> 1> contiguity - less defragmentation and thus faster access speed, and
> 2> guarantee for a minimum space availibility (depending on how many
> blocks were preallocated) for the file, even if the filesystem becomes
> full.
> 
> XFS already has an implementation for this, using an ioctl interface. And,
> ext4 is now coming up with this feature. In coming time we may see a few
> more file systems implementing this. Thus, it makes sense to have a more
> standard interface for this, like this new system call.
> 
> Here is the initial and incomplete version of the patch, which can be
> used for the discussion, till we come up with a set of more complete
> patches.
> 
> ---
>  arch/i386/kernel/syscall_table.S |    1 +
>  fs/ext4/file.c                   |    1 +
>  fs/open.c                        |   18 ++++++++++++++++++
>  include/asm-i386/unistd.h        |    3 ++-
>  include/linux/fs.h               |    1 +
>  include/linux/syscalls.h         |    1 +
>  6 files changed, 24 insertions(+), 1 deletion(-)

I certainly agree that we want something like this.

posix_fallocate() is the glibc interface we want to be compatible with 
(which your definition is, AFAICS).

	Jeff



