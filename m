Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbXFUTjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbXFUTjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbXFUTiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:38:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758611AbXFUTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:38:51 -0400
Date: Thu, 21 Jun 2007 12:35:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Linus Torvalds wrote:
> 
> We don't do nesting locking either, for exactly the same reason. Are 
> nesting locks "easier"? Absolutely. They are also almost always a sign of 
> a *bug*. So making spinlocks and/or mutexes nest by default is just a way 
> to encourage bad programming!

Side note, and as a "truth in advertising" section: I'll have to admit 
that I argued against fair semaphores on the same grounds. I was wrong 
then (and eventually admitted it, and we obviously try to make our mutexes 
and semaphores fair these days!), and maybe I'm wrong now.

If somebody can actually come up with a sequence where we have spinlock 
starvation, and it's not about an example of bad locking, and nobody 
really can come up with any other way to fix it, we may eventually have to 
add the notion of "fair spinlocks".

So my arguments are purely pragmatic. It's not that I hate fairness per 
se. I dislike it only when it's used to "solve" (aka hide) other problems.

In the end, some situations do need fairness, and the fact that aiming for 
fairness is often harder, slower, and more complicated than not doing so 
at that point turns into a non-argument. If you need it, you need it.

I just don't think we need it, and we're better off solving problems other 
ways.

(For example, we might also solve such problems by creating a separate
"fair_spin_lock" abstraction, and only making the particular users that 
need it actually use it. It would depend a bit on whether the cost of 
implementing the fairness is noticeable enough for it to be worth having 
a separate construct for it).

		Linus
