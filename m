Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbXHISu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbXHISu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbXHISuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:50:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33926 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753171AbXHISt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:49:59 -0400
Date: Thu, 9 Aug 2007 11:49:56 -0700 (PDT)
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
In-Reply-To: <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>  <200708061559.41680.phillips@phunq.net>
  <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com> 
 <200708061649.56487.phillips@phunq.net>  <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
  <4a5909270708080037n32be2a73k5c28d33bb02f770b@mail.gmail.com> 
 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com>
 <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Daniel Phillips wrote:

> On 8/8/07, Christoph Lameter <clameter@sgi.com> wrote:
> > On Wed, 8 Aug 2007, Daniel Phillips wrote:
> > Maybe we need to kill PF_MEMALLOC....
> 
> Shrink_caches needs to be able to recurse into filesystems at least,
> and for the duration of the recursion the filesystem must have
> privileged access to reserves.  Consider the difficulty of handling
> that with anything other than a process flag.

Shrink_caches needs to allocate memory? Hmmm... Maybe we can only limit 
the PF_MEMALLOC use.

> In theory, we could reduce the size of the global memalloc pool by
> including "easily freeable" memory in it.  This is just an
> optimization and does not belong in this patch set, which fixes a
> system integrity issue.

I think the main thing would be to fix reclaim to not do stupid things 
like triggering writeout early in the reclaim pass and to allow reentry 
into reclaim. The idea of memory pools always sounded strange to me given 
that you have a lot of memory in a zone that is reclaimable as needed.

