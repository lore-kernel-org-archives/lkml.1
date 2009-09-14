Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZINPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZINPp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZINPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:45:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:52906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755775AbZINPpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:45:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/O8b0kuAvOYUM/RESyMnlJTzKcFDOBES/Svl+Hgt
	HI9KWIHQg+XRpN
Subject: Re: INGO Why you remove  set_user_nice() from kernel/kthread.c
From: Mike Galbraith <efault@gmx.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: pavel@pavlinux.ru, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4AAE5D60.2080703@nortel.com>
References: <200909141742.45487.pavel@pavlinux.ru>
	 <1252937140.6500.11.camel@marge.simson.net>  <4AAE5D60.2080703@nortel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 17:45:23 +0200
Message-Id: <1252943123.12986.70.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 09:12 -0600, Chris Friesen wrote:
> On 09/14/2009 08:05 AM, Mike Galbraith wrote:
> > If you're asking Ingo a question, maybe a CC is in order.
> > 
> > On Mon, 2009-09-14 at 17:42 +0400, Pavel Vasilyev wrote:
> >>
> >> Next patсh -  
> >> http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2F%2Fv2.6%2Fsnapshots%2Fpatch-2.6.31-git2.bz2;z=548
> >>
> >> This patch defines the core processes that are working with nice leve equal to 
> >> zero , as in the BFS. :)
> >>
> >> Why?
> > 
> > I did that, not Ingo, and did so because with kthreads that use
> > diddly-spit CPU (every one I see), it's just a waste of math.  What
> > kthreads are you seeing using so much CPU that their weight is a factor?
> > They _should_ be able to preempt and get their work done just fine
> > without a boost.
> 
> Under heavy network load ksoftirqd can use significant amounts of cpu.

OK, that may justify a weight adjustment, since it is a proxy for many.
Question is, does it really need it?

I certainly have no objection to a heavier weight for any kthread,
though I think it's a waste of cycles for the general case.

	-Mike

