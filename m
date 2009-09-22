Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZIVIN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZIVIN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZIVIN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:13:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:60159 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZIVINZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:13:25 -0400
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <alpine.DEB.1.00.0909220023070.9061@chino.kir.corp.google.com>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
	 <1253577603.7103.174.camel@pasglop>
	 <alpine.DEB.1.00.0909211704180.4798@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0909220227050.3719@V090114053VZO-1>
	 <alpine.DEB.1.00.0909220023070.9061@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:11:17 +1000
Message-Id: <1253607077.7103.219.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 00:59 -0700, David Rientjes wrote:
> The equivalent of proximity domains then describes the distance between 
> all localities; these distances need not be one-way, it is possible for 
> distance in one direction to be different from the opposite direction, 
> just as ACPI pxm's allow.
> 
> A "node" in this plan is simply a system locality consisting of memory.
> 
> For subsystems such as slab allocators, all we require is cpu_to_node() 
> tables which would map cpu localities to nodes and describe them in terms 
> of local or remote distance (or whatever the SLIT says, if provided).  All 
> present day information can still be represented in this model, we've just 
> added additional layers of abstraction internally.

While I like the idea of NUMA nodes being strictly memory and everything
else being expressed by distances, we'll have to clean up quite a few
corners with skeletons in various states of decompositions waiting for
us there.

For example, we have code here or there that (ab)uses the NUMA node
information to link devices with their iommu, that sort of thing. IE, a
hard dependency which isn't really related to a concept of distance to
any memory.

At least on powerpc, nowadays, I can pretty much make everything
fallback to some representation in the device-tree though, thus it
shouldn't be -that- hard to fix I suppose.

Cheers,
Ben.

