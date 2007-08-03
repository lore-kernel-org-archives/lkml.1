Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbXHCGyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbXHCGyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbXHCGyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:54:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbXHCGyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:54:01 -0400
Message-ID: <46B2D0C6.5010409@netcom.eu>
Date: Fri, 03 Aug 2007 08:52:54 +0200
From: David Engraf <david.engraf@netcom.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
References: <46B1844B.8090007@netcom.eu> <Pine.LNX.4.44L0.0708021009460.3611-100000@iolanthe.rowland.org> <20070802164329.GD28721@suse.de>
In-Reply-To: <20070802164329.GD28721@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19W46iawa2sWX1jYITLPjkScbnOvL9uhBqc+to
 Mmu3+XE0lxwoDKnu7Jbs2IBLIVMoXW8Y7QAZiiR7nWGeFbccmM
 kyClzclmSXB48ZoWWIrYw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH schrieb:
> On Thu, Aug 02, 2007 at 10:32:21AM -0400, Alan Stern wrote:
>   
>> On Thu, 2 Aug 2007, David Engraf wrote:
>>
>>     
>>> This would be solution too, but what if someone uses the uhci controller
>>> and don't want the
>>> ehci. So a single Kconfig flag wouldn't be enough, we have to add 3
>>> flags for uchi, ohci and
>>> ehci. I think this maybe a little bit difficult when configuring the kernel.
>>> The best solution would be when we could use the CONFIG_USB_xxxx_HCD
>>> flag, but it
>>> seems that some hardware has problems when we disable the handoff and
>>> let the BIOS
>>> control the usb controller. Do you know any of this hardware?
>>>       
>> The email messages are hidden in the depths of the linux-usb-devel 
>> archives.  Maybe you can find them by checking the Git history for 
>> drivers/usb/host/pci-quirks.c, finding the dates for patches that 
>> affected the handoff code, and then searching through the archives near 
>> those dates.
>>
>> IIRC the problems arose on some MIPS machines.  And I don't think the 
>> problem involved letting the firmware manage the USB controller; I 
>> think the problem came when the controller driver tried to do the 
>> handoff later on.
>>     
>
> It wasn't just MIPS.  IBM has a very popular blade system that has huge
> issues with this, and I think there are some other IBM systems based on
> the same BIOS that also do bad things if we don't grab the USB
> controller away from the BIOS as soon as possible (nasty interrupt and
> other messes happen...)
>
> thanks,
>
> greg k-h
>   
So we have hardware which has problems when we are not doing the
handoff, and hardware which has
problems when we are  doing the handoff...
What is the best way to solve the problem? Maybe a kernel parameter, a
config flag or an automatic
hardware dependent check of the system?
In fact it is hard to find a solution which works for both as long as
the hardware has this bugs.


Thanks


David Engraf

 

 
Netcom Sicherheitstechnik GmbH
Rheinallee 189
55120 Mainz
Tel: 	+49 6131 6305 0
Fax: 	+49 6131 6305 40
Email: 	david.engraf@netcom.eu

 
Sitz der Gesellschaft: Mainz
Registergericht: Amtsgericht Mainz, 14HRB3411
Geschäftsführer: Peter Otto

