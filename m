Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbZLJW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbZLJW2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761969AbZLJW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:28:39 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:40645 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761968AbZLJW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:28:38 -0500
Message-ID: <4B21760F.1090206@ahsoftware.de>
Date: Thu, 10 Dec 2009 23:28:31 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <Pine.LNX.4.44L0.0911181119240.3036-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911181119240.3036-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.11.2009 17:22, schrieb Alan Stern:

> You can unbind ehci-hcd from the controller by writing the controller's
> name to the "unbind" attribute in the appropriate sysfs directory.  For
> example, on my system:
>
> # ls /sys/bus/pci/drivers/ehci_hcd
> 0000:00:1d.7  0000:01:00.2  0000:01:01.2  bind  module  new_id  uevent
> unbind
> # echo -n 0000:00:1d.7>/sys/bus/pci/drivers/ehci_hcd/unbind
>
> Then to rebind the driver, write the device name to the "bind"
> attribute:
>
> # echo -n 0000:00:1d.7>/sys/bus/pci/drivers/ehci_hcd/bind

Thanks, that works nicely and takes away the need to reboot when using a 
stock F11 kernel and the problem occurs.

I've recently discovered that I can provoke the error too, when using dd 
on an usb-dvd writing the output to an usb-hdd. So the topic of this 
thread is now certainly wrong.

And because I'm still having the problem using Kernel 2.6.31.7 and 
2.6.32, I've written bug #14785. It's easier to attach long logs there.

Kind regards,

Alexander Holler
