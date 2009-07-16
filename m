Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZGPOrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZGPOrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZGPOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:47:11 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:59459 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbZGPOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:47:10 -0400
Message-ID: <4A5F3D5C.1070704@nortel.com>
Date: Thu, 16 Jul 2009 08:46:52 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ted Baker <baker@cs.fsu.edu>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <1247590112.9086.936.camel@Palantir> <4A5CCD5A.80108@nortel.com> <20090715221410.GE14993@cs.fsu.edu>
In-Reply-To: <20090715221410.GE14993@cs.fsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 14:46:54.0877 (UTC) FILETIME=[432814D0:01CA0624]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Baker wrote:
> On Tue, Jul 14, 2009 at 12:24:26PM -0600, Chris Friesen wrote:
> 
>>> - that A's budget is not diminished.
>> If we're running B with A's priority, presumably it will get some amount
>> of cpu time above and beyond what it would normally have gotten during a
>> particular scheduling interval.  Perhaps it would make sense to charge B
>> what it would normally have gotten, and charge the excess amount to A?

> So, it seems most logical and simplest to leave the charges where
> they naturally occur, on B.  That is, if you allow priority
> inheritance, you allow tasks to sometimes run at higher priority
> than they originally were allocated, but not to execute more 
> than originally budgeted.

I had considered this myself, as the simplicity is appealing.

In this scenario, we're going to disrupt B's scheduling pattern by
forcing it to borrow from its future cpu allocation in order to free up
the lock.  It will then be forced to block for a while to make up for
the over-use of it's cpu budget.

I was worried that this "bursty" behaviour could cause problems, but on
reflection it seems like if the application is well-behaved to start
with, maybe we can assume that lock-hold times will be small enough that
this shouldn't cause significant problems.

Chris
