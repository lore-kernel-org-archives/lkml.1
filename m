Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYCQHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYCQHOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYCQHN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:13:57 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:60534 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751456AbYCQHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:13:56 -0400
Message-ID: <47DE1A4C.9080109@davidnewall.com>
Date: Mon, 17 Mar 2008 17:44:20 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803161942.01944.phillips@phunq.net> <alpine.DEB.1.00.0803162052160.14887@asgard.lang.hm> <200803162252.58274.phillips@phunq.net>
In-Reply-To: <200803162252.58274.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> On Sunday 16 March 2008 20:59, david@lang.hm wrote:
>   
>> On Sun, 16 Mar 2008, Daniel Phillips wrote:
>>     
>>> On Sunday 16 March 2008 18:31, David Newall wrote:
>>>       
>>>> Daniel Phillips wrote:
>>>>         
>>>>> The UPS provides a guarantee of commit to stable storage.  No amount of
>>>>> FUD will change that.
>>>>>           
>>>> What about system crashes?  They guarantee that data will be lost.  I
>>>>         
>>> Not if it is mirrored and replicated.  Also nice if crashes are very
>>> rare, which they are unless you work at it.
>>>       
>> if you are depending on replication over the network you have just limited 
>> your throughput to your network speed and latency.
>>     
>
> Replication does not work that way.  On each replication cycle, the
> differences between the most recent two volume snapshots go over the
> network. [...]
> Mirroring on the other hand, makes a realtime copy of a volume, that is
> never out of date.
>   

I think you've just tried to obfuscate the truth.  As you have
described, replication does not provide full protection against data
loss; it loses all changes since last cycle.  Recall that it was you who
introduced the word "replication", in the context of guaranteeing no
loss of data.  Then you ignored David's point about the relatively low
speed of networks, remarking only that mirroring is real-time.  Reading
between your words makes clear that "mirroring and replication" does
reduce the performance.  (You claimed microsecond-level transaction times.)


> Designing for dependably high transaction rates
> requires a different mode of thinking that some traditionalists seem to
> be having some trouble with.

You've rather under-valued dependability, though.  Even your idea of
mirroring systems is incomplete, because failure of the principle system
requires transparent fail-over to the redundant system, which is
actually quite challenging, especially with commodity systems hobbled
together in the way you promote.  Remember that you claimed
microsecond-level transaction times, and 6-nines of availability.  The
former seems unlikely with replicated systems and, in the event of a
failure, you won't achieve the latter.

You still haven't investigated the benefit of your idea over a whopping
great buffer cache.  What's the point in all of this if it turns out, as
Alan hinted should be the case, that a big buffer cache gives much the
same performance?  You appear to have gone to a great deal of effort
without having performed quite simple yet obvious experiments.
