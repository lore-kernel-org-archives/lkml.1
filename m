Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYG3Wju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYG3Wju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYG3Wjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:39:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbYG3Wjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:39:42 -0400
Date: Wed, 30 Jul 2008 15:35:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <84144f020807301522r7fb97bfehe0fcdceef10477b9@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807301529190.3277@nehalem.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>  <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>  <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>  <1199919548.6245.74.camel@cinder.waste.org>
  <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>  <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>  <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>  <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI> 
 <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org> <84144f020807301522r7fb97bfehe0fcdceef10477b9@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Pekka Enberg wrote:
> 
> Oh, I didn't suggest this for merging. Just thought you'd be
> interested to know that best-fit doesn't really do that much better
> than what we have in the tree now. (Well, I was kinda hoping you'd
> tell me why my implementation is wrong and you were right all along.)

Heh. Most allocators tend to work pretty well under normal load, and the 
real fragmentation problems all tend to happen under special patterns. The 
one in glibc, for example, sucks donkey dick when using threading, but is 
apparently ok otherwise. 

I wouldn't actually expect most "normal" kernel use to show any really bad 
patterns on any normal loads. Google for

	worst-case first-fit fragmentation

(or 'next-fit' for that matter) to see some stuff. Of course, it is scary 
only if you can trigger it in practice (perhaps with certains games on 
packet size, or creating/removing files with pathname size patterns ec).

[ Of course, google probably mostly returns hits from all those ACM 
  portals etc. I wonder why google does that - they're almost totally 
  useless search results. Sad. If somebody knows how to turn those ACM 
  pay-portals off in google, pls let me know ]

			Linus
