Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbXD1Wrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbXD1Wrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXD1Wrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:47:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbXD1Wrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:47:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Miguel Freitas" <mfreitas@gmail.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: bug in RLIMIT_SIGPENDING
In-Reply-To: Miguel Freitas's message of  Saturday, 28 April 2007 19:00:14 -0300 <f9eabcda0704281500l58c3b791s97c499822b577140@mail.gmail.com>
X-Zippy-Says: How do you explain Wayne Newton's POWER over millions?  It's th'
   MOUSTACHE...  Have you ever noticed th' way it radiates SINCERITY,
   HONESTY & WARMTH?  It's a MOUSTACHE you want to take HOME and
   introduce to NANCY SINATRA!
Message-Id: <20070428224743.6D12A1801A4@magilla.sf.frob.com>
Date: Sat, 28 Apr 2007 15:47:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think there is any reason to think the accounting is wrong.  The
accounted number of queue entries is 1.  The -1 (~0ul) displayed is the
maximum for your process, which is RLIM_INFINITY.

Nothing in what you've reported so far points positively towards a signals
issue per se.  First, you should see if you simply have a livelock
situation.  That is, your signal handler is running many times and never
letting fork complete.  Try setting the itimer to a much larger value like
one second, and see if the problem still occurs.  If not, you may just be
having timer signals going off too fast to finish a fork in between.  If
this is the case and it seems like fork should not take as long as it does,
then you can look into how long fork is really taking and why.

If in fact your signal handler does not run many times, then the issue is
stranger.


Thanks,
Roland
