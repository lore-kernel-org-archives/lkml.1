Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYEEKVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYEEKVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbYEEKSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:18:38 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:46631 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757191AbYEEKSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:18:36 -0400
Date: Mon, 5 May 2008 11:18:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: DM <dm.n9107@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-mips@linux-mips.org,
       sparclinux@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] unify sys_pipe implementation
Message-ID: <20080505101809.GA14547@linux-mips.org>
References: <200805031801.m43I109q032242@devserv.devel.redhat.com> <5eeb9ad90805050130i39ae791dwe599c12fc08fb8ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eeb9ad90805050130i39ae791dwe599c12fc08fb8ec@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 10:30:09AM +0200, DM wrote:

> >  + * sys_pipe() is the normal C calling standard for creating
> >  + * a pipe. It's not the way Unix traditionally does this, though.
> >  + */
> >  +asmlinkage long sys_pipe(int __user *fildes)
> >  +{
> >  +       int fd[2];
> >  +       int error;
> >  +
> >  +       error = do_pipe(fd);
> >  +       if (!error) {
> >  +               if (copy_to_user(fildes, fd, sizeof(fd)))
> >  +                       error = -EFAULT;
> >  +       }
> >  +       return error;
> >  +}
> >  +
> [...]
> 
> I realize this code is old, but wouldn't file descriptors leak if
> copy_to_user fails?

The MIPS implementation doesn't have this problem; it returns the
file descriptors in the result registers $v0 and $v1.

But an interesting catch after so many years!

  Ralf
