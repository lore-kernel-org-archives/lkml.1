Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYCaPOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYCaPOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYCaPOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:14:36 -0400
Received: from rtr.ca ([76.10.145.34]:4442 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYCaPOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:14:35 -0400
Message-ID: <47F0FFD9.5030005@rtr.ca>
Date: Mon, 31 Mar 2008 11:14:33 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <200803311355.06487.oliver@neukum.org> <47F0F7A5.10604@rtr.ca> <200803311704.37256.oliver@neukum.org> <47F0FD8E.4090005@rtr.ca>
In-Reply-To: <47F0FD8E.4090005@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Oliver Neukum wrote:
>> Am Montag, 31. März 2008 16:39:33 schrieb Mark Lord:
>>
>>> One thing I just tried, was to unload all USB stuff before suspend,
>>> and reload on resume -- just stuck the commands into my 
>>> suspend/resume script.
>>>
>>> The machine has been 100% rock solid since then.
>>> So I think that definitely implicates USB.
>>
>> Yes. What happens if you unload only usbhid at that time?
> ..
> 
> Mmm.. interesting choice, there.  I'll try that.
> 
> There is another quirk on this machine that might confuse
> software that's not robust:  the internal Bluetooth adapter
> is USB connected, and I normally have it disabled (BIOS hotkey).
> So it normally is "not present".
> 
> But on any power-on / resume, it briefly powers up and becomes "present",
> and, after a second or two, the BIOS powers it down again, "not present".
> 
> Just long enough for software to notice it and try talking to it.
> If that software is not carefully coded, it might get confused.
> 
> This has not been a problem before, but perhaps with the new USB 
> autosuspend code?
..

Speaking of which.. what's with this "broken" message?
I wonder if it could be at all related ?

kobject: 'hci_usb' (f89d2948): kobject_cleanup
kobject: 'hci_usb' (f89d2948): does not have a release() function, it is broken and must be fixed.
kobject: 'hci_usb' (f89d2948): auto cleanup 'remove' event
kobject: 'hci_usb' (f89d2948): kobject_uevent_env
kobject: 'hci_usb' (f89d2948): fill_kobj_path: path = '/module/hci_usb'
kobject: 'hci_usb' (f89d2948): auto cleanup kobject_del
kobject: 'hci_usb': free name

