Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbXJYX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbXJYX5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759004AbXJYX5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:57:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758449AbXJYX5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:57:39 -0400
Date: Thu, 25 Oct 2007 16:57:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <200710260142.37902.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0710251651550.30120@woody.linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260116.10904.ak@suse.de>
 <alpine.LFD.0.999.0710251628440.30120@woody.linux-foundation.org>
 <200710260142.37902.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Andi Kleen wrote:
> 
> The conditional add/sub using carry trick is not generally bogus. 
> But for registers it's a fine optimization.

For registers it's fine. For memory, it's a disaster. It's more than just 
dirty cachelines and introducing race conditions, it's also about 
protection and dirty pages.

So even in user space, to even be correct in the first place, the compiler 
would need to make sure that the variable is writable at all (or you might 
take a SIGSEGV), but I guess that gcc just assumes it is, at least for 
globals (or gcc could depend on seeing *other* writes that are done 
unconditionally).

More likely, the compiler people don't even care, because "the C standard 
doesn't specify that behaviour" - ie things like write-protected memory or 
garbage collection based on dirty/accessed bits are outside the scope of 
what the language specifies. Much less things like pthreads or other 
synchronization primitives in threads.

			Linus
