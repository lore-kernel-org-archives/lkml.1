Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYK3LHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYK3LHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 06:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYK3LG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 06:06:56 -0500
Received: from fifo99.com ([67.223.236.141]:44068 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbYK3LG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 06:06:56 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Nov 2008 06:06:55 EST
Subject: Re: [PATCH 0/4] trace: profiling branches
From: Daniel Walker <dwalker@fifo99.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Hua Zhong <hzhong@gmail.com>
In-Reply-To: <20081121071213.365288293@goodmis.org>
References: <20081121071213.365288293@goodmis.org>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 02:58:56 -0800
Message-Id: <1228042736.6868.19.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 02:12 -0500, Steven Rostedt wrote:
> Ingo,
> 
> The following patches clean up the unlikely/likely tracer. Namely
> it consolidates it into a single file called "profile_annotated_branch".
> 
> It also adds a new profiler. A true branch profiler that profiles all
> if() statements where the conditional is not a constant. It puts 
> a bit of overhead on the system, but the results seem pretty interesting.
> The results are placed in "profile_branch".
> 

I looked at the full version of this, and it looks really slow.. As I
recall the biggest problem with the -mm version was it's cacheline
bouncing (pointed out by Ingo), and yours doesn't _seem_ to fix that. In
fact your version looks a lot worse..

So really between the two if we want mainline likely profiling the -mm
version is a better choice.. The reason that version never went into
mainline is cause neither me or Andrew felt strongly that this was
useful in more than just -mm ..

If you look at the output from the profiling long enough it becomes
clear that it's frequently misleading .. In the short term a certain
branch might be likely, and in the long term it isn't.. So you can't
really blindly start converting the annotation..

I should also mention that I didn't write the -mm version alone, it was
an effort between three people me, Andrew, and Hua Zhong (CC added)..

Daniel

