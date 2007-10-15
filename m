Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbXJOOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbXJOOGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXJOOGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:06:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXJOOGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:06:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1192451324.27435.71.camel@twins>
References: <1192451324.27435.71.camel@twins> <20071011213126.cf92efb7.akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: nfs mmap adventure (was: 2.6.23-mm1)
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 15 Oct 2007 15:06:12 +0100
Message-ID: <21859.1192457172@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> I get funny SIGBUS' like so:
> 
> fault
>   if (->page_mkwrite() < 0)
>     nfs_vm_page_mkwrite()
>       nfs_write_begin()
>         nfs_flush_incompatible()
>           nfs_wb_page()
>             nfs_wb_page_priority()
>               nfs_sync_mapping_wait()
>                 nfs_wait_on_request_locked()
>                   nfs_wait_on_request()
>                     nfs_wait_bit_interruptible()
>                       return -ERESTARTSYS
>     SIGBUS
> 
> trying to figure out what to do about this...
> 

Hmmm...  It sounds like the fault handler should deliver the appropriate
signal, should ->page_mkwrite() return ERESTARTSYS, and then retry the access
instruction that caused the fault when the signal handler has finished
running.

David

