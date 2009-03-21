Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbZCUXUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbZCUXUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 19:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZCUXUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 19:20:22 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55514 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZCUXUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 19:20:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18885.29855.433194.463455@cargo.ozlabs.ibm.com>
Date: Sun, 22 Mar 2009 10:13:35 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled
 for each counter
In-Reply-To: <20090321055252.eb0673ea.akpm@linux-foundation.org>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
	<20090321055252.eb0673ea.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Perhaps one of the reasons why this code is confusing is the blurring
> between the "time" at which an event occured and the "time" between the
> occurrence of two events.  A weakness in English, I guess.  Using the term
> "interval" in the latter case will help a lot.

Except that we aren't measuring an "interval", we're measuring the
combined length of a whole series of intervals.  What's a good word
for that?

> > +	atomic64_t			child_time_enabled;
> > +	atomic64_t			child_time_running;
> 
> These read like booleans, but why are they atomic64_t's?

OK so this file could use more comments, but I did answer that
question in the patch description.

> > -	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
> > +	if (count != n * sizeof(u64))
> > +		return -EINVAL;
> > +
> > +	if (!access_ok(VERIFY_WRITE, buf, count))
> > +		return -EFAULT;
> > +	
> 
> <panics>
> 
> Oh.
> 
> It would be a lot more reassuring to verify `uptr', rather than `buf' here.
> 
> The patch adds new trailing whitespace.  checkpatch helps.
> 
> > +	for (i = 0; i < n; ++i)
> > +		if (__put_user(values[i], uptr + i))
> > +			return -EFAULT;
> 
> And here we iterate across `n', whereas we verified `count'.

And the fact that we just verified count == n * 8, four lines above,
doesn't give you any comfort?

Paul.
