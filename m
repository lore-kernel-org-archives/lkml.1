Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbYL2PDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbYL2PDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYL2PDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:03:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYL2PDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:03:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081228200134.426bf203.akpm@linux-foundation.org>
References: <20081228200134.426bf203.akpm@linux-foundation.org> <8930.1229560221@redhat.com> <20081218142420.GA16728@infradead.org> <20081218123601.11810b7f.akpm@linux-foundation.org> <200812190007.34581.bernd.schubert@fastmail.fm> <20081218152616.a24c013f.akpm@linux-foundation.org> <20081219110539.7e7e230c.sfr@canb.auug.org.au> <20081229144533.4a0ab696.sfr@canb.auug.org.au> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Date: Mon, 29 Dec 2008 15:01:09 +0000
Message-ID: <12214.1230562869@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > What was the result of discussions around FS-Cache?
> 
> There was none.

I disagree with your assertion that there was no result.  Various people,
beside myself, have weighed in with situations where FS-Cache is or may be
useful.  You've been presented with benchmarks showing that it can make a
difference.

However, *you* are the antagonist, as strictly defined in the dictionary; we
were trying to convince *you*, so a result has to come from *you*.  I feel
that you are completely against it and that we've no hope of shifting you.

> Dan Muntz's question:
> 
>   Solaris has had CacheFS since ~1995, HPUX had a port of it since
>   ~1997.  I'd be interested in evidence of even a small fraction of
>   Solaris and/or HPUX shops using CacheFS.  I am aware of customers who
>   thought it sounded like a good idea, but ended up ditching it for
>   various reasons (e.g., CacheFS just adds overhead if you almost
>   always hit your local mem cache).
> 
> was an very very good one.

And to a large extent irrelevant.  Yes, we know caching adds overhead; I've
never tried to pretend otherwise.  It's an exercise in compromise.  You don't
just go and slap a cache on everything.  There *are* situations in which a
cache will help.  We have customers who know about them and are willing to
live with the overhead.

What I have done is to ensure that, even if caching is compiled in, then the
overhead is minimal if there is _no_ cache present.  That is requirement #1 on
my list.

Assuming I understand what he said correctly, I've avoided the main issue
listed by Dan because I don't do as Solaris does and interpolate the cache
between the user and NFS.  Of course, that probably buys me other issues (FS
design is an exercise in compromise too).

> Seems that instead of answering it, we've decided to investigate the
> fate of those who do not learn from history.

Sigh.

The main point is that caching _is_ useful, even with its drawbacks.  Dan may
be aware of customers of Sun/HP who thought caching sounds like a good idea,
but then ended up ditching it.  I can well believe it.  But I am also aware of
customers of Red Hat who are actively using the caching we put in RHEL-5 and
customers who really want caching available in future RHEL and Fedora versions
for various reasons.

To sum up:

 (1) Overhead is minimal if there is no cache.

 (2) Benchmarks show that the cache can be effective.

 (3) People are already using it and finding it useful.

 (4) There are people who want it for various projects.

 (5) The use of a cache does not automatically buy you an improvement in
     performance: it's a matter of compromise.

 (6) The performance improvement may be in the network or the servers, not the
     client that is actually doing the caching.

David
