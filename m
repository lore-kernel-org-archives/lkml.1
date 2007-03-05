Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXCES3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXCES3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXCES3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:29:10 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:58171 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbXCES3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:29:09 -0500
Message-ID: <45EC616F.6090809@simon.arlott.org.uk>
Date: Mon, 05 Mar 2007 18:29:03 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
  scheduler
References: <200703042335.26785.a1426z@gawab.com> <200703050849.29674.kernel@kolivas.org> <45EB45F7.3050208@simon.arlott.org.uk> <200703050927.52563.kernel@kolivas.org>
In-Reply-To: <200703050927.52563.kernel@kolivas.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/07 22:27, Con Kolivas wrote:
> On Monday 05 March 2007 09:19, Simon Arlott wrote:
>> If I run glxgears, thunderbird/firefox become really slow to
>> respond/display and cpu usage isn't even at 100%. I had thunderbird lagging
>> on keyboard character repeat earlier but can't reproduce that now even with
>> glxgears - however firefox lags really badly on keyboard input with
>> glxgears running.
> 
> Hi Simon
> 
> You're hitting a nasty udev bug here that is unrelated to the cpu scheduler 
Yes, I've already reported this.

> and almost certainly responsible for your bad behaviour. 
What? How do you make the leap from lockdep output on boot to my experience of 
slow interactive response?

> Also this patch was actually for 2.6.20 and you seem to have applied it to 
> 2.6.21-rc2. I haven't even checked that it cleanly applies to that kernel.

It doesn't, a one line fix from Ingo conflicts (and a comment that was changed).
7355690ead6d61f6344072ae61060f985060da29 [PATCH] sched: fix SMT scheduler bug
72fd4a35a824331d7a0f4168d7576502d95d34b3 [PATCH] Numerous fixes to kernel-doc info in source files.

I have reverted your patch and the laggy behaviour remains when running 
glxgears (in fact it seems a bit worse), I don't know about the thunderbird 
lag while typing since I can't easily reproduce it but I don't recall it ever 
happening before. So, your patch isn't the cause of a serious slowdown when 
running glxgears in the background (although it doesn't improve the situation 
much). It looks like it just slows down X in general rather than using much 
CPU.

-- 
Simon Arlott

