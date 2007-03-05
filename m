Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXCEWYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXCEWYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXCEWYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:24:55 -0500
Received: from mail14.syd.optusnet.com.au ([211.29.132.195]:51733 "EHLO
	mail14.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXCEWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:24:54 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Tue, 6 Mar 2007 09:10:06 +1100
User-Agent: KMail/1.9.5
Cc: Markus =?iso-8859-1?q?T=F6rnqvist?= <mjt@nysv.org>,
       ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703052329.45217.kernel@kolivas.org> <200703052123.01095.a1426z@gawab.com>
In-Reply-To: <200703052123.01095.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703060910.06343.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 05:23, Al Boldi wrote:
> Con Kolivas wrote:
> > Gears just isn't an interactive task and just about anything but gears
> > would be a better test case since its behaviour varies wildly under
> > different combinations of graphics cards, memory bandwidth, cpu and so
> > on.
>
> What about reflect?  It has the same problem.
>
> > I'm not even sure what you're trying to prove with gears.
>
> RSDL fairness.
>
> Ok, try this:
> # gears & gears &
> Both run smoothly.
> # nice gears & nice gears &
> Both run smoothly.
>
> Now:
> # gears & nice -10 gears &
> Both stutter.
>
> But:
> # gears & nice --10 gears &
> Both run smoothly.
>
> Something looks fishy with nice levels.

Hah I just wish gears would go away. If I get hardware where it runs at just 
the right speed it looks like it doesn't move at all. On other hardware the 
wheels go backwards and forwards where the screen refresh rate is just 
perfectly a factor of the frames per second (or something like that). 

This is not a cpu scheduler test and you're inferring that there are cpu 
scheduling artefacts based on an application that has bottlenecks at 
different places depending on the hardware combination. 

To imply something is fishy with nice levels, do a test that _only_ uses cpu 
(and not the bus, memory bandwidth, the gpu and has driver interactions) and 
prove that there is something wrong. What happens to other resources on the 
machine the cpu scheduler has no control over. The -rt tree tries to address 
these factors for example but it's a huge - some would say insurmountable - 
thing to try and manage at all levels on a general purpose operating system. 
The cpu is proportioned out very fairly with rsdl on both quota and latency 
according to nice vs cpu usage. When something is fully cpu bound on rsdl its 
average and maximum latency will be greater than something that only 
intermittently uses cpu. The (somewhat lengthy and not easily digestible) 
docs describe how you can model what these latencies will be.

> Otherwise, your scheduler looks great!

Thanks!

-- 
-ck
