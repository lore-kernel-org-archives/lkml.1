Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZEaDTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZEaDTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 23:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZEaDTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 23:19:12 -0400
Received: from ozlabs.org ([203.10.76.45]:38176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZEaDTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 23:19:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
Date: Sun, 31 May 2009 12:49:07 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
References: <20090527180635.008102701@gentwo.org> <200905291057.16286.rusty@rustcorp.com.au> <alpine.DEB.1.10.0905291023570.30695@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0905291023570.30695@gentwo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905311249.08107.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 01:07:48 am Christoph Lameter wrote:
> On Fri, 29 May 2009, Rusty Russell wrote:
> > > Have not seen it but it would be a bit confusing since
> > > we already have get_cpu* which must be paired with put_cpu*
> > > because of the refcount taking (get_cpu_var and get_cpu).
> > > get_cpu_ptr() would not have to be paired.
> >
> > To clarify, get_cpu_ptr() would be paired with put_cpu_ptr(). 
> > __get_cpu_ptr() would be the "raw" one:
> >
> > #define get_cpu_ptr(xx) per_cpu_ptr(xx, get_cpu())
> > #define __get_cpu_ptr(xx) per_cpu_ptr(xx, smp_processor_id())
>
> Hmmm.. That would be a major change in semantics.

It's exactly like get_cpu_var.  For better or worse, let's not invent YA new 
convention.

> How would that look for atomic per cpu ops?
>
> 	get_cpu_ptr_inc(per_cpu_ptr1);
> 	__get_cpu_ptr_inc(per_cpu_ptr2)
> 	put_cpu_ptr()
>
> vs.
>
> 	this_cpu_inc(per_cpu_ptr1)
> 	this_cpu_inc(per_cpu_ptr2)

Well, get_* doesn't really make sense for any function which doesn't return a 
value.  

So that name question doesn't really have a clear convention answer: we could 
re-use cpu_local_inc() since I think we decided to kill local_t.  I slightly 
prefer it over "this_cpu_*" since we're not actually doing anything to the cpu 
itself, but I don't think anyone will get too confused and think that after 
this executes their CPU will be stepping 11. :)

Thanks,
Rusty.
