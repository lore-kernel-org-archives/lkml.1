Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYJQANs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYJQANs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYJQANj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:13:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbYJQANi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:13:38 -0400
Date: Thu, 16 Oct 2008 17:12:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810161709230.3288@nehalem.linux-foundation.org>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Linus Torvalds wrote:
> 
> Perhaps more importantly - if the TSC really are out of whack, that just 
> means that now all your timestamps are worthless, because the value you 
> calculate ends up having NOTHING to do with the timestamp. So you cannot 
> even use it to see how long something took, because it may be that you're 
> running on the CPU that runs behind, and all you ever see is the value of 
> LTT_MIN_PROBE_DURATION.

If it isn't clear: the alternative is to just always use local timestamps.

At least that way the timestamps mean _something_. You can get the 
difference between two events when they happen on the same CPU, and it is 
about as meaningful as it can be.

Don't even _try_ to make a global clock.

Yes, to be able to compare across CPU's you'd need to have extra 
synchronization information (eg offset and frequency things), but quite 
frankly, the "global TSC" thing is already worse than even a totally 
non-synchronized TSC for the above reasons. 

			Linus
