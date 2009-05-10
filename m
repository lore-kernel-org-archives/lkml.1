Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZEJSie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZEJSie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZEJSiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:38:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:64535 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbZEJSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:38:22 -0400
Message-ID: <4A071F1A.1090702@codemonkey.ws>
Date: Sun, 10 May 2009 13:38:18 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws> <4A0570B1.30401@novell.com>
In-Reply-To: <4A0570B1.30401@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Anthony Liguori wrote:
>   
>
>>   I'm surprised so much effort is going into this, is there any
>> indication that this is even close to a bottleneck in any circumstance?
>>     
>
> Yes.  Each 1us of overhead is a 4% regression in something as trivial as
> a 25us UDP/ICMP rtt "ping".m 
>   

It wasn't 1us, it was 350ns or something around there (i.e ~1%).

> for request-response, this is generally for *every* packet since you
> cannot exploit buffering/deferring.
>
> Can you back up your claim that PPC has no difference in performance
> with an MMIO exit and a "hypercall" (yes, I understand PPC has no "VT"
> like instructions, but clearly there are ways to cause a trap, so
> presumably we can measure the difference between a PF exit and something
> more explicit).
>   

First, the PPC that KVM supports performs very poorly relatively 
speaking because it receives no hardware assistance  this is not the 
right place to focus wrt optimizations.

And because there's no hardware assistance, there simply isn't a 
hypercall instruction.  Are PFs the fastest type of exits?  Probably not 
but I honestly have no idea.  I'm sure Hollis does though.

Page faults are going to have tremendously different performance 
characteristics on PPC too because it's a software managed TLB. There's 
no page table lookup like there is on x86.

As a more general observation, we need numbers to justify an 
optimization, not to justify not including an optimization.

In other words, the burden is on you to present a scenario where this 
optimization would result in a measurable improvement in a real world 
work load.


Regards,

Anthony Liguori
> We need numbers before we can really decide to abandon this
> optimization.  If PPC mmio has no penalty over hypercall, I am not sure
> the 350ns on x86 is worth this effort (especially if I can shrink this
> with some RCU fixes).  Otherwise, the margin is quite a bit larger.
>
> -Greg
>
>
>
>   

