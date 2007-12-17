Return-Path: <linux-kernel-owner+w=401wt.eu-S1764369AbXLQWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764369AbXLQWz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbXLQWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:55:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbXLQWzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:55:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200712141521.24227.nickpiggin@yahoo.com.au>
References: <200712141521.24227.nickpiggin@yahoo.com.au> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205194020.24617.28880.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 24/28] AFS: Add a function to excise a rejected write from the pagecache [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 17 Dec 2007 22:54:31 +0000
Message-ID: <731.1197932071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> This reintroduces the fault vs truncate race window, which must be fixed.

Hmmm...  perhaps.  I remember that cropped up in NFS, but I'm doing things a
bit differently to NFS.  Remind me again how that worked please.

> Also, it is adding a fair bit of complexity in an area where we should
> instead be reducing it. I think your filesystem should not be doing
> writeback caching of dirty data in the cases where it is so problematic
> (or at least, disallow mmap and read on the dirty data until it has been
> written back or failed).

Eh?  It's a stateless network filesystem.  There's a gap between writing to a
file (perhaps though an mmap) and the pagecache pages being written back in
which someone may change the security on a file and block the writeback.
There's nothing I can do to prevent it, so I have to instead deal with the
consequences should they arise.  See the description of patch 25 for examples.

So you say I shouldn't do any writeback caching at all?

> But otherwise I guess if you really want to discard the dirty data after
> a failed writeback attempt, what's wrong with just invalidate_inode_pages2?

Erm...  Because it deadlocks?

David
