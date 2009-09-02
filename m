Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZIBIwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZIBIwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbZIBIwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:52:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:53548 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZIBIwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:52:00 -0400
Subject: Re: [PATCH] Fix fake numa on ppc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Rientjes <rientjes@google.com>
Cc: Ankita Garg <ankita@in.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0909012259050.26930@chino.kir.corp.google.com>
References: <20090901050316.GA4076@in.ibm.com>
	 <20090901055753.GB5563@balbir.in.ibm.com>
	 <20090901092407.GC4076@in.ibm.com>
	 <20090901142729.GA5022@balbir.in.ibm.com>
	 <20090902053653.GA3806@in.ibm.com> <1251870823.14675.420.camel@pasglop>
	 <alpine.DEB.1.00.0909012259050.26930@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 18:51:39 +1000
Message-Id: <1251881499.14675.453.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 23:03 -0700, David Rientjes wrote:
> On Wed, 2 Sep 2009, Benjamin Herrenschmidt wrote:
> 
> > Since I'm pretty sure there could be CPU less nodes just like there
> > could be memory-less nodes, it would be good if fake numa could
> > simulate them too :-)
> > 
> 
> You don't want to simulate cpu less nodes since they do have affinity to 
> ranges of memory, you want to map each fake node to a cpumask including 
> all cpus with affinity to its memory, map each cpu to one fake node (with 
> memory) that it has physical affinity to, and then give all fake nodes 
> local NUMA distance to those on the same physical node.  Memoryless nodes 
> take care of themselves since they rely purely on node_distance(), so the 
> index into the slit for all fake nodes to those without memory will be the 
> same.

Ok, makes sense, thanks.

Cheers,
Ben.


