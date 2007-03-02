Return-Path: <linux-kernel-owner+w=401wt.eu-S1422916AbXCBFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916AbXCBFku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422917AbXCBFkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:40:49 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46776 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422916AbXCBFkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:40:49 -0500
Date: Thu, 1 Mar 2007 21:40:45 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
In-Reply-To: <20070302050625.GD15867@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0703012137580.1768@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703011854540.5530@schroedinger.engr.sgi.com>
 <20070302035751.GA15867@wotan.suse.de> <Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com>
 <20070302042149.GB15867@wotan.suse.de> <Pine.LNX.4.64.0703012022320.14299@schroedinger.engr.sgi.com>
 <20070302050625.GD15867@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Nick Piggin wrote:

> So what do you mean by efficient? I guess you aren't talking about CPU
> efficiency, because even if you make the IO subsystem submit larger
> physical IOs, you still have to deal with 256 billion TLB entries, the
> pagecache has to deal with 256 billion struct pages, so does the
> filesystem code to build the bios.

You do not have to deal with TLB entries if you do buffered I/O.

For mmapped I/O you would want to transparently use 2M TLBs if the 
page size is large.

> So you are having problems with your IO controller's handling of sg
> lists?

We currently have problems with the kernel limits of 128 SG 
entries but the fundamental issue is that we can only do 2 Meg of I/O in 
one go given the default limits of the block layer. Typically the number 
of hardware SG entrie is also limited. We never will be able to put a 



