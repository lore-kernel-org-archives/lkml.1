Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbZGLWMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbZGLWMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZGLWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:12:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:32966 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZGLWMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:12:45 -0400
Date: Mon, 13 Jul 2009 08:12:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 2/2] current_is_single_threaded: don't use
 ->mmap_sem
In-Reply-To: <25973.1247234862@redhat.com>
Message-ID: <alpine.LRH.2.00.0907130811380.29074@tundra.namei.org>
References: <20090710014857.GC4723@redhat.com> <20090709212847.GA10238@redhat.com> <20090710013322.GA27719@infradead.org> <25973.1247234862@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, David Howells wrote:

> > However we can avoid ->mmap_sem and rely on rcu/barriers:
> > 
> > 	- if we do not see the exiting parent on thread/process list
> > 	  we see the result of list_del_rcu(), in this case we must
> > 	  also see the result of list_add_rcu() which does wmb().
> > 
> > 	- if we do see the parent but its ->mm == NULL, we need rmb()
> > 	  to make sure we can't miss the child.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

I gather this stuff is going into -mm ?

Can it be merged via security-testing#next?

-- 
James Morris
<jmorris@namei.org>
