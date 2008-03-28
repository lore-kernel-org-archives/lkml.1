Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYC1UAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYC1UAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYC1UAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:00:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbYC1UAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:00:21 -0400
Date: Fri, 28 Mar 2008 12:59:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, clameter@sgi.com, rjw@sisk.pl,
       pstaszewski@artcom.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       protasnb@gmail.com
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803281232450.14670@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803281247270.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com> <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org> <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com> <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
 <20080328114734.13607172.akpm@linux-foundation.org> <alpine.LFD.1.00.0803281232450.14670@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Linus Torvalds wrote:
> 
> It would be better if we actually passed in the gfp_flags, and then we 
> could test the __GFP_HIGH bit rather than the page address.  But for now, 
> the rule is that GFP_ATOMIC and __GFP_ZERO do not work together, because 
> this sanity test currently cannot work for that case.

Gaah. Sadly, we don't actually have any reasonably sane way of doing that. 

So I guess we'll have to lose the coverage of kmap_atomic() in other 
places, even though the only case where this was worth losing it for was 
that one clear_highpage() call site :/

		Linus
