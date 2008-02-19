Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbYBSEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbYBSEES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYBSEEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:04:05 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:55829 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYBSEEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:04:04 -0500
Date: Tue, 19 Feb 2008 05:04:03 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1203382940.5984.242.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802190219360.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home>  <1202774999.5984.106.camel@localhost>
  <Pine.LNX.4.64.0802120335170.3378@scrub.home>  <1202963796.6195.141.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802150436300.1822@scrub.home> <1203382940.5984.242.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 18 Feb 2008, john stultz wrote:

> If we are building a train station, and each train car is 60ft, it
> doesn't make much sense to build 1000ft stations, right? Instead you'll
> do better if you build a 1020ft station.

That would assume trains are always 60ft long, which is the basic error in 
your assumption.

Since we're using analogies: What you're doing is to put you winter 
clothes on your weight scale and reset the scale to zero to offset for the 
weigth of the clothes. If you stand now with your bathing clothes on the 
scale, does that mean you lost weight?
That's all you do - you change the scale and slightly screw the scale for 
everyone else trying to use it.

To keep in mind what time adjusting is supposed to do:

	freq = 1sec + time_freq

What we do instead is:

	freq + tick_adj = 1sec + time_freq

Where exactly is now the problem to integrate tick_adj into time_freq? The 
result is _exactly_ the same. The only visible difference is a slightly 
higher time_freq value and as long as it is within the 500 ppm limit there 
is simply no problem.

> And yes, if we remove CLOCK_TICK_ADJUST, that would also resolve the 
> (A!=B) issue, but it doesn't address the error from #2 below.
> [..]
> 2) We need a solution that handles granularity error well, as this is a
> moderate source of error for course clocksources such as jiffies.
> CLOCK_TICK_ADJUST does cover this fairly well in most cases. I suspect
> we could do even better, but that will take some deeper changes.

How exactly does CLOCK_TICK_ADJUST address this problem? The error due to 
insufficient resolution is still there, all it does is shifting the scale, 
so it's not immediately visible.

> My understanding of your approach (removing CLOCK_TICK_ADJUST),
> addresses issues #1 and #3, but hurts issue #2.

What exactly is hurt?

bye, Roman
