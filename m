Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbXHFXPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbXHFXPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXHFXPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:15:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932284AbXHFXPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:15:03 -0400
Date: Mon, 6 Aug 2007 16:14:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Daniel Phillips <phillips@phunq.net>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <200708061559.41680.phillips@phunq.net>
Message-ID: <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <1186431992.7182.33.camel@twins>
 <Pine.LNX.4.64.0708061404300.3116@schroedinger.engr.sgi.com>
 <200708061559.41680.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Daniel Phillips wrote:

> Correct.  That is what the throttling part of these patches is about.  

Where are those patches?

> In order to fix the vm writeout deadlock problem properly, two things 
> are necessary:
> 
>   1) Throttle the vm writeout path to use a bounded amount of memory
> 
>   2) Provide access to a sufficiently large amount of reserve memory for 
> each memory user in the vm writeout path
> 
> You can understand every detail of this patch set and the following ones 
> coming from Peter in terms of those two requirements.

AFAICT: This patchset is not throttling processes but failing allocations. 
The patchset does not reconfigure the memory reserves as expected. Instead 
new reserve logic is added. And I suspect that we have the same issues as 
in earlier releases with various corner cases not being covered. Code is 
added that is supposedly not used. If it ever is on a large config then we 
are in very deep trouble by the new code paths themselves that serialize 
things in order to give some allocations precendence over the other 
allocations that are made to fail ....





