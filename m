Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbYDKVLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbYDKVLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbYDKVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:11:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760898AbYDKVLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:11:21 -0400
Message-ID: <47FFD3F3.50107@redhat.com>
Date: Fri, 11 Apr 2008 17:11:15 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <628754.88392.qm@web52501.mail.re2.yahoo.com>
In-Reply-To: <628754.88392.qm@web52501.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> --- Chris Snook <csnook@redhat.com> wrote:
> 
>> Marc Perkel wrote:
>>> I was just wondering if there were any known
>> issues
>>> with AMD quad core phenom clock drift problems?
>> I';m
>>> running a 2.6.24 kernel and it's losing time. I
>>> remember the first dual core AMD chips had a lot
>> of
>>> clock issues.
>>>
>>> If this is something new let me know what
>> information
>>> to check and post to this list.
>> When reporting clock problems, please post dmesg. 
>> This has all the 
>> interesting timekeeping-related log messages from
>> the kernel.  Please 
>> also describe the drift quantitatively.
>>
>> -- Chris
>>
> 
> OK - thanks Chris.
> 
> The drift is small. It loses a few seconds every hour.
> And it might not be kernel related. I just remembered
> the early dual core days when this took months to get
> right. I'm running several dual core computers and the
> only one drifting is the quad. All are running the
> same OS and kernel.

With the older chips, each core had its own TSC, which caused 
synchronization problems.  The Barcelona generation chips (including 
your Phenom) have a constant frequency TSC on the northbridge, so they 
should be immune to these problems.

If it's steadily losing a few seconds every hour, it's probably just 
slightly mis-calibrated hardware.  ntp should fix this right up.  If the 
drift is more extreme than ntp can correct for, or the drift keeps 
changing, or time is jumping around, that is definitely something that 
could be a bug.

> hpet clockevent registered
> TSC calibrated against HPET
> Marking TSC unstable due to TSCs unsynchronized

It's possible that in future kernels we'll be a few clock cycles more 
accurate in calibrating this on Barcelona chips, but calibration is only 
as good as the standard of comparison.  There will always be hardware 
that's slightly off, so run ntp, or use a nightly ntpdate cronjob.  If 
your time starts drifting drastically or jumping around, please yell 
really loud.

-- Chris
