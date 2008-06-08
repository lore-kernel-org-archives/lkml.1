Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbYFHKTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbYFHKTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 06:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbYFHKT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 06:19:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:45707 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbYFHKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o8L8IenUaUppJxlUOi9mK5WgESXM/yuFiPjHgt32TMWtPPDR/JYn7FNYvOErBOOJ2f
         uiUzTK0kAXCAjwQNjWXFzdsAzFmnltufkqPNKaIPAbRI37hBeiOgFEtfoLIYSRr0QQVH
         trtz3Vbku29iGADQC1PKS9euihAJTtV5x+qu0=
Message-ID: <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com>
Date: Sun, 8 Jun 2008 19:19:25 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, lethal@linux-sh.org, tglx@linutronix.de
In-Reply-To: <20080605112744.GB3198@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
	 <20080604101144.GA3207@local>
	 <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
	 <20080605090916.GA3198@local>
	 <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com>
	 <20080605112744.GB3198@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 8:27 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Thu, Jun 05, 2008 at 06:46:35PM +0900, Magnus Damm wrote:
>> On Thu, Jun 5, 2008 at 6:09 PM, Hans J. Koch <hjk@linutronix.de> wrote:
>> > On Thu, Jun 05, 2008 at 10:25:27AM +0900, Magnus Damm wrote:
>> >> On Wed, Jun 4, 2008 at 7:11 PM, Hans J. Koch <hjk@linutronix.de> wrote:
>> >> > On Wed, Jun 04, 2008 at 03:08:26PM +0900, Magnus Damm wrote:
>> >> >> From: Magnus Damm <damm@igel.co.jp>
>> >> >>
>> >> >> This patch adds a "Unique IRQ Mode" to the uio_pdrv UIO platform driver.
>> >> >> In this mode the user space driver is responsible for acknowledging and
>> >> >> re-enabling the interrupt. Shared interrupts are not supported.
>> >> >
>> >> > I still don't see any gain in this. This only works for embedded
>> >> > devices, so a user has to setup hardware specific code in his board
>> >> > support anyway.
>> >>
>> >> Exactly what in my patch makes this platform driver only suitable for
>> >> embedded devices?
>> >
>> > You assume the interrupt is not shared. You can never do that on a
>> > normal x86 PC, for example. E.g. for a PCI card you don't know which irq
>> > it'll get and if it is shared or not.
>>
>> So your main objection against this patch is that you cannot use it
>> with shared interrupts?
>
> I think I've explained my objections detailed enough.

It's still unclear to me. Please make a brief summary of your objections.

>> >> I don't think the board support level is the
>> >> proper place for this code.
>> >
>> > You have to write code there anyway, e.g. code that configures your GPIO
>> > as input, makes it generate interrupts and so on. And of course, you
>> > have to setup your platform device as well. If you simply add the irq
>> > handler, you can use uio_pdrv as-is. And if you _know_ that on your
>> > platform the irq is not shared, this might really be a one-liner that
>> > simply calls irq_disable. That's OK in board specific code, but not in a
>> > generic driver.
>>
>> Ever heard about system on chip?
>
> ATM, I work with iMX31 and AT91SAM9263, before that I had a PXA270,
> can't remember what was before that...
> So yes, I've heard of SoC.
>
>> Not all platform devices need board
>> specific setup.
>
> If it's a device within the SoC, you won't use UIO for that. If you did,
> your platform would depend on certain userspace software which is simply
> crap. And devices outside the SoC are board specific.

Why wouldn't we use UIO for device within the Soc? I've been doing
that for quite some time now.

>> >> The patch contains no board specific code,
>> >> and it is independent of both architecture and cpu model.
>> >
>> > Every platform device driver depends on board support.
>>
>> Is that so? I suggest that you have a look at the mfd drivers and think again.
>
> All I said about board support also applies to platform support files
> like at91sam9263_devices.c, I'm simply talking about the file where you
> define your struct platform_device.

Oh, I see. That's cpu specific code in my mind.

>> >> > So, NAK to this until somebody convinces me that I completely missed the
>> >> > point.
>> >>
>> >> We can reuse this driver for _many_ different SuperH processor models.
>> >> Most of these processor models even have more than one hardware block
>> >> that can be exported to user space using this uio_pdrv driver in
>> >> "Unique IRQ Mode". There is nothing board specific with this at all,
>> >> so yes, I think you are missing the point.
>> >
>> > First, I won't accept anything that changes the current UIO behaviour.
>> > If uio_info->irq is not set, then uio_register_device will fail. That's
>> > it. Your patch redefines the meaning of irq-not-set if uio_pdrv is used.
>>
>> How is this changing the UIO behavior? I'm modifying the uio_pdrv
>> driver, which is a driver that you didn't even write yourself.
>
> uio_pdrv is a generic driver, so I consider it part of the UIO
> framework. It adds new possibilities for authors of UIO platform device
> drivers (which are the vast majority of all UIO drivers). It is not just
> another UIO driver, but part of the system. It'll appear in UIO
> documentation, I'll explain it in future UIO presentations, and so on.
>
> And I consider it my job to make sure that such generic code is clean,
> obvious, and consistent.

Would you like me to write longer comments? Or some slides?

>> And yet
>> you seem to have very strong feelings against this patch.
>
> I explained why. My reasons are purely technical, please don't take this
> as a personal offense.

No offense taken. But I can't really see your technical arguments. If
something in my code is unclear please ask before NAK.

> Unfortunately, I'm one of the two UIO maintainers, so I feel obliged to
> review your patch and give my opinion. That doesn't mean I'm
> the big boss who makes the final decision. I can be critized and
> overridden. If Greg loves your patch and merges it, fine. Try it.

Maybe I will. =)

Thank you.

/ magnus
