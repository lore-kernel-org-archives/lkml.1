Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbXCLSuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbXCLSuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXCLSuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:50:21 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:39777 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbXCLSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:50:17 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 05:49:46 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <200703122223.07048.kernel@kolivas.org> <1173710082.6326.49.camel@Homer.simpson.net>
In-Reply-To: <1173710082.6326.49.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703130549.47058.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 01:34, Mike Galbraith wrote:
> On Mon, 2007-03-12 at 22:23 +1100, Con Kolivas wrote:
> > Mike the cpu is being proportioned out perfectly according to fairness as
> > I mentioned in the prior email, yet X is getting the lower latency
> > scheduling. I'm not sure within the bounds of fairness what more would
> > you have happen to your liking with this test case?
>
> It has been said that "perfection is the enemy of good".  The two
> interactive tasks receiving 40% cpu while two niced background jobs
> receive 60% may well be perfect, but it's damn sure not good.

Again I think your test is not a valid testcase. Why use two threads for your 
encoding with one cpu? Is that what other dedicated desktop OSs would do?

And let's not lose sight of things with this one testcase.

RSDL fixes
- every starvation case
- all fairness isssues
- is better 95% of the time on the desktop

If we fix 95% of the desktop and worsen 5% is that bad given how much else 
we've gained in the process?

Anyway for my next trick I plan to make -nice values not suck again. So we can 
go full circle and start renicing X (only if you so desire) as well like we 
used to. I figure that's the only way left to satisfy all requirements to 
beat even those last 5%. However for the most part I don't even think 
renicing X will be required (and hasn't been prior to this testcase). 
Nonetheless unsucking negative nice values is probably worthwhile. 

I need time to make it so though. Precious sleep and mood has been destroyed 
this week.

-- 
-ck
