Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZJHQwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZJHQwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZJHQwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:52:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219AbZJHQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:52:35 -0400
Date: Thu, 8 Oct 2009 09:50:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
In-Reply-To: <1255019362.26976.311.camel@twins>
Message-ID: <alpine.LFD.2.01.0910080945230.3432@localhost.localdomain>
References: <1255016123.17055.17.camel@laptop>  <20091008155344.GA11727@elte.hu> <1255019362.26976.311.camel@twins>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, Peter Zijlstra wrote:
> 
> Right, so I did that full rename just so that people wouldn't get
> confused or something, but if both you and Linus think it should remain:
> kmap_atomic() and kunmap_atomic(), I can certainly undo that part.

I think the renaming probably helps find all the places (simple "grep -w" 
shows the difference, and no fear of confusion with comma-expressions and 
multi-line arguments etc). But once they've all been converted, you might 
as well then do a search-and-replace-back on the patch, and make the end 
result look like you just removed the (now pointless) argument.

In fact, I'd personally be inclined to split the patch into two patches:

 - one that just ignores the now redundant argument (but still keeps it), 
   and fixes the cases that didn't nest

 - one that then removes the argument.

Why? The _bugs_ are going to be shown by the first patch, and it would be 
nice to keep that patch small. When a bug shows up, it would be either 
because there's something wrong in that (much smaller) patch, or because 
some not-properly-nested casel wasn't fixed.

In contrast, the second patch would be large, but if done right, you could 
then prove that it has no actual semantic changes (ie "binary is same 
before and after"). That just sounds _much_ nicer from a debug standpoint. 
Developers would look at the small and concentrated "real changes" patch, 
rather than be distracted by all the trivial noise.

		Linus
