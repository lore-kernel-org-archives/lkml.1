Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYDNTRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYDNTRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYDNTQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:16:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56401 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYDNTQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:16:49 -0400
Message-ID: <4803AD91.5020001@firstfloor.org>
Date: Mon, 14 Apr 2008 21:16:33 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
References: <20080411210022.GJ11962@parisc-linux.org>	 <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org>	 <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org>	 <20080413070833.GC19773@elte.hu> <20080413125758.GQ11962@parisc-linux.org>	 <20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com>	 <1208190749.7375.10.camel@twins>  <87d4osuy6r.fsf@basil.nowhere.org> <1208195673.7164.2.camel@twins>
In-Reply-To: <1208195673.7164.2.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-04-14 at 19:46 +0200, Andi Kleen wrote:
>   
>> Peter Zijlstra <peterz@infradead.org> writes:
>>     
>>> Yeah, I would open code it.  But this is indeed a sane usage of the
>>> counting semaphore because there is no priority inversion.
>>>       
>> But when you open code that, how is it different from just having
>> semaphores? 
>>     
>
> Because we can then eventually get rid of semaphores, so those people
> cannot mistakenly use them. Its just too easy to create prio inversion
> with them around.
>   

But then you end up with lots of likely subtly buggy open coded
implementations. Also not good.

For me it sounds like you just want to rename semaphores to some other
name that people don't use them for normal locking?

-Andi



