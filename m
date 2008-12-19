Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbYLSND0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbYLSND0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYLSNDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:03:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57678 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbYLSNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:03:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081218184443.d73f5431.akpm@linux-foundation.org>
References: <20081218184443.d73f5431.akpm@linux-foundation.org> <20081218123601.11810b7f.akpm@linux-foundation.org> <8930.1229560221@redhat.com> <20081218224418.804f10bc.sfr@canb.auug.org.au> <20081218142420.GA16728@infradead.org> <7633.1229653644@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       sfr@canb.auug.org.au, trond.myklebust@fys.uio.no, steved@redhat.com,
       rwheeler@redhat.com, bfields@fieldses.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 13:03:00 +0000
Message-ID: <10890.1229691780@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > I don't know what will convince you.  I've given you theoretical reasons
> > why caching ought to be useful; I've backed up the ones I've implemented
> > with benchmarks; I've given you examples of what our customers are doing
> > with it or want to do with it.
> 
> Was that information captured/maintained somewhere?  It really is important (I
> think) for something of this magnitude.

What customers are doing with it, you mean?

That is slightly tricky, as it involves customers, most of whom don't want
their names to appear in public communications about their infrastructure.

However, I can give you some examples of how it is being used or being
considered for use:

 (1) We have a number of customers in the entertainment industry who use or
     would like to use this caching infrastructure in their render farms.  They
     use NFS to distribute textures (say a million and a quarter files) to the
     individual rendering units.  FS-Cache allows them to reduce the network
     load by satisfying subsequent NFS READ requests from each rendering unit's
     local cache rather than having to go to the network again.

 (2) We have another customer who is looking to roll out bunches of systems,
     where each bunch has an NFS file server and a few tens of processing units
     with their root filesystems NFS-mounted from the server.  They are willing
     to include storage per processing unit for swap and local caching (e.g.
     FS-Cache).  This deployment is on the order of ten thousand machines.

 (3) Similar to 3, people are looking at 'diskless' workstations that do
     actually have a disk, but only for swap and local caching.  All O/S files
     are read by NFS.

 (4) Yet others are using or looking at using FS-Cache to accelerate
     distributed web servers.

 (5) Although it's not someone using FS-Cache directly, I do have an anecdote
     from a customer using a very large quantity of AFS clients (it may have
     been OpenAFS), where /usr was distributed by AFS.  Before they had
     persistent local caches, the power went out in their building and came
     back on, and then all their machines in the process of booting spammed the
     AFS servers wanting their /usr again.

David
