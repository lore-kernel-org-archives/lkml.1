Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYGEOB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYGEOB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGEOBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:01:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40970 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYGEOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:01:49 -0400
Message-ID: <486F7EC9.60608@firstfloor.org>
Date: Sat, 05 Jul 2008 16:01:45 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Peterson <joe@skyrush.com>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>	<486E83C3.1040509@skyrush.com>	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>	<871w29s5u2.fsf@basil.nowhere.org>	<20080704221457.1f147225@lxorguk.ukuu.org.uk>	<486E97F2.8020605@firstfloor.org>	<20080704224441.63204bc4@lxorguk.ukuu.org.uk>	<486E9F91.6010701@firstfloor.org>	<20080705113434.41109492@lxorguk.ukuu.org.uk>	<486F543D.8010409@firstfloor.org> <87y74gpkb8.fsf@denkblock.local>
In-Reply-To: <87y74gpkb8.fsf@denkblock.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Actually, I'm not to sure whether this really fixes the root cause of
> the problem 

Ok.

> 
> on your screen when you keep pressing Ctrl+Z until the prompt appears;
> in 2.6.24, for instance, there would just be a short delay but no
> irritating output on the screen that makes you wonder.
> 
> Quite frankly, I'm a bit at a loss as to how I should go about debugging
> this and what kind of data might be useful to others to do so. In
> another email Alan talked about latency traces which is something new to
> me. Since the OP talked about latencytop,

I don't think latencytop would help to be frankly.

> I hope that this tool provides
> the data Alan requires and will install and make use of it accordingly
> (expect some results later today or tomorrow). Of course, I'm always
> open to other / additional suggestions.

The way to do latency traces is to install the -rt patchkit, don't
actually enable any of the RT features there, but enable CONFIG_FUNCTION_TRACE.

The interface is unfortunately quite user unfriendly and it takes
significant effort to set it up in a way and trigger
at the right point and on the right CPU that you can actually
get usable traces in my experience.

The advantage is that once you have the trace for the right
place (in this case from Ctrl-C to process exit) it is usually
clear what the problem is. You'll have done all the work
for Alan then.

Also the work to do this is likely similar in effort to just bisecting
it.

-Andi


