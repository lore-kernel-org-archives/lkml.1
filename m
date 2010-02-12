Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0BLSP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:15:27 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46757 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0BLSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CFdm7EgYxxyAW2ntWC8iI7L5eM6CBMmszkp7FoZgoIrfGX1qMBkPkByzHlx03Pp8se
         DKJXWylHjYjQb8BGUu9RaUNG8B6gIDce3g5RtPNt80gWkxxYWCAB2yT/l5h2TgJ+mVaU
         DzHjPP3emDFnlthoqjUo6oN/CG6G2g1dYvfMs=
Date: Fri, 12 Feb 2010 19:15:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100212181502.GB5475@nowhere>
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B745F5C.5050001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
>>>      This patch modifies the ptrace code to use the new wrapper routines
>>> around
>>> the
>>>      debug/breakpoint registers.
>>>
>>>      [ Impact: adapt x86 ptrace to the new breakpoint Api ]
>>>
>>>      Original-patch-by: Alan Stern<stern@rowland.harvard.edu>
>>>      Signed-off-by: K.Prasad<prasad@linux.vnet.ibm.com>
>>>      Signed-off-by: Maneesh Soni<maneesh@linux.vnet.ibm.com>
>>>      Reviewed-by: Alan Stern<stern@rowland.harvard.edu>
>>>      Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com>
>>>
>>> :040000 040000 f72ff4760c3fa1dffcd72494e77bee2c76039505
>>> b60d5fe2088ff635568e800d5759a0b373b5e439 M      arch
>>>
>>>
>
>>> I have opened also http://bugzilla.kernel.org/show_bug.cgi?id=15273 for
>>> this.
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
> If you build on an x86_64 machine you'll need a pretty complete 32bit
> setup too, but configure will let you know. If configure doesn't errors
> out but produces warnings, those can be safely ignored. It means the
> dependencies are optional and those aren't needed to reproduce this bug.



Ok, I'm going to test it.




> Oh, there might be an other regression in ptrace too; introduced by a
> previous patch in this series. While bisecting i had a later test fail,
> something along the lines of "expected 4 exceptions got 0", but the
> tests completed. Now the stack corruption mask everything else in the
> tests; e.g. comment out the first test and one of the next tests will go
> into an infinite loop printing 3 Wine errors over and over again.


Ok, will look at this too.

Thanks.

