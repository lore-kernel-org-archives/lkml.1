Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbXEQUyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbXEQUyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXEQUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:54:25 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:42728 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbXEQUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:54:24 -0400
In-Reply-To: <464CB460.40905@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org> <464CB071.5050504@ru.mvista.com> <9095839480a9686d9c40aa6143edb804@kernel.crashing.org> <464CB460.40905@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <97d47c2261fe9cd3f1a6c864278a6ab6@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: tglx@linutronix.de, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Thu, 17 May 2007 22:53:49 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Otherwise, when the contents of DEC0 change, the exception effects 
>>> of the Decrementer become consistent with the new contents of the 
>>> Decrementer reasonably soon after the change.
>
>> And that is guaranteed on all PowerPC as far as I can see.
>> The main thing is that a decrementer exception won't go
>> away until the high bit becomes 0.
>
> On both POWER4 and POWER4+, the Decrementer must be implemented such 
> that requirements 1 to 3 below are satisfied. On POWER4, requirements 
> 4 and 5 must also be satisfied.

<snip>

> 4. Whenever bit 0 of the Decrementer changes from 0 to 1, an interrupt 
> request is signaled. If multiple Decrementer interrupt requests are 
> received before the first can be reported, only one interrupt is 
> reported. The occurrence of a Decrementer interrupt cancels the 
> request.
>
> 5. If the Decrementer is altered by software and the contents of bit 0 
> are changed from 0 to 1, an interrupt request is signaled.

 From the POWER ISA 2.03, the latest public version of the
architecture definition:

	When the contents of DEC32 change from 0 to 1, a Decrementer
	exception will come into existence within a reasonable period
	or time. When the contents of DEC32 change from 1 to 0, an
	existing Decrementer exception will cease to exist within a
	reasonable period of time, but not later than the completion
	of the next context synchronizing instruction or event.

>    (4) clearly contradicts your point.

Yes, on some implementations there can be other conditions that
make a decrementer exception go away; there is no contradiction
here (thankfully).  My wording was sloppy.

> I don't mind changing #ifdef though (so it'll cover all non Book E 
> cases)

That was exactly my point; thank you.


Segher

