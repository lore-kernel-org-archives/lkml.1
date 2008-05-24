Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYEXXBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYEXXBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 19:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYEXXA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 19:00:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:56370 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYEXXA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 19:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nv2I5dA+PL9UnYEvieKAbvSE7k470e7eMZQMWnfbbOvL+b6CKueo0KqJ+U/VRugSSpjleIrZ/YSjEk5RasvF1VafzjPeiGS23dqUQwVk+xRLDQ+Dg31pJKLoulEI7NE8JTxbfWEpoikCEo19s/mnx1lnhjx2opxSTZp54yW+Na0=
Message-ID: <7b9198260805241600m7a1c8dcva6cb6b41a4d2bacb@mail.gmail.com>
Date: Sun, 25 May 2008 00:00:55 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "Greg KH" <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
       "Uwe Kleine-K??nig" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0805250036481.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522192252.GB3226@local>
	 <20080523104454.4e2af6ec@bluebox.local>
	 <20080523091009.GA22821@digi.com>
	 <20080523120308.7bec1e1c@bluebox.local>
	 <20080523105604.GA23800@digi.com>
	 <20080523135557.27fe4855@bluebox.local>
	 <20080524044354.GA8129@suse.de>
	 <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de>
	 <7b9198260805241534s1a548e16i583742db92be3789@mail.gmail.com>
	 <alpine.LFD.1.10.0805250036481.3295@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/24 Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 24 May 2008, Tom Spink wrote:
>> 2008/5/24 Thomas Gleixner <tglx@linutronix.de>:
>> > It makes a certain amount of sense to use write. You hold the device
>> > file descriptor anyway for the read (wait for interrupt) operation,
>> > so using the same file descriptor is not a too bad idea:
>>
>> What do you think about my ioctl idea, earlier in the thread?
>
> I think it's a pretty bad idea.

<grin>

>
>> >    while (!stop) {
>> >
>> >        /* wait for interrupt */
>> >        read(fd);
>> >
>> >        do_stuff();
>> >
>> >        /*reenable interrupt */
>> >        write(fd);
>> >    }
>>
>> So, instead of write, you'd use ioctl(fd, ...).
>
> And what's the actual gain ?

Simpler implementation, simpler use and future-proofing (in the sense
that ->write is no longer tied to this operation)

>
>> > I thought about using a sysfs entry for a while, but looking at the
>> > actual use case made the write() solution a more natural choice.
>>
>> I thought ioctl would be more natural, as [en,dis]abling interrupts is
>> a "controlling" operation :-)
>
> Oh no. We are not going to open the bottomless pit of ioctls in
> UIO. Once we have an ioctl channel in place we have the same mess
> which we want to avoid in the first place.
>
> Also when a driver needs more than the obvious interrupt wait /
> control functions (which are pretty symetric btw.) aside of the
> mmapped access to the device then it does not belong into the category
> of an UIO driver.

Fair enough :-) symmetry is good.  This is pretty much the response I
got from Hans.

> Thanks,
>
>        tglx

-- 
Tom Spink
