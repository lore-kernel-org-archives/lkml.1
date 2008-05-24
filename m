Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbYEXWem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbYEXWem (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762089AbYEXWef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:34:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:38564 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761783AbYEXWee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AivA3RhIAL+uxdMqqpQ5kbB5DAvvUTn3zxssljE65uM+C7cWh8Bert1WM/r7STV1COkCeccSyNobQZAI76i9V6Vu6+9ZhQz/odHefwlhWmNAW2XOla1HA0bEhy0pQtFaOXAeyOcmxMUlejrqVWpGBqdJKJL5MvrhZV1PwJG8fX4=
Message-ID: <7b9198260805241534s1a548e16i583742db92be3789@mail.gmail.com>
Date: Sat, 24 May 2008 23:34:33 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "Greg KH" <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
       "Uwe Kleine-K??nig" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <20080523055527.GA28963@digi.com>
	 <20080523104454.4e2af6ec@bluebox.local>
	 <20080523091009.GA22821@digi.com>
	 <20080523120308.7bec1e1c@bluebox.local>
	 <20080523105604.GA23800@digi.com>
	 <20080523135557.27fe4855@bluebox.local>
	 <20080524044354.GA8129@suse.de>
	 <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/24 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 23 May 2008, Greg KH wrote:
>
>> On Fri, May 23, 2008 at 01:55:57PM +0200, Hans J. Koch wrote:
>> > Sometimes it is necessary to enable/disable the interrupt of a UIO device
>> > from the userspace part of the driver. With this patch, the UIO kernel driver
>> > can implement an "irqcontrol()" function that does this. Userspace can write
>> > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
>> > UIO core will then call the driver's irqcontrol function.
>>
>> Why not just a new sysfs file for the uio device, irq_enabled, or
>> something like that?  That way our main read/write path is left alone.

Hi,

> It makes a certain amount of sense to use write. You hold the device
> file descriptor anyway for the read (wait for interrupt) operation,
> so using the same file descriptor is not a too bad idea:

What do you think about my ioctl idea, earlier in the thread?

>    while (!stop) {
>
>        /* wait for interrupt */
>        read(fd);
>
>        do_stuff();
>
>        /*reenable interrupt */
>        write(fd);
>    }

So, instead of write, you'd use ioctl(fd, ...).

> I thought about using a sysfs entry for a while, but looking at the
> actual use case made the write() solution a more natural choice.

I thought ioctl would be more natural, as [en,dis]abling interrupts is
a "controlling" operation :-)

> Thanks,
>
>        tglx

-- 
Tom Spink
