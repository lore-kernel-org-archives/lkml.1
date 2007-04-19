Return-Path: <linux-kernel-owner+w=401wt.eu-S1766949AbXDSTWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766949AbXDSTWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766951AbXDSTWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:22:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34535 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766949AbXDSTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:22:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769696321319-git-send-email-ebiederm@xmission.com>
	<1176999710.6663.12.camel@heimdal.trondhjem.org>
Date: Thu, 19 Apr 2007 13:20:29 -0600
In-Reply-To: <1176999710.6663.12.camel@heimdal.trondhjem.org> (Trond
	Myklebust's message of "Thu, 19 Apr 2007 12:21:50 -0400")
Message-ID: <m1slawkw76.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> writes:

> On Thu, 2007-04-19 at 01:58 -0600, Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Start the reclaimer thread using kthread_run instead
>> of a combination of kernel_thread and daemonize.
>> The small amount of signal handling code is also removed
>> as it makes no sense and is a maintenance problem to handle
>> signals in kernel threads.
>
> Vetoed. Removing stuff just because it doesn't make sense to you is not
> acceptable.
>
> Signal handling in reclaimer threads is there in order to allow
> administrators to deal with the case where the server never comes up
> again.

Doesn't unmount handle that?

Regardless kernel threads should be an implementation detail
not a part of the user interface.  If kernel threads are part
of the user interface it makes them very hard to change.

So it isn't that it doesn't make sense to me it is that it looks
fundamentally broken and like a maintenance nightmare.

I would rather kill kernel threads then try and simulate them
when the kernel implementation has changed and kernel threads
are not visible.

If I could be convinced that signal handling in kernel threads
is not something that will impede code modifications and refactoring
I would have less of a problem, and might not care.

With pid namespaces all kernel threads will disappear so how do
we cope with the problem when the sysadmin can not see the kernel
threads?

Eric
