Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755067AbYLQP4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYLQP4P (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYLQPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:55:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55353 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYLQPzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:55:54 -0500
Subject: Re: [RFC] globmatch() helper function
From: Steven Rostedt <srostedt@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org, tj@kernel.org
In-Reply-To: <1229526942.9487.75.camel@twins>
References: <20081217104247.28440.qmail@science.horizon.com>
	 <87hc530w39.fsf@basil.nowhere.org>  <1229526942.9487.75.camel@twins>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 17 Dec 2008 10:47:36 -0500
Message-Id: <1229528856.30177.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-12-17 at 16:15 +0100, Peter Zijlstra wrote:
> On Wed, 2008-12-17 at 14:28 +0100, Andi Kleen wrote:
> > "George Spelvin" <linux@horizon.com> writes:
> > 
> > Wow, finally a name.
> > 
> > > 			break;
> > > 		case '*':
> > > 			if (pat[1] == '\0')	/* Optimize trailing * case */
> > > 				return true;
> > > 			/* Recurse on each possible tail of str */
> > > 			while (!globmatch(pat+1, str))
> > > 				if (!*str++)
> > > 					return false;
> > 
> > I'm uneasy with the unbounded recursion. Sure currently all the users
> > are controlled in kernel source code and expect to put in sane patterns.
> > But if someone ever adds a user controlled glob in some way it will be 
> > trivial to crash/overwrite memory with the limited kernel stack.
> > And with such a generalized function it's likely to be used more
> > in the future.
> 
> ftrace has a globbing thing in there somewhere as well and that does
> indeed take user input.
> 
> Using recursion in kernel code is indeed not recommended, what Andi said
> we have tiny stacks.

ftrace has a very limited glob feature, and requires no recursion.
Basically, we allow:

*match

match*

*match*

We do not allow match*two, that would be the same as match*

I need to look at your code (I would like a generalized glob feature for
user input). Can you accomplish the same with using a loop instead of
recursion?


-- Steve


