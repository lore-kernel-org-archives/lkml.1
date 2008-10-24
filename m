Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYJXPbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYJXPbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYJXPax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:30:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYJXPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:30:52 -0400
Message-ID: <4901EA14.9070300@zytor.com>
Date: Fri, 24 Oct 2008 08:30:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
References: <1224712846.13953.37.camel@alok-dev1> <20081022221316.GW12825@one.firstfloor.org> <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com> <20081024072320.GE27492@one.firstfloor.org>
In-Reply-To: <20081024072320.GE27492@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> That is at least to some degree nonsense, simply because we are all well 
>> down that particular "slippery slope": we have hardware blacklists and 
> 
> The big difference is that hardware cannot be easily fixed, hypervisors
> are just software and can as simply as Linux. Also there are at least 
> standardized simple ways to detect hardware and platforms using standard 
> enumeration interfaces like PCI or DMI, while each Hypervisor detection 
> seems to need huge amounts of custom (and likely fragile) complicated code.
> iirc there was a vmware detection patch around and it was disgusting iirc.
> 

BIOSes are also just software, and we have to deal with bugs in them 
*all the time*.  The reality is that we're going to have to deal with 
both vendor and user reluctance to upgrade, and therefore have to deal 
with brokenness in the field.  As far as detection code is concerned, I 
certainly have pushed back on the most disgusting (and broken) attempts, 
as well insisted that the code be properly centralized.

> Also I think this concept of "not PV, but then again a little"
> concept that is mandated here is not a useful one.
 >
> Either do a proper PV interface and then just write a custom
> clock driver and paravirt ops interface to make everything really fast,
> or just use the direct hardware interface and fix the hypervisor
> to do it properly.

It's functionally equivalent to hardware workarounds.  There is always a 
judgement call when something should be forked off into a separate 
driver, which is exactly what this amounts to.

> Especially VMware has this already (although 32bit only).
> 
> Ok the tsc_sync issue is borderline, but that one seems 
> to be more a case of tweaking the existing algorithms
> to be a little more tolerant.

That is a possibility, but that is a technical issue versus a 
pseudo-philosophical issue.  However, there are clearly a few different 
problems here with the start-and-stop nature of the virtual environment 
versus the needs of physical environments, and it's not clear to me that 
they are inherently compatible, or whether that would entail dangerous 
compromises.

	-hpa

