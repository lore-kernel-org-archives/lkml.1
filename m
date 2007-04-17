Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbXDQNIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbXDQNIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXDQNIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:08:25 -0400
Received: from main.gmane.org ([80.91.229.2]:57365 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbXDQNIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:08:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
   Scheduler [CFS]
Date: Tue, 17 Apr 2007 09:07:49 -0400
Message-ID: <4624C6A5.2090000@andrew.cmu.edu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415152643.GH8915@holomorphy.com> <46239C62.4090302@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: dhcp-7-156.dsl.telerama.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
In-Reply-To: <46239C62.4090302@nortel.com>
Cc: ck@vds.kolivas.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> William Lee Irwin III wrote:
> 
>> The sorts of like explicit decisions I'd like to be made for these are:
>> (1) In a mixture of tasks with varying nice numbers, a given nice number
>>     corresponds to some share of CPU bandwidth. Implementations
>>     should not have the freedom to change this arbitrarily according
>>     to some intention.
> 
> The first question that comes to my mind is whether nice levels should 
> be linear or not.  I would lean towards nonlinear as it allows a wider 
> range (although of course at the expense of precision).  Maybe something 
> like "each nice level gives X times the cpu of the previous"?  I think a 
> value of X somewhere between 1.15 and 1.25 might be reasonable.

Nonlinear is a must IMO.  I would suggest X = exp(ln(10)/10) ~= 1.2589

That value has the property that a nice=10 task gets 1/10th the cpu of a 
nice=0 task, and a nice=20 task gets 1/100 of nice=0.  I think that 
would be fairly easy to explain to admins and users so that they can 
know what to expect from nicing tasks.

> What about also having something that looks at latency, and how latency 
> changes with niceness?

I think this would be a lot harder to pin down, since it's a function of 
all the other tasks running and their nice levels.  Do you have any of 
the RT-derived analysis models in mind?

> What about specifying the timeframe over which the cpu bandwidth is 
> measured?  I currently have a system where the application designers 
> would like it to be totally fair over a period of 1 second.  As you can 
> imagine, mainline doesn't do very well in this case.

It might be easier to specify the maximum deviation from the ideal 
bandwidth over a certain period.  I.e. something like "over a period of 
one second, each task receives within 10% of the expected bandwidth".

  - Jim Bruce

