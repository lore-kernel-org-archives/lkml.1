Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYE3FD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYE3FD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYE3FDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:03:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59754 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751030AbYE3FDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:03:16 -0400
Date: Thu, 29 May 2008 22:03:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
In-Reply-To: <20080529215827.b659d032.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> All seems reasonable to me.  The obvious question is "how do we size
> the arena".  We either waste memory or, much worse, run out.

The per cpu memory use by subsystems is typically quite small. We already 
have an 8k limitation for percpu space for modules. And that does not seem 
to be a problem.

> And running out is a real possibility, I think.  Most people will only
> mount a handful of XFS filesystems.  But some customer will come along
> who wants to mount 5,000, and distributors will need to cater for that,
> but how can they?

Typically these are fairly small 8 bytes * 5000 is only 20k.

> I wonder if we can arrange for the default to be overridden via a
> kernel boot option?

We could do that yes.
 
> Another obvious question is "how much of a problem will we have with
> internal fragmentation"?  This might be a drop-dead showstopper.

But then per cpu data is not frequently allocated and freed.

Going away from allocpercpu saves a lot of memory. We could make this 
128k or so to be safe?


