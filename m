Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXH1Qet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXH1Qet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbXH1Qem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:34:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbXH1Qel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:34:41 -0400
Date: Tue, 28 Aug 2007 09:34:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <200708280823.53663.a1426z@gawab.com>
Message-ID: <alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org>
References: <200708111344.42934.a1426z@gawab.com> <200708280737.53439.a1426z@gawab.com>
 <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
 <200708280823.53663.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Aug 2007, Al Boldi wrote:
> 
> I like your analysis, but how do you explain that these stalls vanish when 
> __update_curr is disabled?

It's entirely possible that what happens is that the X scheduling is just 
a slightly unstable system - which effectively would turn a small 
scheduling difference into a *huge* visible difference.

And the "small scheduling difference" might be as simple as "if the 
process slept for a while, we give it a bit more CPU time". And then you 
get into some unbalanced setup where the X scheduler makes it sleep even 
more, because it fills its buffers.

Or something. I can easily see two schedulers that are trying to 
*individually* be "fair", fighting it out in a way where the end result is 
not very good.

I do suspect it's probably a very interesting load, so I hope Ingo looks 
more at it, but I also suspect it's more than just the kernel scheduler.

		Linus
