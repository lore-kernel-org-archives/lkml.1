Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXKUO6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXKUO6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXKUO6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:58:39 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:52669 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXKUO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:58:38 -0500
MIME-Version: 1.0
Date: Wed, 21 Nov 2007 08:58:33 -0600
From: Felipe Balbi <me@felipebalbi.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: Re: USB deadlock after resume
In-Reply-To: <d9def9db0711210642h23db950vdc0fe1b9802e3e8b@mail.gmail.com>
References: <d9def9db0711210642h23db950vdc0fe1b9802e3e8b@mail.gmail.com>
Message-ID: <dd6afcb038a38716f46887681f05f367@felipebalbi.com>
User-Agent: FelipeBalbi.com Webmail
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Nov 2007 15:42:43 +0100, "Markus Rechberger"
<mrechberger@gmail.com> wrote:
> On 11/21/07, Markus Rechberger <mrechberger@gmail.com> wrote:
>> On 11/21/07, Oliver Neukum <oliver@neukum.org> wrote:
>> > Am Mittwoch 21 November 2007 schrieb Markus Rechberger:
>> > > On 11/21/07, Markus Rechberger <mrechberger@gmail.com> wrote:
>> > > > On 11/21/07, Mark Lord <lkml@rtr.ca> wrote:
>> > > > > Markus Rechberger wrote:
>> > > > > > Hi,
>> > > > > >
>> > > > > > I'm looking at the linux uvc driver, and noticed after
> resuming my
>> > > > > ..
>> > > > >
>> > > > > Pardon me.. what is the "uvc" driver?  Which module/source file
> is
>> > that?
>> > > > >
>> > > >
>> > > > http://linux-uvc.berlios.de/ it's not yet included in the kernel
>> > > > sources although many distributions already ship it.
>> > > > A "dry" run putting the device into sleep mode works fine (I added
> a
>> > > > proc interface for calling those suspend/resume function).
>> > > >
>> > >
>> > > it's not just usb_set_interface that hangs actually.
>> > > It seems to hang at
>> > >
>> > > wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
>> > >
>> > > in drivers/usb/core/urb.c after resuming. I disabled access to the
> usb
>> > > subsystem in the uvc driver, although connecting any other usb
> storage
>> > > fails too, just at the same point.
>> >
>> > Which URB is usb_kill_urb() called for?
>> >
>>
>> it's the usb_control_message which calls usb_kill_urb if I haven't got
>> it wrong. (if you're looking for some other information please let me
>> know)
>> Although, I got a bit further with it. The error seems to happen
>> earlier already.
>> If I load the driver, and do not access the device after suspending
>> all usb_control commands fail with -71 eproto.
>>
>> Reloading the driver doesn't help at tht point, only reconnecting the
>> device does.
>>
>> The data is transfered using bulk transfer.
>>
> 
> Do you know any good way for performing a softreset within the driver?
> The video application should get a continuous datastream after
> resuming the notebook, so the driver shouldn't be unloaded.
> The driver also keeps a list of previous camera settings which should
> be set up again after resuming. Stopping the video application and
> reattaching the device using ACPI (this board supports reconnecting
> the device using ACPI) should be avoided.

When you suspend, you cut off vbus (afaik, correct me if I'm wrong), which
means your device will get disconnected. One way to avoid this is enabling
CONFIG_USB_PERSIST and trying with that on.

You should also disable auto_suspend for this device. It won't work ok
after
that probably.

> 
> Markus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Best Regards,

Felipe Balbi
http://felipebalbi.com
me@felipebalbi.com

