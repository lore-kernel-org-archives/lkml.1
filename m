Return-Path: <linux-kernel-owner+w=401wt.eu-S1766991AbXDSVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766991AbXDSVTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766997AbXDSVTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:19:44 -0400
Received: from pat.uio.no ([129.240.10.15]:58549 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766991AbXDSVTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:19:43 -0400
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
In-Reply-To: <m1slawkw76.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769696321319-git-send-email-ebiederm@xmission.com>
	 <1176999710.6663.12.camel@heimdal.trondhjem.org>
	 <m1slawkw76.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 17:19:24 -0400
Message-Id: <1177017564.6628.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=12.0, autolearn=disabled, AWL=-0.448)
X-UiO-Scanned: 6E4342854ED447AEC84D8538B72498B3228E8E26
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 291 total 1199537 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 13:20 -0600, Eric W. Biederman wrote:
> Trond Myklebust <trond.myklebust@fys.uio.no> writes:
> 
> > On Thu, 2007-04-19 at 01:58 -0600, Eric W. Biederman wrote:
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >> 
> >> Start the reclaimer thread using kthread_run instead
> >> of a combination of kernel_thread and daemonize.
> >> The small amount of signal handling code is also removed
> >> as it makes no sense and is a maintenance problem to handle
> >> signals in kernel threads.
> >
> > Vetoed. Removing stuff just because it doesn't make sense to you is not
> > acceptable.
> >
> > Signal handling in reclaimer threads is there in order to allow
> > administrators to deal with the case where the server never comes up
> > again.
> 
> Doesn't unmount handle that?

On a pinned filesystem?

> Regardless kernel threads should be an implementation detail
> not a part of the user interface.  If kernel threads are part
> of the user interface it makes them very hard to change.
> 
> So it isn't that it doesn't make sense to me it is that it looks
> fundamentally broken and like a maintenance nightmare.
> 
> I would rather kill kernel threads then try and simulate them
> when the kernel implementation has changed and kernel threads
> are not visible.
> 
> If I could be convinced that signal handling in kernel threads
> is not something that will impede code modifications and refactoring
> I would have less of a problem, and might not care.

Tough. You're the one proposing to change existing code.

> With pid namespaces all kernel threads will disappear so how do
> we cope with the problem when the sysadmin can not see the kernel
> threads?

Then you have a usability problem. How does the sysadmin reboot the
system if there is no way to shut down the processes that are hanging on
an unresponsive filesystem?

Trond

