Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXCLSKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXCLSKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbXCLSKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:10:40 -0400
Received: from mail16.syd.optusnet.com.au ([211.29.132.197]:37156 "EHLO
	mail16.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXCLSKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:10:39 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 05:10:05 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173710082.6326.49.camel@Homer.simpson.net> <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130510.05588.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 02:26, Linus Torvalds wrote:
> On Mon, 12 Mar 2007, Mike Galbraith wrote:
> > On Mon, 2007-03-12 at 22:23 +1100, Con Kolivas wrote:
> > > Mike the cpu is being proportioned out perfectly according to fairness
> > > as I mentioned in the prior email, yet X is getting the lower latency
> > > scheduling. I'm not sure within the bounds of fairness what more would
> > > you have happen to your liking with this test case?
> >
> > It has been said that "perfection is the enemy of good".  The two
> > interactive tasks receiving 40% cpu while two niced background jobs
> > receive 60% may well be perfect, but it's damn sure not good.
>
> Well, the real problem is really "server that works on behalf of somebody
> else".
>
> X is just the worst *practical* example of this, since not only is it the
> most common such server, it's also a case where people see interactive
> issues really easily.
>
> And the problem is that a lot of clients actually end up doing *more* in
> the X server than they do themselves directly. Doing things like showing a
> line of text on the screen is a lot more expensive than just keeping track
> of that line of text, so you end up with the X server easily being marked
> as getting "too much" CPU time, and the clients as being starved for CPU
> time. And then you get bad interactive behaviour.
>
> So "good fairness" really should involve some notion of "work done for
> others". It's just not very easy to do..

Instead of assuming it's bad, have you tried RSDL for yourself? Mike is using 
2 lame threads for his test case.

-- 
-ck
