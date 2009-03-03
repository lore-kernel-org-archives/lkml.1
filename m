Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZCCTGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZCCTGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZCCTGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:06:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZCCTGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:06:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=H2xxpJgsHtEn/RNp3MgnNvUScestaliMlAKBB8gR27e1YXx5nboSQXyd90h2KYvIV
	gepSppoNdH2rSUFbP30mA==
Date: Tue, 3 Mar 2009 11:05:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.1.10.0903031345150.9466@qirst.com>
Message-ID: <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com> <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com> <alpine.DEB.1.10.0903031136380.26454@qirst.com> <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903031345150.9466@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Christoph Lameter wrote:

> > There is no alternative solution to prevent egregious amounts of slab to
> > be allocated in a disjoint cpuset that is supposedly mem_exclusive.
> 
> The amount of memory is limited by the size of a slab page. If the process
> goes beyond that amount then the page allocator will come in and enforce
> the boundaries.
> 

Not until all of the partial slabs on the local node are full, which could 
be significant given s->min_partial.

This change doesn't affect the fastpath in any significant way for systems 
that have not configured multiple cpusets; systems that have configured 
more than one cpuset may have specific NUMA locality requirements that 
slub is dismissing without this patch.
