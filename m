Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXEQRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXEQRy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbXEQRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:54:50 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:40498 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756646AbXEQRyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:54:49 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705171029500.17245@schroedinger.engr.sgi.com>
References: <1179350433.2912.66.camel@lappy>
	 <Pine.LNX.4.64.0705161435110.11642@schroedinger.engr.sgi.com>
	 <1179386921.27354.29.camel@twins>
	 <Pine.LNX.4.64.0705171029500.17245@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 19:53:50 +0200
Message-Id: <1179424430.2925.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 10:30 -0700, Christoph Lameter wrote:
> On Thu, 17 May 2007, Peter Zijlstra wrote:
> 
> > > 2. It seems to be based on global ordering of allocations which is
> > >    not possible given large systems and the relativistic constraints
> > >    of physics. Ordering of events get more expensive the bigger the
> > >    system is.
> > > 
> > >    How does this system work if you can just order events within
> > >    a processor? Or within a node? Within a zone?
> > 
> > /me fails again..
> > 
> > Its about ensuring ALLOC_NO_WATERMARKS memory only reaches PF_MEMALLOC
> > processes, not joe random's pi calculator.
> 
> Watermarks are per zone?

Yes, but the page allocator might address multiple zones in order to
obtain a page.

