Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYIXKzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYIXKzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYIXKzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:55:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55633 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYIXKzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Kx3x/uu1fgQV6nDad21VTFubiouXV4GwQ6oK0X8LsQbvsnPwHsynwsqRYmgk2e7MH0
         +NPc+WZzbdovLyFLvJIChpRw4vJoV1vASrei49u8mKwXRaO5DTu7Kh0ahDz+zgITgbS/
         rfWLDhFDg5neFFsJLXHxwDUEBQbOyooAP6atA=
Message-ID: <48DA1CA5.20409@gmail.com>
Date: Wed, 24 Sep 2008 12:55:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
References: <Pine.LNX.4.44L0.0809181708500.17483-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0809181708500.17483-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2008 11:14 PM, Alan Stern wrote:
> On Wed, 17 Sep 2008, Jiri Slaby wrote:
>> I've found suspend on my desktop defunct in mmotm 2008-09-13-03-09 (opposing to
>> 2008-09-10-19-39).
>>
>> Dmesg says:
>>
>> uhci_hcd 0000:00:1d.1: PCI INT B disabled
>> pci_legacy_suspend(): usb_hcd_pci_suspend+0x0/0x3e0 returns -16
>> pm_op(): pci_pm_suspend+0x0/0xd0 returns -16
>> PM: Device 0000:00:1d.0 failed to suspend: error -16
>> PM: Some devices failed to suspend
> 
> The reason for this error is that the root hub wasn't already 
> suspended.  Was there a USB device plugged into that controller?

No:
/:  Bus 08.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M <----
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
    |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/3p, 12M
        |__ Port 1: Dev 3, If 0, Class=HID, Driver=usbhid, 12M
        |__ Port 1: Dev 3, If 1, Class=HID, Driver=usbhid, 12M
        |__ Port 2: Dev 4, If 0, Class=HID, Driver=usbhid, 1.5M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M


> Two days ago I ran 2.6.27-rc6 plus gregkh-all-2.6.27-rc6.patch from
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> 
> on my laptop, and it suspended with no problem.  Can you try the same 
> kernel?
> 
> If you still run into problems, post more of the dmesg log (with 
> CONFIG_USB_DEBUG enabled, of course!).

Hm, it doesn't work. 2 dmesgs from mmotm 2008-09-10-19-39 (without usb debug)
[ok] and -rc6+gkh-all (with usb debug) [fail]:
http://decibel.fi.muni.cz/~xslaby/dmesg_fail.hcd
http://decibel.fi.muni.cz/~xslaby/dmesg_ok.hcd

