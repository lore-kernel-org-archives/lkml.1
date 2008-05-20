Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbYETKFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbYETKFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbYETKBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:01:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765648AbYETKB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:01:28 -0400
Message-ID: <4832A173.6020203@firstfloor.org>
Date: Tue, 20 May 2008 12:01:23 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com>
In-Reply-To: <20080520015723.GD30034@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Mon, May 19, 2008 at 04:52:01PM +0200, Mikael Pettersson wrote:
>>> But we can
>>> use some what similar magic, if the fxsave/fxrstor give away
>>> some of the fields at the end of fxsave image (today it is reserved
>>> and ignored during fxsave/fxrstor) for software use.
>>> We can then use these fields at the end of fpstate, to indicate the presence of
>>> xstate. But this requires some architecture changes like giving
>>> away this space for SW use. We can take this to architects and
>>> see what they think.
>> If the HW doesn't store anything valuable there, we could store
>> SW flags/cookies there on signal delivery, and clear them before
>> fxrstor (unless the HW is known to ignore those fields).
>> But it depends on how forgiving the HW is.
> 
> Ok. CPU folks are planning to make some of the bytes at the end of fxsave
> image, SW usable.

Are they always zeroed in earlier CPUs though?  If not that wouldn't
work 100% reliably because whatever cookie you put in could have been
there before by chance.

I don't see anything in the SDM guaranteeing zeroing.

-Andi
