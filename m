Return-Path: <linux-kernel-owner+w=401wt.eu-S1762567AbYBOUPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567AbYBOUPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbYBOUOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:14:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbYBOUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:14:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=U+5UVHiH3bTuhPmm5zaylh74HA7a8kSJblzGlRgprW4SfU4rZ8ymM7XK+g9JJ7LMy
	6izCUi4zAMc2IhIJeNSUg==
Date: Fri, 15 Feb 2008 12:14:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080215041957.afe41262.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802151208290.19332@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <1202862136.4974.41.camel@localhost>
 <20080212215242.0342fa25.pj@sgi.com> <alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com> <20080212221354.a33799f2.pj@sgi.com> <alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com> <20080213020344.45c9d924.pj@sgi.com>
 <alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com> <20080213110426.15179378.pj@sgi.com> <alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com> <20080213142956.5ba52101.pj@sgi.com> <20080214042643.dff40c72.pj@sgi.com>
 <alpine.DEB.1.00.0802141142160.17096@chino.kir.corp.google.com> <20080215041957.afe41262.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Paul Jackson wrote:

> So that last line should be:
> 
> > 	1,3,5			4-10		5,7,9
> 

What about this case where one of the relative nodes wraps around to 
represent an already set node in the result?

	relative	mems_allowed	result
	1,3,6		4-8		5,7 or 5-7 ?

Neither result is immediately obvious to me logically: either your result 
has less weight than your relative nodemask (seems like a bad thing) or 
your relative nodemask really isn't all that relative to begin with (it's 
the same result as 1-3, 6-8, 11-13, etc).

Or is this just a less-than-desired side-effect of relative nodemasks that 
we're willing to live with given its other advantages?

		David
