Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYLSNct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYLSNct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYLSNcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:32:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYLSNci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:32:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1229690036.7789.113.camel@heimdal.trondhjem.org>
References: <1229690036.7789.113.camel@heimdal.trondhjem.org> <20081218123601.11810b7f.akpm@linux-foundation.org> <8930.1229560221@redhat.com> <20081218224418.804f10bc.sfr@canb.auug.org.au> <20081218142420.GA16728@infradead.org> <7633.1229653644@redhat.com> <20081218184443.d73f5431.akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
       steved@redhat.com, rwheeler@redhat.com, bfields@fieldses.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 13:32:24 +0000
Message-ID: <10970.1229693544@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> One interesting use case that I didn't see David mention is for cluster
> boot up. In a lot of the HPC clustered set-ups there tend be a number of
> 'hot' files that all clients need to access at roughly the same time in
> the boot cycle. Pre-loading these files into the persistent cache before
> booting the cluster is one way to solve this problem. Server replication
> and/or copying the files to local storage on the clients are other
> solutions.

I've come across something similar, where a large company was distributing /usr
to its UNIX/Linux workstations by AFS without persistent local caching.  Cue a
powercut, that took away the power from a large quantity of machines and then
brought it back again, at which point all the machines tried to boot...

> The disadvantage is that cachefs doesn't yet appear to have a tool to select
> those files that are hot and are therefore best suited to cache (please
> correct me if I'm wrong, David). The fact that a file is 'hot' on some given
> client is not necessarily equivalent to saying that it is hot on the server
> and vice versa. Are there any plans to at some point introduce a tool to
> manage the persistent cache?

Yes.  I have plans for tools to pin and unpin files, introduce culling
priorities, make space reservations in the cache, and cache readahead.

These aren't, however, immediately necessary to make local caching useful.

To do this, ideally I want a set of ioctl, fcntl or fadvise commands that are
common to all filesystems that will just be ignored if the filesystem isn't
currently doing caching.

Our customers also want to be able to configure this statically, perhaps in
some /etc file.  Something like, on NFS mount X from server Y, fully readahead
all files in or under directory Z.  I have an idea on how to do this, but I
need to thrash it out with Al.

David
