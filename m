Return-Path: <linux-kernel-owner+w=401wt.eu-S933933AbXHFXAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbXHFXAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765001AbXHFW7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:59:51 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:56436
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764766AbXHFW7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:59:49 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Date: Mon, 6 Aug 2007 15:59:41 -0700
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <1186431992.7182.33.camel@twins> <Pine.LNX.4.64.0708061404300.3116@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708061404300.3116@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061559.41680.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 14:05, Christoph Lameter wrote:
> > > That is possible if one
> > > would make sure that the network layer triggers reclaim once in a
> > > while.
> >
> > This does not make sense, we cannot reclaim from reclaim.
>
> But we should limit the amounts of allocation we do while performing
> reclaim...

Correct.  That is what the throttling part of these patches is about.  
In order to fix the vm writeout deadlock problem properly, two things 
are necessary:

  1) Throttle the vm writeout path to use a bounded amount of memory

  2) Provide access to a sufficiently large amount of reserve memory for 
each memory user in the vm writeout path

You can understand every detail of this patch set and the following ones 
coming from Peter in terms of those two requirements.

> F.e. refilling memory pools during reclaim should be disabled.

Actually, recursing into the vm should be disabled entirely but that is 
a rather deeply ingrained part of mm culture we do not propose to 
fiddle with just now.

Memory pools are refilled when the pool user frees some memory, not ever 
by the mm.

Regards,

Daniel
