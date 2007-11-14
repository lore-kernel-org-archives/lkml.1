Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXKNMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXKNMER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXKNMEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:04:05 -0500
Received: from ozlabs.org ([203.10.76.45]:34843 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXKNMEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:04:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18234.58380.400222.329961@cargo.ozlabs.ibm.com>
Date: Wed, 14 Nov 2007 23:03:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114.035236.84619893.davem@davemloft.net>
References: <20071114110009.GA17833@infradead.org>
	<20071114.031216.11725447.davem@davemloft.net>
	<18234.57272.590960.860941@cargo.ozlabs.ibm.com>
	<20071114.035236.84619893.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> The same way we handle some of the multicast "getsockopt()"
> calls.  The parameters passed in are both inputs and outputs.

For a read??!!!

> For the above example:
> 
> 	struct pmd_info {
> 		int *pmd_numbers;
> 		u64 *pmd_values;
> 		int n;
> 	} *p;
> 
> 	buffer_size = N;
> 	p = malloc(buffer_size);
> 	p->pmd_numbers = p + foo;
> 	p->pmd_values = p + bar;
> 	p->n = whatever(N);
> 	err = read(fd, p, N);

You're suggesting that the behaviour of a read() should depend on what
was in the buffer before the read?  Gack!  Surely you have better
taste than that?

Or are you saying that a read (or write) has a side-effect of altering
some other area of memory besides the buffer you give to read()?  That
seems even worse to me.

> Another alternative is to use generic netlink.

Then you end up with two system calls to get the data rather than one
(one to send the request and another to read the reply).  For
something that needs to be quick that is a suboptimal interface.

Paul.
