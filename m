Return-Path: <linux-kernel-owner+w=401wt.eu-S1765121AbXJZUqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765121AbXJZUqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbXJZUqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:46:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbXJZUqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:46:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=n8xqb/B3RK+c0risdSZ8Ef7MhpJFiBmAd5CfLG90O07B0CkOj5Z2ZlEk43wK5hHI6
	AzsOjn+twWnHD3DAqLIhw==
Date: Fri, 26 Oct 2007 13:45:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071026120037.7b95a136.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> Without at least this sort of change to MPOL_INTERLEAVE nodemasks,
> allowing either empty nodemasks (Lee's proposal) or extending them
> outside the current cpuset (what I'm cooking up now), there is no way
> for a task that is currently confined to a single node cpuset to say
> anything about how it wants be interleaved in the event that it is
> subsequently moved to a larger cpuset.  Currently, such a task is only
> allowed to pass exactly one particular nodemask to set_mempolicy
> MPOL_INTERLEAVE calls, with exactly the one bit corresponding to its
> current node.  No useful information can be passed via an API that only
> allows a single legal value.
> 

Well, passing a single node to set_mempolicy() for MPOL_INTERLEAVE doesn't 
make a whole lot of sense in the first place.  I prefer your solution of 
allowing set_mempolicy(MPOL_INTERLEAVE, NODE_MASK_ALL) to mean "interleave 
me over everything I'm allowed to access."  NODE_MASK_ALL would be stored 
in the struct mempolicy and used later on mpol_rebind_policy().

		David
