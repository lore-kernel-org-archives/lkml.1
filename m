Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbXDFLB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbXDFLB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 07:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766729AbXDFLB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 07:01:27 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46371 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbXDFLB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 07:01:26 -0400
Date: Fri, 6 Apr 2007 04:00:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com
Subject: Re: [PATCH 12/12] mm: per BDI congestion feedback
Message-Id: <20070406040035.2f1e1105.akpm@linux-foundation.org>
In-Reply-To: <1175842917.6483.130.camel@twins>
References: <20070405174209.498059336@programming.kicks-ass.net>
	<20070405174320.649550491@programming.kicks-ass.net>
	<20070405162425.eb78c701.akpm@linux-foundation.org>
	<1175842917.6483.130.camel@twins>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 09:01:57 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-04-05 at 16:24 -0700, Andrew Morton wrote:
> > On Thu, 05 Apr 2007 19:42:21 +0200
> > root@programming.kicks-ass.net wrote:
> > 
> > > Now that we have per BDI dirty throttling is makes sense to also have oer BDI
> > > congestion feedback; why wait on another device if the current one is not
> > > congested.
> > 
> > Similar comments apply.  congestion_wait() should be called
> > throttle_at_a_rate_proportional_to_the_speed_of_presently_uncongested_queues().
> > 
> > If a process is throttled in the page allocator waiting for pages to become
> > reclaimable, that process absolutely does not care whether those pages were
> > previously dirty against /dev/sda or against /dev/sdb.  It wants to be woken
> > up for writeout completion against any queue.
> 
> OK, so you disagree with Miklos' 2nd point here:
>   http://lkml.org/lkml/2007/4/4/137

Yup, silly man thought that "congestion_wait" has something to do with
congestion ;)  I think it sort-of used to, once.

Now it really means no more than "block until a batch of writes complete".
