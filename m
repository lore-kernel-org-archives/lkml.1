Return-Path: <linux-kernel-owner+w=401wt.eu-S1760354AbYBKVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbYBKVyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYBKVyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:54:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbYBKVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:54:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=tljO0zguIuzO1Mqr0is/74nPpKuiN70nycKjCJWTNcAAc0GtrN9m12gZ6W3a93EBD
	VRBDJ4DY/3HPT0LNeyajQ==
Date: Mon, 11 Feb 2008 13:52:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       clameter@sgi.com, ak@suse.de, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
In-Reply-To: <20080211145543.8821960c.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802111345170.3908@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <1202747811.5014.37.camel@localhost> <20080211145543.8821960c.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Paul Jackson wrote:

> If things go as I hope, I expect to spend a couple of days this week
> reviving my earlier patch RFC that a couple of you on this cc list saw,
> concerning how nodes are numbered in mempolicy nodemasks.  Certainly
> the work being done in these various recent patches will affect my
> patch ... it's in the same code.
> 

With my patchset I don't believe there is any ambiguity in how nodes are 
numbered anymore.

The node remap is suppressed on policy rebind if MPOL_F_STATIC_NODES is 
passed by the user either on mbind() or set_mempolicy()[*].  So in that 
case, the user is always referring to absolte physical node numbers; 
without the flag, the user is referring to relative node numbers since it 
can be remapped when the mempolicy context changes.

 [*] Or with tmpfs by appending '=static' to the policy mode at mount
     time.

> David or Lee -- could you recommend to me which of these various patches
> of late I should apply first in my workarea, in what order, before I
> add my patch?

That's a good question; when I prepared this patchset I simply based it 
off Linus' latest git + V3 of Lee's contextualize_policy() patch that was 
posted to LKML on February 8:

	http://marc.info/?l=linux-kernel&m=120250000001182

Lee has talked about another patchset that he hasn't posted (at least not 
lately) based on Mel's two zonelist work.  I'm not sure of that status of 
that right now and since Lee is idle this week I would recommend applying 
V3 of his patch plus my five (there was a fifth patch posted in response 
to KOSAKI Motohiro's findings of a mpol_new() memory leak:

	http://marc.info/?l=linux-kernel&m=120276002725325

> After fixing up conflicts between my earlier patch and
> these good patches of yours, I'll try to do some testing of the code
> paths that my patch most likely affected, to ensure that I don't break
> any existing code.  I'll also probably have some more detailed review
> comments on these patches, as I work through them and resolve conflicts
> between them and my patch.
> 

Sounds good.

		David
