Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYDRWzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYDRWzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYDRWz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:55:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37861 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYDRWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:55:25 -0400
Date: Fri, 18 Apr 2008 16:55:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Introduce down_killable()
Message-ID: <20080418225508.GF20637@parisc-linux.org>
References: <200804181705.m3IH56W4007130@hera.kernel.org> <20080418153455.4d0bee30.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418153455.4d0bee30.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 03:34:55PM -0700, Andrew Morton wrote:
> On Fri, 18 Apr 2008 17:05:06 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > --- a/kernel/semaphore.c
> > +++ b/kernel/semaphore.c
> > @@ -34,6 +34,7 @@
> >  
> >  static noinline void __down(struct semaphore *sem);
> >  static noinline int __down_interruptible(struct semaphore *sem);
> > +static noinline int __down_killable(struct semaphore *sem);
> >  static noinline void __up(struct semaphore *sem);
> 
> What is the reason for all the noinlines in this file?

Copied from kernel/mutex.c ;-)

The reason is to make sure that __down_interruptible (et al) are
out-of-line from down_interruptible, and that __down_common is inlined
into __down_interruptible().

> Something to do with getting proper wchan output?  I guess it doesn't hurt
> from a documentation POV, but did you find that it was actually necessary?
> 
> IOW: is gcc now capable of secretly inlining functions which are defined
> further ahead in the compilation unit?

With -funit-at-a-time, I believe it is capable of that.

> (did you actually "test" the wchan stuff, btw?)

I tested that wchan still produces the right output, yes.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
