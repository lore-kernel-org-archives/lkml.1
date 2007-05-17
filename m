Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbXEQV15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbXEQV15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXEQV1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:27:51 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:19767 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754961AbXEQV1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:27:50 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705171220120.3043@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com>
	 <1179385718.27354.17.camel@twins>
	 <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
	 <20070517175327.GX11115@waste.org>
	 <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
	 <1179429499.2925.26.camel@lappy>
	 <Pine.LNX.4.64.0705171220120.3043@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 23:26:49 +0200
Message-Id: <1179437209.2925.29.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 12:24 -0700, Christoph Lameter wrote:
> On Thu, 17 May 2007, Peter Zijlstra wrote:
> 
> > The proposed patch doesn't change how the kernel functions at this
> > point; it just enforces an existing rule better.
> 
> Well I'd say it controls the allocation failures. And that only works if 
> one can consider the system having a single zone.
> 
> Lets say the system has two cpusets A and B. A allocs from node 1 and B 
> allocs from node 2. Two processes one in A and one in B run on the same 
> processor.
> 
> Node 1 gets very low in memory so your patch kicks in and sets up the 
> global memory emergency situation with the reserve slab.
> 
> Now the process in B will either fail although it has plenty of memory on 
> node 2.
> 
> Or it may just clear the emergency slab and then the next critical alloc 
> of the process in A that is low on memory will fail.

The way I read the cpuset page allocator, it will only respect the
cpuset if there is memory aplenty. Otherwise it will grab whatever. So
still, it will only ever use ALLOC_NO_WATERMARKS if the whole system is
in distress.

