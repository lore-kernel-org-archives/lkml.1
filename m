Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0BZFWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:22:05 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:50984 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0BZFWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G8jcD27jNgAdhceANxIhzfc8Mo2UMOh0imxm8r0uYxOsZ1Avg9UJxS1FgaYu6WfdCS
         SjJWj+rsaWC6xev+cl1QgLGe+gxnYdSgJQIZRnXGzoNDP6YwMBdBvV+uYureqmiuLqPr
         XsaqfnwSpuaEfnlK6KPSZlmTXrZfygFCbT8UM=
MIME-Version: 1.0
In-Reply-To: <4B85A9D3.6060709@maroy.hu>
References: <Pine.LNX.4.44L0.1002241137030.2436-100000@iolanthe.rowland.org>
	 <4B85A9D3.6060709@maroy.hu>
Date: Fri, 26 Feb 2010 13:21:51 +0800
Message-ID: <ff05f3d01002252121k2a757caexae13a8d919b2a170@mail.gmail.com>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 
	8087:0020
From: Edward Shao <laface.tw@gmail.com>
To: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ákos~

On Thu, Feb 25, 2010 at 6:36 AM, Ákos Maróy <akos@maroy.hu> wrote:
> Alan,
>
>> You can get more information if you enable CONFIG_USB_DEBUG in your
>> kernel configuration.  The most likely explanation is that the suspend
>> failed because one of the ports on that root hub issued a wakeup
>> request.
>
> I tried, and this is what I seem to be getting now:
>
>
> Feb 24 23:28:52 tonkachi kernel: [  348.733460] PM: Syncing filesystems ...
> Feb 24 23:28:52 tonkachi kernel: [  348.903106] done.
> Feb 24 23:28:52 tonkachi kernel: [  348.903123] Freezing user space
> processes ... (elapsed 0.00 seconds) done.
> Feb 24 23:28:52 tonkachi kernel: [  348.903808] Freezing remaining
> freezable tasks ... (elapsed 0.00 seconds) done.
> Feb 24 23:28:52 tonkachi kernel: [  348.903952] Suspending console(s)
> (use no_console_suspend to debug)
> Feb 24 23:28:52 tonkachi kernel: [  348.985903] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 24 23:28:52 tonkachi kernel: [  348.987274] PM: resume devices took
> 0.060 seconds
> Feb 24 23:28:52 tonkachi kernel: [  348.987371] Restarting tasks ...
> Feb 24 23:28:52 tonkachi kernel: [  348.988165] done.
>
>
> though I don't see the pm_op() error log anymore..
>
> would this make sense?
>
> actually, the whole USB susbsystem seems to be very fragile - I plug in
> a USB device, and the whole system freezes for about 5 seconds or more.
> then the device is registered (for example, a mouse). but I unplug and
> re-plug, and the device doesn't work anymore...

the whole system freezes for about 5 seconds or more?
I meet a very similar issue before on HP Envy 15 laptop when I plugged
usb device on xhci port.
My problem was BIOS still controlled xhci host controller.
Maybe you can try this patch.
http://markmail.org/message/vqcbzks4gnbrlir3

>
> or I plug in an external USB DVD drive - but if I unplug it, it is still
> listed in lsusb..
>
>
> Akos
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Best Regards,
Edward
