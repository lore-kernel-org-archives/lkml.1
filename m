Return-Path: <linux-kernel-owner+w=401wt.eu-S1762722AbXJZBab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722AbXJZBab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXJZBaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:30:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXJZBaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:30:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ErXzABdm4By21DuqM7J5vWVpH632EjqAPkWODJTM9qWxhNaRdm1ChyPlV/ZEA6Fuf
	noUvPHwdSrYYiZ5djz3sg==
Date: Thu, 25 Oct 2007 18:30:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071025181337.b27cd309.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710251826020.8024@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <20071025181337.b27cd309.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Paul Jackson wrote:

>     Can we call this "memory_spread_user" instead, or something else
>     matching "memory_spread_*" ?
> 

Sounds better.  I was hoping somebody was going to come forward with an 
alternative that sounded better than interleave_over_allowed.

>     How about instead of your current_cpuset_interleaved_mems() routine
>     that returns a nodemask, rather have a routine that returns a Boolean,
>     indicating whether this new flag is set, used as in:
> 	if (cpuset_is_memory_spread_user())
> 		tmp = cpuset_current_mems_allowed();
> 	else
> 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
> 	pol->v.nodes = tmp;
> 

That sounds reasonable, it will simply be a wrapper around 
is_interleave_over_allowed() or what we're now calling is_spread_user().

>     The existing kernel code for mm/mempolicy.c:mpol_rebind_policy()
>     looks buggy to me.  The node_remap() call for the MPOL_INTERLEAVE
>     case seems like it should come before, not after, updating mpolmask
>     to the newmask.  Fixing that, and consolidating the multiple lines
>     doing "*mpolmask = *newmask" for each case, into a single such line
>     at the end of the switch(){} statement, results in the following
>     patch.  Could you confirm my suspicions and push this one too.
>     It should be a part of your patch set, so we don't waste Andrew's
>     time resolving the inevitable patch collisions we'll see otherwise.
> 

For setting current->il_next, both cases work but yours will be better 
balanced for the next interleaved allocation.  I'll apply it to my 
patchset.

Thanks for the review.

		David
