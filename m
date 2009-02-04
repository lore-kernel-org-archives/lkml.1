Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbZBDT0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbZBDT0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBDTZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:25:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60422 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZBDTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:25:56 -0500
Subject: Re: [PATCH NET-NEXT 01/10] clocksource: allow usage independent of
	timekeeping.c
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Patrick Ohly <patrick.ohly@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233760170.15119.76.camel@desktop>
References: <1233752517-30010-1-git-send-email-patrick.ohly@intel.com>
	 <1233752517-30010-2-git-send-email-patrick.ohly@intel.com>
	 <1233756235.15119.54.camel@desktop> <1233758796.15940.198.camel@ecld0pohly>
	 <1233760170.15119.76.camel@desktop>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 11:25:42 -0800
Message-Id: <1233775542.6994.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 07:09 -0800, Daniel Walker wrote:
> On Wed, 2009-02-04 at 15:46 +0100, Patrick Ohly wrote:
> > In an earlier revision of the patch I had adapted clocksource itself so
> > that it could be used outside of the time keeping code; John wanted me
> > to use these smaller structs instead that you now find in the current
> > patch.
> 
> Well, I think your original idea was better.. I don't think we need the
> duplication of underlying clocksource mechanics.
> 
> > Eventually John wants to refactor clocksource so that it uses them and
> > just adds additional elements in clocksource. Right now clocksource is a
> > mixture of different concepts. Breaking out cyclecounter and timecounter
> > is a first step towards that cleanup.
> 
> The problem I see is that your putting off the cleanup of struct
> clocksource with duplication.. It should go in reverse , you should use
> clocksources for your patch set. Which will motivate John to clean up
> the clocksource structure.

I strongly disagree. Misusing a established structure for unintended use
is just bad. What Patrick wants to use the counters for has very
different semantics then how clocksources are used.

I think having a bit of redundancy in two structures is good motivation
for me to clean up the clocksources to use cyclecounters.

thanks
-john

