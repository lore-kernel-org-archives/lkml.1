Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbXHJBtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbXHJBtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbXHJBsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:48:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36961 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757658AbXHJBsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:48:52 -0400
Date: Thu, 9 Aug 2007 18:48:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <daniel.raymond.phillips@gmail.com>
cc: Daniel Phillips <phillips@phunq.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <4a5909270708091717n2f93fcb5i284d82edfd235145@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708091844450.3185@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>  <200708061559.41680.phillips@phunq.net>
  <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com> 
 <200708061649.56487.phillips@phunq.net>  <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
  <4a5909270708080037n32be2a73k5c28d33bb02f770b@mail.gmail.com> 
 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com> 
 <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com> 
 <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com>
 <4a5909270708091717n2f93fcb5i284d82edfd235145@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Daniel Phillips wrote:

> You can fix reclaim as much as you want and the basic deadlock will
> still not go away.  When you finally do get to writing something out,
> memory consumers in the writeout path are going to cause problems,
> which this patch set fixes.

We currently also do *not* write out immediately. I/O is queued when 
submitted so it does *not* reduce memory. It is better to actually delay 
writeout until you have thrown out clean pages. At that point the free 
memory is at its high point. If memory goes below the high point again by 
these writes then we can again reclaim until things are right.

> Agreed that the idea of mempool always sounded strange, and we show
> how to get rid of them, but that is not the immediate purpose of this
> patch set.

Ok mempools are unrelated. The allocations problems that this patch 
addresses can be fixed by making reclaim more intelligent. This may likely 
make mempools less of an issue in the kernel. If we can reclaim in an 
emergency even in ATOMIC contexts then things get much easier.

