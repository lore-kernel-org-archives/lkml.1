Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754074AbYLQQWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYLQQWu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLQQWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:22:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbYLQQWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:22:39 -0500
Subject: Re: [RFC] globmatch() helper function
From: Steven Rostedt <srostedt@redhat.com>
To: George Spelvin <linux@horizon.com>
Cc: peterz@infradead.org, andi@firstfloor.org, tj@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20081217160417.18507.qmail@science.horizon.com>
References: <20081217104247.28440.qmail@science.horizon.com>
	 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
	 <20081217160417.18507.qmail@science.horizon.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 17 Dec 2008 11:13:12 -0500
Message-Id: <1229530392.30177.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-12-17 at 11:04 -0500, George Spelvin wrote:

> 
> The problem is, what if some future thoughtless person feeds user data
> into the pattern argument?
> 
> I could just take support for non-trailing * out entirely.  That would be
> a different sort of documentation burden.
> 
> Or I could just add an explicit 2-level stack. If you overflow the stack,
> matching always fails.  Unfortunately, the code will be larger.
> 
> Do people think that would be, on balance, better?  It would be plenty
> good enough for the blacklist application.

Having a static function do the work and pass in a "depth" parameter
should be sufficient. As Andi mentioned, a depth of 10 should be plenty.

Like this:

static bool
 globmatch_internal(const char *pat, const char *str, int depth)
{
	if (depth > 10)
		return false;

	[...]

	while (!globmatch_internal(pat+1, str, depth+1))
	[...]
}

bool globmatch(const char *pat, const char *str)
{
	return globmatch_internal(pat, str, 0);
}

Make sure you include a "Signed-off-by:" as well.

-- Steve


