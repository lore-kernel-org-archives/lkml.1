Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756046AbYLQQzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYLQQzW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYLQQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:55:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53772 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYLQQzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:55:04 -0500
Subject: Re: [RFC] globmatch() helper function
From: Steven Rostedt <srostedt@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>, George Spelvin <linux@horizon.com>,
        peterz@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081217165149.GG25779@one.firstfloor.org>
References: <20081217104247.28440.qmail@science.horizon.com>
	 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
	 <20081217160417.18507.qmail@science.horizon.com>
	 <49492733.9000108@kernel.org>
	 <1229531466.30177.12.camel@localhost.localdomain>
	 <494929E5.8060302@kernel.org>
	 <1229531826.30177.14.camel@localhost.localdomain>
	 <20081217165149.GG25779@one.firstfloor.org>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 17 Dec 2008 11:54:32 -0500
Message-Id: <1229532872.30177.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-12-17 at 17:51 +0100, Andi Kleen wrote:
> > OK, lets compromise with WARN_ON_ONCE() ;-)
> 
> I don't think WARN_ON is the right way to handle bad user input.
> It implies that when someone typos the result might end up in Arjan's 
> kerneloops.org database, which is not good.


Since I recommended an internal helper function, we could have:

int globmatch(const char *pat, const char *str)
{
	int ret;

	ret = globmatch_internal(pat, str, 0);
	if (ret < 0)
		WARN_ON();
	return ret;
}

int globmatch_user(const char *pat, const char *str)
{
	return globmatch_internal(pat, str, 0);
}


This would warn on if a kernel user caused the overflow, and also gives
a function that user space input could use, that would not warn on
overflow.

-- Steve


