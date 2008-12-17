Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752042AbYLQPhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYLQPhY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYLQPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:37:06 -0500
Received: from science.horizon.com ([192.35.100.1]:12913 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751169AbYLQPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:37:05 -0500
Message-ID: <20081217153704.4238.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Wed, 17 Dec 2008 10:37:04 -0500
To: linux@horizon.com, andi@firstfloor.org
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com>
 <87hc530w39.fsf@basil.nowhere.org>
In-Reply-To: <87hc530w39.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

> I'm uneasy with the unbounded recursion. Sure currently all the users
> are controlled in kernel source code and expect to put in sane patterns.
> But if someone ever adds a user controlled glob in some way it will be 
> trivial to crash/overwrite memory with the limited kernel stack.
> And with such a generalized function it's likely to be used more
> in the future.

I was just trying to keep the code small and elegant, and adding a
recursion counter or explicit stack would complicate it.

Further, even ignoring the stack space issue, allowing uncontrolled
patterns exposes a second, more insidious bug: due to the naive
backtracking, the run time is (potentially) exponential in the number
of *s present.  That could itself crash a non-preemptive kernel with a
watchdog enabled.

The simple fix is a very low limit on non-trailing * patterns (like
maybe 2), but then it's not generalized any more...


I'm willing to be persuaded, but the cost of making it robust against
pathological patterns is significant.  Is it really worth it?
And if it's not actually robust, why include a half-assed solution?

Does anyone else have an opinion on the matter?
