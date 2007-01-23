Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986AbXAWPKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbXAWPKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXAWPKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:10:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbXAWPKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:10:35 -0500
Message-ID: <45B62376.9000303@redhat.com>
Date: Tue, 23 Jan 2007 10:02:14 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Lameter <clameter@sgi.com>, Balbir Singh <balbir@in.ibm.com>,
       Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
References: <45B55286.5060909@nobaq.net>	 <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com>	 <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>	 <45B569A4.3010006@redhat.com>	 <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com> <1169540992.6197.202.camel@twins>
In-Reply-To: <1169540992.6197.202.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2007-01-22 at 18:03 -0800, Christoph Lameter wrote:
>> What happened to all those advanced page replacement endeavors? 
> 
> They are here:
> http://programming.kicks-ass.net/kernel-patches/page-replace/2.6.19-pr1/
> 
> I should update to .20 soonish.
> 
>> What is the most promising of those?
> 
> I'm still torn between CLOCK-Pro and CART. 
> 
> CLOCK-Pro is still vulnerable to the cyclic scan use case, since at that
> time all pages will have equal distance.

That's fixable.  Just bias in favor of the already active
pages and only let pages with a clearly smaller interreference
distance replace them.

> CART might be fixable (my CART-r approach) but I still have to study the
> full ramifications of that (does it hurt other workloads?).

Your CART-r seems reasonable, too.

> Both seems quite capable to distinguish between recency and frequency.
> Neither use this horrid swappiness knob to distinguish between mapped
> and unmapped pages.

Getting rid of swappiness is a very good thing, IMHO.
I have heard about a few customer workloads that required
changes to swappiness in order for the system to be able
to handle their workload at all.

Systems should not have to be tuned like that...

> The main problem I'm having is test cases, notably the lack thereof.
> (and lack of time ofcourse ;-)

Yes, this is always a problem.  I am not aware of any complete
test cases to test page replacement.

It would be easy to simulate some database by having part of
the dataset be the index and referencing that in an r^2 way,
and the rest being the data which is referenced less.  At that
point you can see how taking frequency into account helps.

However, tests like that are simply not complete.  They are
not representative of the things most people do with their
system.

Something like AIM-7 suffers from the same problems...

Anybody?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
