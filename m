Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZBFOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZBFOwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZBFOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:52:11 -0500
Received: from rtr.ca ([76.10.145.34]:45045 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZBFOwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:52:10 -0500
Message-ID: <498C4E98.3010006@rtr.ca>
Date: Fri, 06 Feb 2009 09:52:08 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
References: <200901301729.30284.borntraeger@de.ibm.com>	 <200902030948.13519.borntraeger@de.ibm.com>	 <20090203122847.GG19979@elte.hu>	 <200902040719.25593.borntraeger@de.ibm.com>	 <1233777584.16238.16.camel@vayu> <20090204213202.GP22608@elte.hu>	 <498B43D9.2080800@rtr.ca> <1233887607.16238.47.camel@vayu>
In-Reply-To: <1233887607.16238.47.camel@vayu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, 2009-02-05 at 11:54 -0800, Mark Lord wrote:
>> How far back in (kernel release) time does this problem exist?
>> Candidate for -stable ?
> 
> Problem is present for a while now. But I don't think this is a common
> case scenario (as the issue happens only for the duration when we leave
> a cpu offline, and it should get fixed the moment that logical cpu is
> back online).
..

There is an existing bug (for some time now) in the kernel shutdown
for multi-CPUs.  Once in a while, perhaps every 20-30 halts,
the kernel fails to power-off the machine.

I've seen this problem here since 2.6.18 or so, on multiple different
machines with Core2duo and Core2quad processors.

It comes and goes, depending upon the kernel version and exact .config
that is used.  Any attempt to instrument it generally changes the race
conditions enough that it stops happening.

I'm just wondering if this bug might explain some of that.

Cheers
