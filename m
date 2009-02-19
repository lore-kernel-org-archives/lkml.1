Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZBSO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZBSO2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZBSO2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:28:09 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40101 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189AbZBSO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:28:08 -0500
Date: Thu, 19 Feb 2009 09:19:57 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <2f11576a0902190549p2d3c90e2md16726cbe2f5d019@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902190915460.32273@qirst.com>
References: <20090218093858.8990.A69D9226@jp.fujitsu.com>  <1234944569.24030.20.camel@penberg-laptop>  <20090219085229.954A.A69D9226@jp.fujitsu.com>  <1235034967.29813.10.camel@penberg-laptop>  <2f11576a0902190451w294aa2fan29b61fa3619f459b@mail.gmail.com> 
 <1235049334.29813.18.camel@penberg-laptop> <2f11576a0902190549p2d3c90e2md16726cbe2f5d019@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What could be changed in the patch is to set SLUB_MAX_SIZE depending on
the page size of the underlying architecture.

#define SLUB_MAX_SIZE MAX(PAGE_SIZE, 8192)

So on 4k architectures SLUB_MAX_SIZE is set to 8192 and on 16k or 64k
arches its set to PAGE_SIZE.

And then define

#define SLUB_MAX_KMALLOC_ORDER get_order(SLUB_MAX_SIZE)

which will be 1 on 4k arches and 0 on higher sized arches.

Then also the kmalloc array would need to be dimensioned using
SLUB_MAX_KMALLOC_ORDER.


The definition of SLUB_NAX_KMALLOC_ORDER could be a bit challenging for
the C compiler.

