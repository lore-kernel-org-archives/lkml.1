Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXDFQmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXDFQmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933271AbXDFQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:42:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54265 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933267AbXDFQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:42:01 -0400
Date: Fri, 6 Apr 2007 11:41:54 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406164153.GA30841@lnx-holt.americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 09:38:24AM -0600, Eric W. Biederman wrote:
> How hard is tasklist_lock hit on these systems?

The major hold-off we are seeing is from tasks reaping children,
especially tasks with very large children lists.

> How hard is the pid hash hit on these systems?

In the little bit of testing we got before the machine got taken away,
we never observed significant issues with the pid hash.  We only got
time to run a few benchmarks like aim7.

...
> The big benefit of the zombie list over your proposed list reordering
> is that waitpid can return immediately when we don't have zombies to
> wait for, but we have lots of children.  So it looks like a universal
> benefit and about as good as it is possible to make zombie handling
> of waitpid.

Is this something you are taking on as a task for yourself or do you
want me to pursue?  I am extremely swamped on other non-kernel issues
and Jack is off working on x86_64 issues so we would both _greatly_
appreciate any help you can give.  Of course, we understand this is an
issue that is affecting us and the responsibility ultimately lies here.

As for testing a proposed patch, we have a customer machine available for
the next few days which could be put into the same configuration we had
for this test, but it will be limited availability and then only assuming
the SGI site test personnel are certain the machine meets customer needs.

Thanks,
Robin
