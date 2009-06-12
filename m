Return-Path: <linux-kernel-owner+w=401wt.eu-S1764626AbZFLOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764626AbZFLOES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZFLOD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:03:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:57073 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZFLOD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:03:58 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, akpm@linux-foundation.org,
       npiggin@suse.de
In-Reply-To: <1244814852.30512.67.camel@penberg-laptop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <1244796045.7172.82.camel@pasglop>
	 <1244796211.30512.32.camel@penberg-laptop>
	 <1244796837.7172.95.camel@pasglop>
	 <1244797659.30512.37.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906120944540.15809@gentwo.org>
	 <1244814852.30512.67.camel@penberg-laptop>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:02:50 +1000
Message-Id: <1244815370.7172.169.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 16:54 +0300, Pekka Enberg wrote:
> Hi Christoph,
> 
> On Fri, 2009-06-12 at 09:49 -0400, Christoph Lameter wrote:
> > Best thing to do is to recognize the fact that we are still in early boot
> > in the allocators. Derived allocators (such as slab and vmalloc) mask bits
> > using GFP_RECLAIM_MASK and when doing allocations through the page
> > allocator. You could make GFP_RECLAIM_MASK a variable. During boot
> > __GFP_WAIT would not be set in GFP_RECLAIM_MASK.
> 
> Ben's patch does something like that and I have patches that do that
> floating around too.
> 
> The problem here is that it's not enough that we make GFP_RECLAIM_MASK a
> variable. There are various _debugging checks_ that happen much earlier
> than that. We need to mask out those too which adds overhead to
> kmalloc() fastpath, for example.

Hrm... I though I stuck my masking before the lockdep tests but maybe I
missed some...

Again, I'm not saying my patch is the best way to solve it. My point is
more that the callers shouldn't have to bother. (And thus the WARN_ON
isn't right :-)

Cheers,
Ben.


