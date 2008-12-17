Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755983AbYLQQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYLQQh2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYLQQhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:37:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYLQQhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:37:14 -0500
Subject: Re: [RFC] globmatch() helper function
From: Steven Rostedt <srostedt@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: George Spelvin <linux@horizon.com>, peterz@infradead.org,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <494929E5.8060302@kernel.org>
References: <20081217104247.28440.qmail@science.horizon.com>
	 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
	 <20081217160417.18507.qmail@science.horizon.com>
	 <49492733.9000108@kernel.org>
	 <1229531466.30177.12.camel@localhost.localdomain>
	 <494929E5.8060302@kernel.org>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 17 Dec 2008 11:37:06 -0500
Message-Id: <1229531826.30177.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-12-18 at 01:33 +0900, Tejun Heo wrote:
> Steven Rostedt wrote:
> > On Thu, 2008-12-18 at 01:22 +0900, Tejun Heo wrote:
> >> Hello,
> >>
> >> George Spelvin wrote:
> >>> Do people think that would be, on balance, better?  It would be plenty
> >>> good enough for the blacklist application.
> >> Just pass a depth parameter and trigger WARN_ON() and return -EINVAL
> >> when it exceeds ten.  It's a five minute change and should be enough
> >> for kernel usages.
> > 
> > If this is ever expected to be used by userspace, I would not include
> > the WARN_ON. If this is a generic function, then I'll include in in
> > ftrace as well, and that takes userspace input. The last thing I want is
> > a DoS because of printk's to the serial console because some userspace
> > app is constantly writing bad patterns to this file.
> 
> Well, then, how about printk_ratelimit()?  Having one too many
> asterisk will be a very rare occasion and when it happens it's
> something which can easily escape attention, so I think some form of
> whining is in order.

I do not think printk_ratelimit is appropriate here.

OK, lets compromise with WARN_ON_ONCE() ;-)

-- Steve


