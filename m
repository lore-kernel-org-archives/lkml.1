Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZFRWfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZFRWfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZFRWfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:35:06 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:65039 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZFRWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:35:05 -0400
Message-ID: <4A3AC0FF.20808@nortel.com>
Date: Thu, 18 Jun 2009 16:34:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, Chris Adams <cmadams@hiwaay.net>,
       510478@bugs.debian.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] v2 Re: Bug: Status/Summary of slashdot leap-second crash
 on new years 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>	 <20090103002114.GA1538533@hiwaay.net>	 <20090103022358.GA2454@dastardly.home.dghda.com>	 <20090103044143.GB1538533@hiwaay.net>	 <20090103045227.GA5994@dastardly.home.dghda.com>	 <20090103180148.GA1375968@hiwaay.net> <1244427498.21215.200.camel@deadeye>
In-Reply-To: <1244427498.21215.200.camel@deadeye>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2009 22:34:41.0156 (UTC) FILETIME=[F8656440:01C9F064]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Sat, 2009-01-03 at 12:01 -0600, Chris Adams wrote:
>> Once upon a time, Duane Griffin <duaneg@dghda.com> said:
>>> How about instead of a switch statement, assigning the message to a
>>> variable and printing that. I.e. something like:
>> Good point.  Here's an updated version that also adds a comment to the
>> xtime_lock definition about not using printk.
>> -- 
>> Chris Adams <cmadams@hiwaay.net>
>> Systems and Network Administrator - HiWAAY Internet Services
>> I don't speak for anybody but myself - that's enough trouble.
>>
>>
>> From: Chris Adams <cmadams@hiwaay.net>
>>
>> The code to handle leap seconds printks an information message when the
>> second is inserted or deleted.  It does this while holding xtime_lock.
>> However, printk wakes up klogd, and in some cases, the scheduler tries
>> to get the current kernel time, trying to get xtime_lock (which results
>> in a deadlock).  This moved the printks outside of the lock.  It also
>> adds a comment to not use printk while holding xtime_lock.
> [...]
> 
> This patch doesn't seem to have gone anywhere.  Was this bug fixed in
> some other way or has it been forgotten?

I'm interested in this as well...the current code still issues a
printk() while holding the xtime_lock for writing.  Is this allowed or not?

In addition, is it allowed for older kernels also or is Chris Adams'
patch something that should get picked up for the 2.6.27 stable series?

Chris
