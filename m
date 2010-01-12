Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583Ab0ALAsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0ALAsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548Ab0ALAsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:48:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab0ALAsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:48:17 -0500
Date: Mon, 11 Jan 2010 16:46:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic id
 != 0 can boot
In-Reply-To: <1263253513.2859.833.camel@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.1001111641180.17145@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>  <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>  <20100110023015.GA2253@in.ibm.com>  <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>  <20100110102638.GA7838@elte.hu> 
 <20100111045326.GA11725@in.ibm.com>  <1263245985.2859.497.camel@sbs-t61.sc.intel.com>  <alpine.LFD.2.00.1001111454060.17145@localhost.localdomain> <1263253513.2859.833.camel@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Jan 2010, Suresh Siddha wrote:
> 
> Linus, We are in -rc3 and thought we have few days atleast to sort it
> out and post the correct fix to the problem, rather than do a quick
> revert (as we know that the current code is not fundamentally broken).

You seem to think that -rc3 is "early". It's not. 

Also, you seem to dismiss the fact that the commit has been reported to 
break real machines, and then you try to blame the MACHINE instead of 
blaming the commit. 

That makes me irritated. I don't understand why it's so hard for people to 
see that if there is a problem IT NEEDS TO BE FIXED.

The default action should not be "let's keep the problem and then try to 
figure it out". No, the default action is "let's FIX the problem first!"

Once the problem is fixed, you have as much time as you want to try to 
figure out why it happened in the first time. But we do _not_ just keep a 
broken kernel around because you don't know what is broken. 

> But if you want to revert, I have appended a patch to revert this, which
> has the correct subject, description etc atleast. I can work with Ananth
> and re-submit this for the next release.

Quite frankly, I hope the "re-submit" is not actually that. There's no 
point in submitting something like this again. I still think that the 
whole "let's have different code-paths for Intel and AMD" thing is just 
plain crazy. There's no reason to do this.

For example, quite apart from the actual problem report, your patch causes 
the x86-64 code to simply become UGLIER AND LESS MAINTAINABLE. That whole 
intel-vs-amd issue is total black magic, with no comments and no reason.

So no. I'm not going to take a resubmission. 

		Linus
