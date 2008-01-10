Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYAJTvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYAJTvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYAJTux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:50:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38756 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYAJTuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:50:52 -0500
Date: Thu, 10 Jan 2008 20:53:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Message-ID: <20080110195329.GB2120@one.firstfloor.org>
References: <1199906151.6245.57.camel@cinder.waste.org> <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <1199987366.5331.92.camel@cinder.waste.org> <alpine.LFD.1.00.0801101013310.3148@woody.linux-foundation.org> <1199990565.5331.130.camel@cinder.waste.org> <alpine.LFD.1.00.0801101124140.3148@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801101124140.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - huge pages (superpages for those crazy db people)
> 
>    Just a simple linked list of these things is fine, we'd never care 
>    about coalescing large pages together anyway.

I did essentially that for my GBpages hugetlbfs patchkit. GB pages are already
beyond MAX_ORDER and increasing MAX_ORDER didn't seem attractive because
it would require aligning the zones all to 1GB which would quite nasty.

So it just grabbed them out of bootmem early and managed them in a 
per node list.

Not sure it's a good idea for 2MB pages though.

-Andi
