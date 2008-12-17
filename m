Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755010AbYLQN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYLQN2W (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 08:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYLQN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 08:28:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60103 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYLQN2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 08:28:07 -0500
To: "George Spelvin" <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [RFC] globmatch() helper function
From: Andi Kleen <andi@firstfloor.org>
References: <20081217104247.28440.qmail@science.horizon.com>
Date: Wed, 17 Dec 2008 14:28:42 +0100
In-Reply-To: <20081217104247.28440.qmail@science.horizon.com> (George Spelvin's message of "Wed, 17 Dec 2008 05:42:47 -0500")
Message-ID: <87hc530w39.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"George Spelvin" <linux@horizon.com> writes:

Wow, finally a name.

> 			break;
> 		case '*':
> 			if (pat[1] == '\0')	/* Optimize trailing * case */
> 				return true;
> 			/* Recurse on each possible tail of str */
> 			while (!globmatch(pat+1, str))
> 				if (!*str++)
> 					return false;

I'm uneasy with the unbounded recursion. Sure currently all the users
are controlled in kernel source code and expect to put in sane patterns.
But if someone ever adds a user controlled glob in some way it will be 
trivial to crash/overwrite memory with the limited kernel stack.
And with such a generalized function it's likely to be used more
in the future.

-Andi


-- 
ak@linux.intel.com
