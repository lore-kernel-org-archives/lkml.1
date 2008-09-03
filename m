Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYICWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYICWgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYICWgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:36:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbYICWgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:36:42 -0400
Date: Wed, 3 Sep 2008 15:36:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nye Liu <nyet@mrv.com>
Cc: nyet@nyet.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
 cpio images
Message-Id: <20080903153637.0e9dc471.akpm@linux-foundation.org>
In-Reply-To: <20080903223114.GA9456@mrv.com>
References: <20080805195232.GA5183@curtisfong.org>
	<20080903202938.GA9065@curtisfong.org>
	<20080903152231.6b82d9bf.akpm@linux-foundation.org>
	<20080903223114.GA9456@mrv.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 15:31:14 -0700
Nye Liu <nyet@mrv.com> wrote:

> On Wed, Sep 03, 2008 at 03:22:31PM -0700, Andrew Morton wrote:
> > > From: Nye Liu <nyet@nyet.org>
> > > 
> > > When unpacking the cpio into the initramfs, mtimes are not preserved by
> > > default. This patch adds an INITRAMFS_PRESERVE_MTIME option that allows mtimes
> > > stored in the cpio image to be used when constructing the initramfs. For
> > > embedded applications that run exclusively out of the initramfs, this is
> > > invaluable.
> > 
> > Why is it "invlauable".  Please explain this value in full detail -
> > it's the whole reason for merging the patch!
> 
> When building embedded application initramfs images, its nice to know
> when the files were actually created during the build process - that
> makes it easier to see what files were modified when so we can compare
> the files that are being used on the image with the files used during
> the build process. This might help (for example) to determine if the
> target system has all the updated files you expect to see w/o having to
> check MD5s etc.
> 
> In our environment, the whole system runs off the initramfs partition,
> and seeing the modified times of the shared libraries (for example)
> helps us find bugs that may have been introduced by the build system
> incorrectly propogating outdated shared libraries into the image.
> 
> Similarly, many of the initializion/configuration files in /etc
> might be dynamically built by the build system, and knowing when
> they were modified helps us sanity check whether the target system
> has the "latest" files etc.
> 
> Finally, we might use last modified times to determine whether a
> hot fix should be applied or not to the running ramfs.
> 

Thanks, I updated the changelog.

> > gargh.  Why does this work?  It's normally a big fail to pass a kernel
> > address into a system call.  I guess we're running under KERNEL_DS here
> > and getname() and strncpy_from_user() did the right thing.
> > 
> > On what CPU architecture was this tested?
> > 
> > Wouldn't it be simpler to put a timespec into struct dir_entry then go
> > direct to do_utimes() here?
> > 

Did you see this stuff?
