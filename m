Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXFEOHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXFEOHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762450AbXFEOHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:07:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:39426 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762702AbXFEOHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:07:07 -0400
Message-ID: <46656E4E.5070108@tmr.com>
Date: Tue, 05 Jun 2007 10:08:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Stefan Seyfried <seife@suse.de>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
References: <4658B7DD.3060309@tmr.com> <20070605072355.GA5229@suse.de>
In-Reply-To: <20070605072355.GA5229@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried wrote:
> Hi,
>
> On Sat, May 26, 2007 at 06:42:37PM -0400, Bill Davidsen wrote:
>   
>> I was testing susp2disk in 2.6.21.1 under FC6, to support reliable computing
>> environment (RCE) needs. The idea is that if power fails, after some short
>> time on UPS the system does susp2disk with a time set, and boots back every
>> so often to see if power is stable.
>>     
>
> Interesting use case.
>  
>   
>> No, I don't want susp2mem until I debug it, console come up in useless mode,
>> console as kalidescope is not what I need.
>>     
>
> You probably need to reset the video mode. Try the s2ram workaround,
> specifically "-m".
>
>   
>> Anyway, I pulled the plug on the UPS, and the system shut down. But when it
>> powered up, it booted the default kernel rather than the test kernel, decided
>> that it couldn't resume, and then did a cold boot.
>>
>> I can bypass this by making the debug kernel the default, but WHY? Is the
>> kernel not saved such that any kernel can be rolled back into memory and run?
>>     
>
> The Kernel does nothing to the bootloader during suspend. The kernel does not
> even know that you are using a bootloader and how it might be configured.
>
>   
What I really expected is that what I was running would be save, and 
resume would restore what I was running and then jump back to where that 
suspended itself. Without having to address the issue of booting the 
"right" kernel, but having any functional kernel which was booted then 
restore whar was originally suspended.

 From discussion here, I conclude that "it could work that way but doesn't."
> Userland has to do this (and SUSE's pm-utils actually do. I thought the
> Fedora pm-utils also did, but i cannot say for sure). "Just" find out which
> entry in menu.lst corresponds to the currently running kernel, and preselect
> it for the next boot. It is doable.
>
> So it's a problem of your distro's userland (and if you did not use
> pm-hibernate to suspend, it is your very own problem).
>
> You could of course simply go for GRUB's "default saved" and "savedefault"
> feature, to always boot the last-booted kernel unless changed in the menu.
>   
I'm being very careful to avoid changing the default boot kernel. If the 
system suspends (ie. deliberately) I want to resume in the running 
kernel, but if it crashes I want the cold boot to bring up a known 
stable kernel, even though that may be lacking in features, have an old 
scheduler, etc.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

