Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbXJRGaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbXJRGaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXJRGaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:30:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46959 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbXJRGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:30:00 -0400
Date: Thu, 18 Oct 2007 11:59:45 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-ID: <20071018062945.GA15281@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com> <200710171047.42693.rusty@rustcorp.com.au> <20071017053754.GB9940@in.ibm.com> <200710171629.13060.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710171629.13060.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 04:29:12PM +1000, Rusty Russell wrote:
> On Wednesday 17 October 2007 15:37:54 Gautham R Shenoy wrote:
> > On Wed, Oct 17, 2007 at 10:47:41AM +1000, Rusty Russell wrote:
> > > On Tuesday 16 October 2007 20:34:17 Gautham R Shenoy wrote:
> > > > This patch implements a Refcount + Waitqueue based model for
> > > > cpu-hotplug.
> > >
> > > Hi Gautham,
> >
> > Hi Rusty,
> >
> > > 	I can't see where you re-initialize the completion.
> >
> > The cpu_hotplug.readers_done is a global variable which has been
> > initialized in cpu_hotplug_init.
> >
> > So I am wondering is the re-initialization required ?
> 
> Yes.  AFAICT you use this completion on every hotplug.  Yet once a completion 
> is completed, it needs to be re-initialized to be reused: it's "complete" and 
> wait_for_completion will return immediately thereafter.
>

Okay, I thought completion followed the spinlock semantics, and hence 
didn't require re-initalization. Thanks for that information!

> Perhaps you want a waitqueue instead?

Yes, I had considered it. But completion looked appealing since it 
already had the wait-queuing code. I'll give it a try and repost 
the series with other changes.

> 
> Rusty.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
