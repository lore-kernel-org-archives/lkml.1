Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYC1Tie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYC1Tie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYC1Ti0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:38:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862AbYC1TiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:38:25 -0400
Date: Fri, 28 Mar 2008 12:37:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, clameter@sgi.com, rjw@sisk.pl,
       pstaszewski@artcom.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       protasnb@gmail.com
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <20080328114734.13607172.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803281232450.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com> <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com> <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org> <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com> <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
 <20080328114734.13607172.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Andrew Morton wrote:
>
> I was planning on plugging it this way:

.. and thereby losing the point of doing it the old way.

The old way caused more warnigns, but more importantly, it caused warnings 
on machines that didn't actually _have_ highmem pages. Which is actually 
the big majority of them.

That was the whole (and only) point of the debugging! If you only test the 
page address, you lose all the coverage!

It would be better if we actually passed in the gfp_flags, and then we 
could test the __GFP_HIGH bit rather than the page address.  But for now, 
the rule is that GFP_ATOMIC and __GFP_ZERO do not work together, because 
this sanity test currently cannot work for that case.

		Linus
