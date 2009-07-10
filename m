Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZGJOIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZGJOIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZGJOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:08:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZGJOIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:08:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090710014857.GC4723@redhat.com>
References: <20090710014857.GC4723@redhat.com> <20090709212847.GA10238@redhat.com> <20090710013322.GA27719@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 2/2] current_is_single_threaded: don't use ->mmap_sem
Date: Fri, 10 Jul 2009 15:07:42 +0100
Message-ID: <25973.1247234862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> current_is_single_threaded() can safely miss a freshly forked CLONE_VM
> task, but in this case it must not miss its parent. That is why we take
> mm->mmap_sem for writing to make sure a thread/task with the same ->mm
> can't pass exit_mm() and disappear.
> 
> However we can avoid ->mmap_sem and rely on rcu/barriers:
> 
> 	- if we do not see the exiting parent on thread/process list
> 	  we see the result of list_del_rcu(), in this case we must
> 	  also see the result of list_add_rcu() which does wmb().
> 
> 	- if we do see the parent but its ->mm == NULL, we need rmb()
> 	  to make sure we can't miss the child.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
