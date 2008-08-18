Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYHRMOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYHRMOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYHRMOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:14:25 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:44822 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752070AbYHRMOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:14:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Yo5SzKuo2L74FVR9t++AZwm13IcB6uGWg/SPcoX7sC2ySuk9Mztw4KVMTMfnWqB7lQ0Mhk1C9BijNOIVhigzmfCzSuIYvTytVWLCFnke5ZLm/dqIJwWddEBHsSbESd4VRViF3daLlQaLvvUjfk8NkAFxEHvDduB6gQq3eV2hCDM=  ;
X-YMail-OSG: m2wf5jQVM1l0tgYkUR..nBSLkVqFKX4JBVt5px_uslc3Pdser8Rm_7qjL8yd7NQsX3m8RmcaH0HEoOix9bJNvcBomEjg8tPIQVtANN8kyicRj8zmS_KI4NivUWRGUjDzmqI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
Date: Mon, 18 Aug 2008 22:14:08 +1000
User-Agent: KMail/1.9.5
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
References: <1218880552.11912.9.camel@matrix> <200808182124.17359.nickpiggin@yahoo.com.au> <1219060315.10800.338.camel@twins>
In-Reply-To: <1219060315.10800.338.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182214.08942.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 21:51, Peter Zijlstra wrote:
> On Mon, 2008-08-18 at 21:24 +1000, Nick Piggin wrote:
> > Really, you think the enterprise distros will willingly break POSIX
> > and their own backwards compatiblity by default? I wouldn't have
> > thought so, but anyway I guess they are free to make that choice, so
> > where's the problem?
>
> I'm not seeing why you're making such a big fuss over this - IMO its not
> such a significant breakage. Esp since very few realtime apps will
> require such large amounts of time to ever run into the throttle.
>
> If their usage is 95%+ cpu they must have magic WCET estamates - or like
> in this case, be a benchmark app which IMHO just abuses the real-time
> class.

Note that this certainly does not have to be the case. It is perfectly
valid to dynamically scale the work performed according to the amount
of CPU time available but still be sensitive to latency.

video decoding would be a really simple example. But you can't just
"know" how all RT apps are coded and think this is no problem.


> It's like running your real-time code on a 5% slower cpu - if it runs
> correctly on the 5% slower cpu, it will run correctly here too.

Aside from the latency issue which makes this statement incorrect...
If the code does not run correctly on a 5% slower CPU, it will break.
How is that OK?

You might expect many systems would include at least a 5% margin of
error, but if the kernel takes 5%, then that's 5% of the safety
margin gone, so while the app might "work", it might no longer
meet requirements.


> Note that correctness from a RT pov is making your deadline.

Correctness from the kernel's POV is implementing APIs as advertised,
and just as importantly, not changing them. We can argue about how RT
apps work, but there is no argument that the kernel has broken
backwards compatibility and standards.
