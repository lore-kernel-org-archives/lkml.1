Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbXCSU3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbXCSU3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXCSU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:29:33 -0400
Received: from main.gmane.org ([80.91.229.2]:36082 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXCSU3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:29:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [linux-pm] [2/6] 2.6.21-rc2: known regressions
Date: Mon, 19 Mar 2007 16:33:25 -0400
Message-ID: <45FEF395.9050409@tmr.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>	 <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il>	 <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>	 <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu>	 <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org>	 <20070309111957.GA3928@elf.ucw.cz>  <20070318160707.GC12673@elte.hu> <1174236045.6832.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-pm@lists.osdl.org,
       linux-usb-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-pm@lists.osdl.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <1174236045.6832.9.camel@localhost>
Cc: linux-pm@lists.osdl.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Gettys wrote:
> On Sun, 2007-03-18 at 17:07 +0100, Ingo Molnar wrote:
>> * Pavel Machek <pavel@ucw.cz> wrote:
>>
>>>> Some day we may have modesetting support in the kernel for some 
>>>> graphics hw, right now it's pretty damn spotty.
>>> Yep, that's the way to go.
>> hey, i wildly supported this approach ever since 1996, when GGI came up
>> :-/
>>
> 
> So wildly you wrote tons of code.... ;-).
> 
> More seriously, at the time, XFree86 would have spat in your face for
> any such thing.  Thankfully, times are changing.
> 
> Also more seriously, a somewhat hybrid approach is in order for mode
> setting: simple mode setting isn't much code and is required for sane
> behavior on crash (it is nice to get oopses onto a screen); but the full
> blown mode setting/configuration problem is so large that on some
> hardware, it is likely left best left to a helper process (not the X
> server).
> 
> Also key to get sane behavior out of the scheduler is to get the X
> server to yield (sleep in the kernel) rather than busy waiting when the
> GPU is busy; a standardized interface for this for both fbdev and dri is
> in order.  Right now, X is a misbehaving compute bound process rather
> than the properly interactive process it can/should/will be, releasing
> the CPU whenever the hardware is busy. Needless to say, this wastes
> cycles and hurts interactivity with just about any scheduler you can
> devise. It isn't as if this is hard; on UNIX systems we did it in 1984
> or thereabouts.

What you say sounds good, assuming that the cost of a sleep is less than 
the cost of the busy wait. But this may be hardware, the waits may be 
very small and frequent, and if it's hitting a small hardware window 
like retrace, delays in response will cause the time period to be missed 
completely. This probably less critical with very smart cards, many of 
us don't run them.
> 
> Of course, in 1996, XFree86 would have ignored any such interfaces, in
> its insane quest for operating system independent user space drivers
> requiring no standard kernel interfaces.... (it is the second part of
> this where the true insanity lay).
>                                   - Jim
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

