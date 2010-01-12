Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671Ab0ALC2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0ALC2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612Ab0ALC2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:28:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:49490 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab0ALC2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:28:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="231649821"
Subject: Re: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic
 id != 0 can boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <alpine.LFD.2.00.1001111641180.17145@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>  <20100111045326.GA11725@in.ibm.com>
	 <1263245985.2859.497.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1001111454060.17145@localhost.localdomain>
	 <1263253513.2859.833.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1001111641180.17145@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 18:27:04 -0800
Message-Id: <1263263224.2855.274.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 16:46 -0800, Linus Torvalds wrote:
> 
> On Mon, 11 Jan 2010, Suresh Siddha wrote:
> > 
> > Linus, We are in -rc3 and thought we have few days atleast to sort it
> > out and post the correct fix to the problem, rather than do a quick
> > revert (as we know that the current code is not fundamentally broken).
> 
> You seem to think that -rc3 is "early". It's not. 
> 
> Also, you seem to dismiss the fact that the commit has been reported to 
> break real machines, and then you try to blame the MACHINE instead of 
> blaming the commit. 

Linus, I spent two hours in the morning reviewing code/testing this on
different platforms (removing/re-arranging sockets on different
platforms so that I am closer to Ananth's failing config) and I haven't
seen the failure. Even Yinghai tried it separately and couldn't see this
on his platform. 

And From Ananth's report, we do know there is a problem some where. I am
not blaming his MACHINE. I was trying to understand what is specific to
his platform/configuration, so that I can better understand where the
issue is. Sorry if my words sounded like blaming. Didn't really mean to.

> That makes me irritated. I don't understand why it's so hard for people to 
> see that if there is a problem IT NEEDS TO BE FIXED.
> 
> The default action should not be "let's keep the problem and then try to 
> figure it out". No, the default action is "let's FIX the problem first!"
> 
> Once the problem is fixed, you have as much time as you want to try to 
> figure out why it happened in the first time. But we do _not_ just keep a 
> broken kernel around because you don't know what is broken. 

Ok. I read the problem report today morning and after my testing, I had
some confidence that this is a not a widespread problem. So thought I
will take a day more to get more analysis/information from Ananth before
I ask you/x86 folks for revert. Didn't really mean to hold on to the
broken fix. And hence the ack when you wanted to revert.

> Quite frankly, I hope the "re-submit" is not actually that. There's no 
> point in submitting something like this again. I still think that the 
> whole "let's have different code-paths for Intel and AMD" thing is just 
> plain crazy. There's no reason to do this.
> 
> For example, quite apart from the actual problem report, your patch causes 
> the x86-64 code to simply become UGLIER AND LESS MAINTAINABLE. That whole 
> intel-vs-amd issue is total black magic, with no comments and no reason.

I will work with Yinghai who first observed the failure on AMD platform
and introduced this fix.

commit e0da33646826b66ef933d47ea2fb7a693fd849bf
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sun Jun 8 18:29:22 2008 -0700

    x86: introduce max_physical_apicid for bigsmp switching
    
    a multi-socket test-system with 3 or 4 ioapics, when 4 dualcore cpus or
    2 quadcore cpus installed, needs to switch to bigsmp or physflat.
    
    CPU apic id is [4,11] instead of [0,7], and we need to check max apic
    id instead of cpu numbers.
    
    also add check for 32 bit when acpi is not compiled in or acpi=off.
    

> So no. I'm not going to take a resubmission. 

I will work with Yinghai and Ananth to come up with a clean solution.

thanks,
suresh

