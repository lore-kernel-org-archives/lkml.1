Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbYJaPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbYJaPpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:45:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430AbYJaPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:45:25 -0400
Date: Fri, 31 Oct 2008 08:44:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>  <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Oct 2008, Linus Torvalds wrote:
> 
> Jonathan, what do things look like with the simple "use 'expand_to_fit'" 
> patch instead, ie something like this:

And by "something like this", I obviously _really_ meant "something 
almost, but not entirely, unlike this".

> -			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
> +			insert_resource_expand_to_fit(&iomem_resource, res->start, res->end, res->name);

The "insert_resource_expand_to_fit()" calling convention is much simpler, 
and it should be just

	insert_resource_expand_to_fit(&iomem_resource, res);

which has the downside (?) that it will actually _modify_ the resource as 
it expands it to fit. Of course, it's not like we don't do that in other 
places too (ie the "sanitize" phase), so I don't think it's much of a real 
downside.

Anyway, I'm not appending a fixed patch, becuase the fix is so trivial as 
to be more easily done by hand.

		Linus
