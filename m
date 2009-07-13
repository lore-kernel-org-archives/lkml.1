Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZGMX7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZGMX7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZGMX7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:59:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54331 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629AbZGMX7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:59:34 -0400
Date: Tue, 14 Jul 2009 01:56:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 2/2] current_is_single_threaded: don't use
	->mmap_sem
Message-ID: <20090713235612.GA4361@redhat.com>
References: <20090710014857.GC4723@redhat.com> <20090709212847.GA10238@redhat.com> <20090710013322.GA27719@infradead.org> <25973.1247234862@redhat.com> <alpine.LRH.2.00.0907130811380.29074@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0907130811380.29074@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13, James Morris wrote:
>
> On Fri, 10 Jul 2009, David Howells wrote:
>
> > > However we can avoid ->mmap_sem and rely on rcu/barriers:
> > >
> > > 	- if we do not see the exiting parent on thread/process list
> > > 	  we see the result of list_del_rcu(), in this case we must
> > > 	  also see the result of list_add_rcu() which does wmb().
> > >
> > > 	- if we do see the parent but its ->mm == NULL, we need rmb()
> > > 	  to make sure we can't miss the child.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > Acked-by: David Howells <dhowells@redhat.com>
>
> I gather this stuff is going into -mm ?

Yes, this is on top of rework-fix-is_single_threaded.patch

Given that David acked these changes, I guess they will go
to -mm soon.

> Can it be merged via security-testing#next?

Please do what you think right, I don't know what will be more
convenient to you and Andrew.

Oleg.

