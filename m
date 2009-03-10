Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZCJXCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZCJXCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZCJXC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:02:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbZCJXC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:02:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0903102105590.21727@blonde.anvils>
References: <Pine.LNX.4.64.0903102105590.21727@blonde.anvils> <20090310180740.29065.10735.stgit@warthog.procyon.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, jmalicki@metacarta.com, chrisw@sous-sol.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
Date: Tue, 10 Mar 2009 23:01:07 +0000
Message-ID: <6503.1236726067@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> Surely we'd prefer to avoid the overhead of additional confusing
> counts if they can be avoided?

As long as they are properly commented, it shouldn't be too confusing.

> We already have what I think is a satisfactory patch for the struct fs
> part of it:

We do?

> /proc can easily manage root and pwd while holding the lock
> instead of raising fs->count.

I'm assume you mean by extending the time we hold task->alloc_lock until we've
completed the path_get().

> I don't understand why check_unsafe_exec() needs to check
> current->files->count at all, since do_execve() has already
> done an unshare_files() to get its own copy - and proceeds with
> that one if the exec succeeds.
> 
> My belief is that the files->count check could/should have been
> removed when that unshare_files() was put in.  Please explain why
> I'm wrong on that - I can quite accept that I'm muddled about it,
> but please do explain it to me.

It seems you're right about that.  I think someone else on the security list
probably needs to answer that.

David
