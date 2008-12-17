Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759330AbYLQQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYLQQqr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYLQQqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:46:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:55614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYLQQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:46:32 -0500
Message-ID: <49492CB8.4040303@kernel.org>
Date: Thu, 18 Dec 2008 01:45:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <srostedt@redhat.com>, George Spelvin <linux@horizon.com>,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com>	 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>	 <20081217160417.18507.qmail@science.horizon.com>	 <49492733.9000108@kernel.org>	 <1229531466.30177.12.camel@localhost.localdomain>	 <494929E5.8060302@kernel.org> <1229531764.21171.0.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1229531764.21171.0.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Dec 2008 16:45:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-12-18 at 01:33 +0900, Tejun Heo wrote:
>> Steven Rostedt wrote:
>>> On Thu, 2008-12-18 at 01:22 +0900, Tejun Heo wrote:
>>>> Hello,
>>>>
>>>> George Spelvin wrote:
>>>>> Do people think that would be, on balance, better?  It would be plenty
>>>>> good enough for the blacklist application.
>>>> Just pass a depth parameter and trigger WARN_ON() and return -EINVAL
>>>> when it exceeds ten.  It's a five minute change and should be enough
>>>> for kernel usages.
>>> If this is ever expected to be used by userspace, I would not include
>>> the WARN_ON. If this is a generic function, then I'll include in in
>>> ftrace as well, and that takes userspace input. The last thing I want is
>>> a DoS because of printk's to the serial console because some userspace
>>> app is constantly writing bad patterns to this file.
>> Well, then, how about printk_ratelimit()?  Having one too many
>> asterisk will be a very rare occasion and when it happens it's
>> something which can easily escape attention, so I think some form of
>> whining is in order.
> 
> having the write fail with -EINVAL seems suitably whiney..

Yeah, I suppose so but that makes return value handling weird.  -EINVAL
for error, 0 for mis-match and 1 for match.  Three-way returns are
usually very sucky to handle and error-prone, so I was thinking about
returning -EINVAL in the internal function and printing out the caller
address and pattern on ratelimit or once.

Thanks.

-- 
tejun
