Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0BMRdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 12:33:38 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41918 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0BMRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 12:33:37 -0500
Date: Sat, 13 Feb 2010 23:03:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100213173323.GB3778@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B745F5C.5050001@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 08:49:48PM +0100, Michael Stefaniuc wrote:
> On 02/11/2010 07:22 PM, Frederic Weisbecker wrote:
>> On Thu, Feb 11, 2010 at 05:33:13PM +0100, Michael Stefaniuc wrote:
>>> 2.6.33-rc1 broke ptrace for Wine, specifically the setting of the debug
>>> registers. This is visible in the Wine ntdll exception tests failing on
>>> 2.6.33-rcX while they work just fine in 2.6.32.
>>>
>>> A regression test resulted in:
>>> 72f674d203cd230426437cdcf7dd6f681dad8b0d is the first bad commit
>>> commit 72f674d203cd230426437cdcf7dd6f681dad8b0d
>>> Author: K.Prasad<prasad@linux.vnet.ibm.com>
>>> Date:   Mon Jun 1 23:45:48 2009 +0530
>>>
>>>      hw-breakpoints: modify Ptrace routines to access breakpoint registers
>>>
>
>> Thanks a lot for your report. Is there an easy way to reproduce
>> this?
> Yes, the bug is 100% reproducible. Even the "stack overflow" bytes are
> always constant on my two boxes: 932 bytes on my Atom and 1588 bytes on
> my Q9450 with a x86_64 kernel.
>
> Either grab wine-1.1.38 from
> http://sourceforge.net/projects/wine/files/Source/ or from git
>   git clone git://source.winehq.org/git/wine.git
> configure
> make
> cd dlls/ntdll/tests/
> make exception.ok
>

Can you be more specific with details - such as what was the desired
action/return value of ptrace that your testcase wanted but did not
happen (after the patch applied)? What is the other regression that
you found as a result of another patch in the hw-breakpoint patch
series?

I am able to see a user-space stackdump upon a 'make exception.ok',
which isn't easy enough (atleast for me) to narrow down to the purported
ptrace defect.

> If you build on an x86_64 machine you'll need a pretty complete 32bit
> setup too, but configure will let you know. If configure doesn't errors
> out but produces warnings, those can be safely ignored. It means the
> dependencies are optional and those aren't needed to reproduce this bug.
>
> Oh, there might be an other regression in ptrace too; introduced by a
> previous patch in this series. While bisecting i had a later test fail,
> something along the lines of "expected 4 exceptions got 0", but the
> tests completed. Now the stack corruption mask everything else in the
> tests; e.g. comment out the first test and one of the next tests will go
> into an infinite loop printing 3 Wine errors over and over again.
>
> thanks
> bye
>         michael

Thanks,
K.Prasad

