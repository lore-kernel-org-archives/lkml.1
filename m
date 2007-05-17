Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXEQTvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXEQTvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXEQTvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:51:03 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:40087 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194AbXEQTvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:51:01 -0400
In-Reply-To: <464CB071.5050504@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org> <464CB071.5050504@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <9095839480a9686d9c40aa6143edb804@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, tglx@linutronix.de,
       mingo@elte.hu
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Thu, 17 May 2007 21:50:52 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +     * We must write a positive value to the decrementer to clear
>>> +     * the interrupt on the IBM 970 CPU series.  In periodic mode,
>>> +     * this happens when the decrementer gets reloaded later, but
>>> +     * in one-shot mode, we have to do it here since an event 
>>> handler
>>> +     * may skip loading the new value...
>
>> Nothing special about 970 here -- on *every* PowerPC,
>> a decrementer exception exists as long as the high
>> bit of the decrementer equals 1.  BookE is different
>> of course.  Some other CPUs might deviate from the
>> architecture as well.
>
>    Quoting "PowerPC Operating Environment Architecture":

<snip>

> Otherwise, when the contents of DEC0 change, the exception effects of 
> the Decrementer become consistent with the new contents of the 
> Decrementer reasonably soon after the change.

And that is guaranteed on all PowerPC as far as I can see.
The main thing is that a decrementer exception won't go
away until the high bit becomes 0.


Segher

