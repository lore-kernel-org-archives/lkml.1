Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbXE2STS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbXE2STS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXE2STK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:19:10 -0400
Received: from rtr.ca ([64.26.128.89]:1560 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbXE2STJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:19:09 -0400
Message-ID: <465C6E9B.2040605@rtr.ca>
Date: Tue, 29 May 2007 14:19:07 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org> <465C608E.3040303@rtr.ca> <465C64D1.3030604@rtr.ca> <alpine.LFD.0.98.0705291048020.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705291048020.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 29 May 2007, Mark Lord wrote:
>> Okay, just to make it trivial,
>> I've narrowed it down to only this commit from Alan Stern:
>>
>> 7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend workqueue
>> thread freezable
> 
> Heh. Have I mentioned how much I *hate* those kernel threads being frozen?
> 
> Just for fun, could you try if the patch that just rips out the freezer 
> calls from the STR code just fixes the problem too (instead of reverting 
> that commit?)
> 
> It was done by Matthew Garrett <mjg59@srcf.ucam.org>, and you should be 
> able to find it in the kernel archives under the subject
> 
> 	Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
> 	Message-ID: <20070527184402.GA21161@srcf.ucam.org>

Okay, I tried that one, but the machine just hung on the VGA console screen
at suspend time.  No alt-sysrq or anything.  Power-cycled it to recover.

> and it would be interesting to hear if that just solves the problem for 
> you too.
> 
> There's a different (but related to all the same freezer problems) patch 
> by Rafael Wysocki <rjw@sisk.pl>:
> 
> 	Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
> 	Message-Id: <200705291415.31970.rjw@sisk.pl>

I'll hunt for Rafael's patch next.
