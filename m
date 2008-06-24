Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYFXVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYFXVjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYFXVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:39:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYFXVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:39:06 -0400
Date: Tue, 24 Jun 2008 14:38:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
Subject: Re: [PATCH 0/3] freeze feature ver 1.6
Message-Id: <20080624143840.c183d0d9.akpm@linux-foundation.org>
In-Reply-To: <20080624155919t-sato@mail.jp.nec.com>
References: <20080624155919t-sato@mail.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 15:59:19 +0900
Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> Hi Andrew and Alexander,
> 
> I have implemented the ioctls for the filesystem freeze feature
> and discussed its implementation on the ML (linux-ext4, xfs,
> linux-fsdevel, linux-kernel) for five months.  All of the comments are
> addressed in my patch-set.
> Could you consider merging it into Linux?
> 
> The filesystem freeze feature can suspend accesses to the filesystem
> keeping the filesystem's consistency.  We can take the consistent backup
> with it cooperating with the backup software.
> 
> The patches are re-based from linux-2.6.26-rc3 to linux-2.6.26-rc7
> There is no functional change from the previous version.
> The patch-set consists of the following three patches.
> 
> [PATCH 1/3] Implement generic freeze feature
>   I have modified to set the suitable error number (EOPNOTSUPP)
>   in case the filesystem doesn't support the freeze feature.
> 
>   The ioctls for the generic freeze feature are below.
>   o Freeze the filesystem
>     int ioctl(int fd, int FIFREEZE, arg)
>       fd: The file descriptor of the mountpoint
>       FIFREEZE: request code for the freeze
>       arg: Ignored
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
>   o Unfreeze the filesystem
>     int ioctl(int fd, int FITHAW, arg)
>       fd: The file descriptor of the mountpoint
>       FITHAW: request code for unfreeze
>       arg: Ignored
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
> [PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
>   It removes XFS specific ioctl interfaces and request codes
>   for freeze feature.
>   This patch has been supplied by David Chinner.
> 
> [PATCH 3/3] Add timeout feature
>   The timeout feature is added to freeze ioctl.  And new ioctl
>   to reset the timeout period is added.
>   o Freeze the filesystem
>     int ioctl(int fd, int FIFREEZE, long *timeval)
>       fd: The file descriptor of the mountpoint
>       FIFREEZE: request code for the freeze
>       timeval: the timeout period in seconds
>                If it's 0 or 1, the timeout isn't set.
>                This special case of "1" is implemented to keep
>                the compatibility with XFS applications.
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
>   o Reset the timeout period
>     This is useful for the application to set the timeval more accurately.
>     For example, the freezer resets the timeval to 10 seconds every 5
>     seconds.  In this approach, even if the freezer causes a deadlock
>     by accessing the frozen filesystem, it will be solved by the timeout
>     in 10 seconds and the freezer can recognize that at the next reset
>     of timeval.
>     int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
>       fd:file descriptor of mountpoint
>       FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
>       timeval: new timeout period in seconds
>       Return value: 0 if the operation succeeds. Otherwise, -1
>       Error number: If the filesystem has already been unfrozen,
>                     errno is set to EINVAL.
> 
> Any comments are very welcome.

umm, OK, but nowhere in this patch series can I find a justification or
reason for making these changes to Linux.  Why do we want to do this? 
What is the benefit?  What is the motivation.  What are the use-cases,
etc?

Thanks.
