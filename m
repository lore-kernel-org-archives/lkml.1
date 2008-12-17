Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752676AbYLQPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYLQPSH (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYLQPRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:17:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:41216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYLQPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:17:52 -0500
Subject: Re: [RFC] globmatch() helper function
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <87hc530w39.fsf@basil.nowhere.org>
References: <20081217104247.28440.qmail@science.horizon.com>
	 <87hc530w39.fsf@basil.nowhere.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Dec 2008 16:15:42 +0100
Message-Id: <1229526942.9487.75.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 14:28 +0100, Andi Kleen wrote:
> "George Spelvin" <linux@horizon.com> writes:
> 
> Wow, finally a name.
> 
> > 			break;
> > 		case '*':
> > 			if (pat[1] == '\0')	/* Optimize trailing * case */
> > 				return true;
> > 			/* Recurse on each possible tail of str */
> > 			while (!globmatch(pat+1, str))
> > 				if (!*str++)
> > 					return false;
> 
> I'm uneasy with the unbounded recursion. Sure currently all the users
> are controlled in kernel source code and expect to put in sane patterns.
> But if someone ever adds a user controlled glob in some way it will be 
> trivial to crash/overwrite memory with the limited kernel stack.
> And with such a generalized function it's likely to be used more
> in the future.

ftrace has a globbing thing in there somewhere as well and that does
indeed take user input.

Using recursion in kernel code is indeed not recommended, what Andi said
we have tiny stacks.
