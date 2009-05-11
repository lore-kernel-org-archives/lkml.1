Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbZEKTiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbZEKTiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEKTiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:38:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32158 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbZEKTiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:38:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Yrh8dC7x5aSq7+/Nri4SEPQOSO1NG7jtQrrwg2S96bYA8eH64zyACXB3mje8OFaLQ
	e7HBm3DYjvfjyW2Nh12+g==
Date: Mon, 11 May 2009 12:37:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511104029.GB19847@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0905111234460.23739@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com> <20090511104029.GB19847@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Mel Gorman wrote:

> Can this get a comment explaining the intention like the code you are
> removing had? Something like this?
> 
> /*
>  * The OOM killer only triggers for lower order allocation
>  * requests and when __GFP_NOFAIL is specified to prevent
>  * endlessly looping. Only retry the allocation if the OOM
>  * killer was used.
>  */
> 
> Otherwise, it looks ok.
> 

Sure, I'll add a comment to patch 11 in my latest series that changes the 
code again in this area.

> One related question, what is doing a costly-high-order allocation request
> with __GFP_NOFAIL specified?
> 

Nothing to my knowledge, this is simply a bug fix before the big change in 
my series where we fail page allocations if reclaim fails and the oom 
killer fails, which previously hasn't been done (we'd loop forever oom 
killing tasks that may or may not respond).  The definition of 
__GFP_NOFAIL does not make the guarantee of infinitely retrying for only 
specific ranges of orders.
