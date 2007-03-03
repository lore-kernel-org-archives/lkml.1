Return-Path: <linux-kernel-owner+w=401wt.eu-S2992953AbXCCDHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992953AbXCCDHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 22:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992956AbXCCDHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 22:07:42 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:37825 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992953AbXCCDHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 22:07:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S9HhwfZ1SBixaN9Tv8uPFM4FSdu30Uc0Qw3w5fqfEh27vR8k+hbiI/a56cuRY8BZFBO06fbqfz6ljuXGBqEqwZQw1JKa0q5YyzkdiAp+VKzwwMkmucqYMIT6GibOTlGZvsfZ3xs2XvnKm64elFX+19FVOYb6kyK3NIGafAAQ5S8=
Message-ID: <170fa0d20703021907x19abef70g1a1b10c21122f7e4@mail.gmail.com>
Date: Fri, 2 Mar 2007 22:07:40 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Wendy Cheng" <wcheng@redhat.com>
Subject: lock_rename for cluster filesystems? (was: Re: [PATCH] prune_icache_sb)
Cc: "Russell Cattelan" <cattelan@thebarn.com>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/4/06, Wendy Cheng <wcheng@redhat.com> wrote:
> Russell Cattelan wrote:
> > Wendy Cheng wrote:
> >
> >> Linux kernel, particularly the VFS layer, is starting to show signs
> >> of inadequacy as the software components built upon it keep growing.
> >> I have doubts that it can keep up and handle this complexity with a
> >> development policy like you just described (filesystem is a dumb
> >> layer ?). Aren't these DIO_xxx_LOCKING flags inside
> >> __blockdev_direct_IO() a perfect example why trying to do too many
> >> things inside vfs layer for so many filesystems is a bad idea ? By
> >> the way, since we're on this subject, could we discuss a little bit
> >> about vfs rename call (or I can start another new discussion thread) ?
> >>
> >> Note that linux do_rename() starts with the usual lookup logic,
> >> followed by "lock_rename", then a final round of dentry lookup, and
> >> finally comes to filesystem's i_op->rename call. Since lock_rename()
> >> only calls for vfs layer locks that are local to this particular
> >> machine, for a cluster filesystem, there exists a huge window between
> >> the final lookup and filesystem's i_op->rename calls such that the
> >> file could get deleted from another node before fs can do anything
> >> about it. Is it possible that we could get a new function pointer
> >> (lock_rename) in inode_operations structure so a cluster filesystem
> >> can do proper locking ?
> >
> > It looks like the ocfs2 guys have the similar problem?
> >
> > http://ftp.kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/ocfs2_git_patches/ocfs2-upstream-linus-20060924/0009-PATCH-Allow-file-systems-to-manually-d_move-inside-of-rename.txt
> >
> >
> >
>
> Thanks for the pointer. Same as ocfs2, under current VFS code, both
> GFS1/2 also need FS_ODD_RENAME flag for the rename problem - got an ugly
> ~200 line draft patch ready for GFS1 (and am looking into GFS2 at this
> moment). The issue here is, for GFS, if vfs lock_rename() can call us,
> this complication can be greatly reduced. Will start another thread to
> see whether the wish can be granted.

Hi Wendy,

Have you (or others) made any progress on a possible solution to
simplify handling cluster fs do_rename() races (e.g. your proposed
lock_rename in inode_operations)?

I couldn't find a newer thread that continued this discussion...

please advise, thanks.
Mike
