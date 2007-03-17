Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXCQIXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXCQIXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCQIXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:23:53 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:36780 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXCQIXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:23:52 -0400
Subject: Re: RSDL v0.31
From: Nicholas Miell <nmiell@comcast.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070317074506.GA13685@elte.hu>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
	 <1174105443.3144.4.camel@entropy>
	 <1174110965.7911.44.camel@Homer.simpson.net>
	 <1174112768.3144.8.camel@entropy>  <20070317074506.GA13685@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 01:23:50 -0700
Message-Id: <1174119830.3144.22.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the duplicate Ingo, this time I managed to Repy to All)

On Sat, 2007-03-17 at 08:45 +0100, Ingo Molnar wrote:
> * Nicholas Miell <nmiell@comcast.net> wrote:
> 
> > The X people have plans for how to go about fixing this, [...]
> 
> then we'll first have wait for those X changes to at least be done in a 
> minimal manner so that they can be tested for real with RSDL. (is it 
> _really_ due to that? Or will X regress forever once we switch to RSDL?)

Yes, it's an X problem.

There's two issues, really -- smooth pointer movement or the lack
thereof and the servicing of clients at varying priorities. There's
vague plans floating around about moving all input processing off into a
separate high-priority thread and pretty much no ideas how to deal with
mixed priority clients.

So, the current scheduler works around this brain damage using
heuristics that sort of do the job and sometimes screw things up.

> We cannot regress the scheduling of a workload as important as "X mixed 
> with CPU-intense tasks". And "in theory this should be fixed if X is 
> fixed" does not cut it. X is pretty much _the_ most important thing to 
> optimize the interactive behavior of a Linux scheduler for. Also, 
> paradoxically, it is precisely the improvement of _X_ workloads that 
> RSDL argues with.
> 
> this regression has to be fixed before RSDL can be merged, simply 
> because it is a pretty negative effect that goes beyond any of the 
> visible positive improvements that RSDL brings over the current 
> scheduler. If it is better to fix X, then X has to be fixed _first_, at 
> least in form of a prototype patch that can be _tested_, and then the 
> result has to be validated against RSDL.
> 

RSDL is, above all else, fair. Predictably so.
Hacking around X's stupidity makes it no longer *be* RSDL.

Until they catch up to the early-90s technology-wise, we can just nice
-19 X.

-- 
Nicholas Miell <nmiell@comcast.net>

