Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYEGMVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYEGMVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYEGMVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:21:23 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:20526 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYEGMVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:21:22 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: Andi Kleen <andi@firstfloor.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org>
	<20080507114643.GR19219@parisc-linux.org>
Date: Wed, 07 May 2008 14:21:14 +0200
In-Reply-To: <20080507114643.GR19219@parisc-linux.org> (Matthew Wilcox's message of "Wed, 7 May 2008 05:46:44 -0600")
Message-ID: <87hcdab8zp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 12:14:21.0933 (UTC) FILETIME=[E1E269D0:01C8B03B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> On Wed, May 07, 2008 at 01:00:14PM +0200, Andi Kleen wrote:
>> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
>> > 3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.
>> 
>> I have an older patchkit that introduced unlocked_fnctl for some cases. It was 
>> briefly in mm but then dropped. Sounds like it is worth resurrecting?
>
> Not sure what you're talking about here, Andi.  The only lock_kernel in
> fcntl.c is around the call to ->fasync.  And Yanmin's traces don't show
> fasync as being a culprit, just the paths in locks.c

I was talking about fasync.

>> -Andi (who BTW never quite understood why BKL is a semaphore now and not
>> a spinlock?)
>
> See git commit 6478d8800b75253b2a934ddcb734e13ade023ad0

I am aware of that commit, thank you, but the comment was refering to that it 
came with about zero justification why it was done. For the left over BKL 
regions which are relatively short surely a spinlock would be better than a 
semaphore? So PREEMPT_BKL should have been removed, not !PREEMPT_BKL.

If that was done all these regressions would disappear I bet. That said
of course it is still better to actually fix the lock_kernel()s, but shorter
time just fixing lock_kernel again would be easier.

-Andi

