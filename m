Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYJQSr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYJQSr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJQSrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:47:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50625 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYJQSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:47:46 -0400
X-IronPort-AV: E=Sophos;i="4.33,433,1220227200"; 
   d="scan'208";a="177432917"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com>
	<20081017180523.GA11590@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 17 Oct 2008 11:47:44 -0700
In-Reply-To: <20081017180523.GA11590@elte.hu> (Ingo Molnar's message of "Fri,
	17 Oct 2008 20:05:23 +0200")
Message-ID: <adatzbbrrcf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Oct 2008 18:47:45.0224 (UTC) FILETIME=[D7E00C80:01C93088]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > OTOH, there should be a well-defined work flow to keep this all 
 > manageable: once we know why a warning triggers and it has been 
 > categorized by a human, we should get rid of the warning in some way. 
 > 
 > Applying this patch as-is would be one option. Annotating it with a 
 > specific gcc version would be overkill i think. Ignoring it would be 
 > bad, because there's real value in standardizing on a "no warnings" 
 > build output. Many new warnings get introduced because people do not 
 > notice new warnings amongst the very high baseline noise of the kernel 
 > build.

The specific change I noticed:

 > -						       (1 << MGM_BLCK_LB_BIT));
 > +						       (1U << MGM_BLCK_LB_BIT));

is not a problem to me -- the code is fine either way, and if we're
making an effort to kill all warnings, then I'm OK with merging it.
It's a little unfortunate to add churn due to a gcc bug that is only in
certain 4.3 releases, but this particular case doesn't seem to trigger
in many places, so the cost is low.

However I worry about warnings produced by gcc bugs forcing us to tinker
with correct code.  Maybe it just makes sense to wait and see if we ever
hit a case where a gcc bug forces us to make too many stupid changes,
and figure out what to do if and when that happens.

 - R.
