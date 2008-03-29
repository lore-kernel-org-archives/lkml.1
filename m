Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYC2D65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYC2D65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYC2D6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:58:49 -0400
Received: from rtr.ca ([76.10.145.34]:2996 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbYC2D6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:58:49 -0400
Message-ID: <47EDBE77.2040908@rtr.ca>
Date: Fri, 28 Mar 2008 23:58:47 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
References: <20080327160700.GB828@suse.de>	<Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>	<47EC50A3.5070304@rtr.ca> <20080327.201202.163153963.davem@davemloft.net> <47EC8646.3050405@rtr.ca> <47EC8793.2040508@rtr.ca> <47EC8AC3.7080002@rtr.ca>
In-Reply-To: <47EC8AC3.7080002@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Mark Lord wrote:
>>>
>>> When I rebuilt with all debug stuff on, the kernel was worse than
>>> before, and just gave the "black screen of nothing" on resume,
>>> with a hung system.
>>>
>>> At least before the system didn't hang.
>>>
>>> Now I've just booted with a differently configured kernel,
>>> with only about half of the debug flags turned on.
>>> This one resumes from suspend, and *with* working USB too.
>>>
>>> Ugh. Gotta love it when the bug is so subtle that turning on
>>> the debug flags makes it (1) get worse, and/or (2) get cured.
>>>
>>> Here's the abbreviated diff between broken (no USB on resume, no hang),
>>> and working (good USB, no hang) .config files.
>> ..
>>> -CONFIG_RTC_CLASS=y
>>> +# CONFIG_RTC_CLASS is not set
>>
>> Mmm.. also had the RTC conflict resolved in that one.
>> Time to try another kernel with just the RTC change now.
> ..
> 
> Okay, that might be it.  I've booted and am running without debug flags again.
..

An update:  still mostly stable now.
But I have seen one resume failure on this machine since then,
and that's not "normal" -- suspend/resume are normally rock solid.

My other pure Intel Dell X1 notebook has also hung a couple
of time during startup -- usually with "switched to high resolution"
messages near-last on the the screen.  There's a long standing bug
to do with that stuff, which I first reported back in 2.6.20 (or .21).
Back then, it was kernel .config dependent, and has never been tracked down.

Maybe the same thing here, maybe not.

Cheers
