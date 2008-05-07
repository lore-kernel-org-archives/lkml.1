Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbYEGLrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbYEGLrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYEGLrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:47:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49466 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYEGLrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:47:02 -0400
Date: Wed, 7 May 2008 05:46:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507114643.GR19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lk2mbcqp.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:00:14PM +0200, Andi Kleen wrote:
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> > 3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.
> 
> I have an older patchkit that introduced unlocked_fnctl for some cases. It was 
> briefly in mm but then dropped. Sounds like it is worth resurrecting?

Not sure what you're talking about here, Andi.  The only lock_kernel in
fcntl.c is around the call to ->fasync.  And Yanmin's traces don't show
fasync as being a culprit, just the paths in locks.c

> tty_* is being taken care of by Alan.
> 
> chrdev_open is more work.
> 
> -Andi (who BTW never quite understood why BKL is a semaphore now and not
> a spinlock?)

See git commit 6478d8800b75253b2a934ddcb734e13ade023ad0

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
