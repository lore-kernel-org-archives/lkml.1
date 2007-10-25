Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbXJYXdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbXJYXdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXJYXc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:32:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757365AbXJYXc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:32:58 -0400
Date: Thu, 25 Oct 2007 16:32:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <200710260116.10904.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0710251628440.30120@woody.linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260109.50092.ak@novell.com>
 <alpine.LFD.0.999.0710251613090.30120@woody.linux-foundation.org>
 <200710260116.10904.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Andi Kleen wrote:
> 
> No it can't (at least not on x86) as I have explained in the rest of the mail 
> you conveniently snipped.

I "conveniently snipped it" because it was pointless.

"adc" or "cmov" has nothing what-so-ever to do with it. If some routine 
returns 0-vs-1 and gcc then turns "if (routine()) x++" into 
"x+=routine()", what does that have to do with adc or cmov?

The fact is, these kinds of optimizations are *bogus* and they are 
dangerous.

Now, it's equally true that we probably don't have those kinds of patterns 
in the kernel, and we'll probabaly not hit it, but wouldn't it be much 
better to make sure that compilers shouldn't do that?

			Linus
