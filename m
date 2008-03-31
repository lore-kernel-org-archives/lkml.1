Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbYCaPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbYCaPE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYCaPEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:04:50 -0400
Received: from rtr.ca ([76.10.145.34]:1868 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYCaPEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:04:49 -0400
Message-ID: <47F0FD8E.4090005@rtr.ca>
Date: Mon, 31 Mar 2008 11:04:46 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <200803311355.06487.oliver@neukum.org> <47F0F7A5.10604@rtr.ca> <200803311704.37256.oliver@neukum.org>
In-Reply-To: <200803311704.37256.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Montag, 31. März 2008 16:39:33 schrieb Mark Lord:
>
>> One thing I just tried, was to unload all USB stuff before suspend,
>> and reload on resume -- just stuck the commands into my suspend/resume script.
>>
>> The machine has been 100% rock solid since then.
>> So I think that definitely implicates USB.
> 
> Yes. What happens if you unload only usbhid at that time?
..

Mmm.. interesting choice, there.  I'll try that.

There is another quirk on this machine that might confuse
software that's not robust:  the internal Bluetooth adapter
is USB connected, and I normally have it disabled (BIOS hotkey).
So it normally is "not present".

But on any power-on / resume, it briefly powers up and becomes "present",
and, after a second or two, the BIOS powers it down again, "not present".

Just long enough for software to notice it and try talking to it.
If that software is not carefully coded, it might get confused.

This has not been a problem before, but perhaps with the new USB autosuspend code?

>> Still want USB_SUSPEND=n ?  Please explain.
> 
> It looks like you are hanging in the kthread for autosuspending.
> Compiling that out should confirm it.
..

Okay, and once we see that it works fine:  then what?
