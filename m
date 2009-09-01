Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZIANgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZIANgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZIANgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZIANgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:36:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <84144f020908310308i48790f78g5a7d73a60ea854f8@mail.gmail.com>
References: <84144f020908310308i48790f78g5a7d73a60ea854f8@mail.gmail.com> <20090831074842.GA28091@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: dhowells@redhat.com, Paul Mundt <lethal@linux-sh.org>,
       Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: page allocator regression on nommu
Date: Tue, 01 Sep 2009 14:35:47 +0100
Message-ID: <6126.1251812147@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> This looks to be a bug in nommu do_mmap_pgoff() error handling. I
> guess we shouldn't call __put_nommu_region() if add_nommu_region()
> hasn't been called?

We should to make sure the region gets cleaned up properly.  However, it will
go wrong if do_mmap_shared_file() or do_mmap_private() fail.  We should
perhaps call add_nommu_region() before doing the "set up the mapping" chunk -
we hold the region semaphore, so it shouldn't hurt anyone if we then have to
remove it again.

David
