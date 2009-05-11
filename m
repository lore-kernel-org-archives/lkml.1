Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZEKQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZEKQDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZEKQDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:03:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47336 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbZEKQDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:03:21 -0400
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       San Mehat <san@android.com>, Arve Hjonnevag <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0905110143190.24726@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
	 <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0905110143190.24726@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 09:03:13 -0700
Message-Id: <1242057793.8109.34342.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 01:45 -0700, David Rientjes wrote:
> On Mon, 11 May 2009, KOSAKI Motohiro wrote:
> include/linux/gfp.h states this:
> 
>  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
>  * cannot handle allocation failures.
> 
> That is the only desciption given to users of __GFP_NOFAIL, so they should 
> be able to trust it.  The fact is that in mmotm it's possible for such an 
> allocation to fail without even attempting to free some memory via the oom 
> killer (and I disagree that killing a large memory hogging task will not 
> allow large allocations such as those greater than PAGE_ALLOC_COSTLY_ORDER 
> to succeed, which is a question of fragmentation and not purely VM size).

I assume that you've actually seen this behavior where OOM-killing a
task will free enough memory to allow a higher-order allocation to
succeed.

Could you explain a little more about why you think this scenario works
for you?  Are large contiguous areas of memory pinned by the task
getting which you want to get killed?  Why wasn't swapping effective
against this task?  Was the task itself taking up a large portion of
total memory?

-- Dave

