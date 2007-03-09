Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXCIIhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXCIIhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXCIIhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:37:11 -0500
Received: from mail16.syd.optusnet.com.au ([211.29.132.197]:58109 "EHLO
	mail16.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbXCIIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:37:10 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Fri, 9 Mar 2007 19:36:46 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703091728.03978.kernel@kolivas.org> <20070309075358.GA10394@waste.org>
In-Reply-To: <20070309075358.GA10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091936.47128.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 18:53, Matt Mackall wrote:
> Well then I suppose something must be broken. When my box is idle, I
> can grab my desktop and spin it around and generate less than 25% CPU
> with the CPU stepped all the way down from 1.7GHz to 600MHz (Beryl is
> actually much snappier than many conventional window managers by doing
> just about everything through GL). By comparison, grabbing the Galeon
> scroll bar and wiggling it will generate 100% CPU (still throttled
> though) but remain relatively smooth.
>
> With a single non-parallel make running (all in cache, mind you), the
> system kicks up into just about 100% CPU usage at full speed. Desktop
> spinning becomes between 10x to 100x slower (from ~30fps to < 1fps).
> Galeon scrolling pauses for as much as a second. Mouse movement pauses
> for as much as a second. Typing in terminals lags noticeably.
>
> This is not the expected behavior of a fair, low-latency scheduler.

No indeed it does not sound right at all to me either. Last time I encountered 
something like this we traced it and hit sched_yield calls somewhere in the 
graphic pipeline. So first question is, how does mainline perform with the 
same testcase, and second question is umm whatever it is that is slow is 
there a way to trace it to see if it yields?

> For reference, this was with HZ=250, PREEMPT, PREEMPT_BKL, and !NO_HZ.

Ah I also wonder if it hasn't broken with NO_HZ. I haven't had a chance to 
even confirm that the code works properly with it, I was only assuming (after 
our last chat). See if turning that off makes a difference?

Thanks for testing!

-- 
-ck
