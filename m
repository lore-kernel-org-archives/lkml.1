Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXH1Xy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXH1Xy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbXH1XyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:54:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51423 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbXH1XyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:54:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
Date: Tue, 28 Aug 2007 17:53:53 -0600
In-Reply-To: <20070828230459.GA15937@infradead.org> (Christoph Hellwig's
	message of "Wed, 29 Aug 2007 00:04:59 +0100")
Message-ID: <m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Umm, no way we're ever going to remove a syscall like this.  

If someone besides me cares about more then rhetoric I will be happy
to reconsider and several years is plenty of time to find that out.

I aborted the removal last time precisely because we had not done an
adequate job of warning our users.  A printk when we run a program
that uses the binary interface and an long enough interval the warning
makes it to the Enterprise kernels before we remove the interface
should be sufficient.

> stop this deprecration crap.  Just make sure no ones adds more binary
> sysctls.

The sysctl_check_table function should keep out most of the problem
cases and especially it should ensure we don't add any new binary
sysctls by accident. 

However given our atrocious record at catching these kinds of
problems via code review and testing and the fact that no one
uses these things anyway, I don't see an argument for keeping
dead code in the kernel.

Over the long term the goal is to not break user space binaries.

I see a better chance of achieving the goal of not breaking user space
binaries if we remove interfaces that no known user space applications
use, in a way a well written application can handle, then to let
the user space interface code succumb to bit rot, and start returning
the wrong values to user space.

That is where we are at with sys_sysctl.
Almost all of the binary paths have no known users and the
implementations are succumbing to bit rot.  The binary interface and
the proc interface go through two completely separate paths so there
is little to ensure those paths don't diverge over time.

It is also true that the non-generic helper functions are diverging
over time.  Currently these things are not an issue because no one
actually uses the binary interfaces.  The empirical evidence seems
overwhelming on this point.

So just freezing us at our current set of non-broken binary sysctls
does not seem sufficient to ensure we don't break user space binaries.
Although it does seem to be a good start.

Eric
