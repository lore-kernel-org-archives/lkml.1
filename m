Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbXKNLwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbXKNLwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbXKNLwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:52:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58207
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbXKNLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:52:40 -0500
Date: Wed, 14 Nov 2007 03:52:36 -0800 (PST)
Message-Id: <20071114.035236.84619893.davem@davemloft.net>
To: paulus@samba.org
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <18234.57272.590960.860941@cargo.ozlabs.ibm.com>
References: <20071114110009.GA17833@infradead.org>
	<20071114.031216.11725447.davem@davemloft.net>
	<18234.57272.590960.860941@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Wed, 14 Nov 2007 22:44:56 +1100

> For instance, if you have something that kind-of looks like
> 
> 	read_pmds(int n, int *pmd_numbers, u64 *pmd_values);
> 
> where the caller supplies an array of PMD numbers and the function
> returns their values (and you want that reading to be done atomically
> in some sense), how would you do that using special files and fops?

The same way we handle some of the multicast "getsockopt()"
calls.  The parameters passed in are both inputs and outputs.

For the above example:

	struct pmd_info {
		int *pmd_numbers;
		u64 *pmd_values;
		int n;
	} *p;

	buffer_size = N;
	p = malloc(buffer_size);
	p->pmd_numbers = p + foo;
	p->pmd_values = p + bar;
	p->n = whatever(N);
	err = read(fd, p, N);

It's definitely doable, use your imagination.

You can encode all kinds of operation types into the
header as well.

Another alternative is to use generic netlink.
