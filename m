Return-Path: <linux-kernel-owner+w=401wt.eu-S934415AbXFFBlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbXFFBlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXFFBlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:41:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24454 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbXFFBlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:41:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=opx/KQldcECiRLwCETBgcQwj7+ECe620Qp8pJNKVfCUOzwFlC2/kG3LoZFvfj/WMT
	zYKShu9CG0qry4sd8FKcg==
Date: Tue, 5 Jun 2007 18:40:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <Pine.LNX.4.64.0706051826310.6928@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706051837310.23799@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <20070605160149.348b5c4a.pj@sgi.com> <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051653330.6473@schroedinger.engr.sgi.com>
 <alpine.DEB.0.99.0706051817380.23799@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0706051826310.6928@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Christoph Lameter wrote:

> On Tue, 5 Jun 2007, David Rientjes wrote:
> 
> > Obviously GFP_KERNEL allocations can allocate regardless of our memory 
> > exclusivity, but the point is that a job in one exclusive cpuset should 
> > not have the ability to effect the performance (in terms of reclaim and 
> > swap), memory usage, or survival of jobs in other exclusive cpusets 
> > because it was out of memory.
> 
> Right but the process is terminating thus only requiring limited resources
> to get finished. The process does not have the ability to affect the other 
> cpusets. I.e. it cannot directly allocate outside of the cpuset. The 
> system has that capability and the system is handling the termination of 
> the process and should terminate the process in a clean way if possible.
> 

And those limited resources should be available in the difference between 
low and no watermarks as defined by each zone in the cpuset's 
mems_allowed.  Regardless, we should not allow allocations outside of the 
cpuset because we have marked it TIF_MEMDIE and we don't have any explicit 
guarantee that it is exiting yet and not mlock'ing an excessive amount of 
memory that exceeds the capacity of all cpuset nodes.

		David
