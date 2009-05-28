Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZE1ALp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZE1ALp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbZE1ALi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:11:38 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:39530 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284AbZE1ALh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iwsENtOxE29/uHpQ1G7jSwNzPLkrr4EXrCLJ1SMPuVOeDvTVFsdzqaykid4hp56nIE
         cJjK9XtVaZnJJ17DcSxwaSdGXAwIT1AnHu3dNW86A2Akb4J3t0C9gBLc6HqIrs7XfRad
         9lISAN9WhEtQmoUyCxYAA9dCLhWqZP4u8/2/E=
MIME-Version: 1.0
In-Reply-To: <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com>
References: <1243408083.13460.14.camel@debian-nb>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de>
	 <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
	 <20090527192909.GA32398@flint.arm.linux.org.uk>
	 <20090527205218.GA5591@sirena.org.uk>
	 <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com>
Date: Wed, 27 May 2009 20:11:37 -0400
Message-ID: <9e4733910905271711r6aca8308y5e3b9b8d3be25ee@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Jon Smirl <jonsmirl@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 5:05 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, May 27, 2009 at 2:52 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Wed, May 27, 2009 at 08:29:10PM +0100, Russell King wrote:
>>> On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:
>>
>>> > I'm not talking about platform specific code, I'm talking about code to
>>> > retrieve information about a device from the device tree.  There would
>>> > not be separate instances of this for "platforms X, Y and Z", just one
>>> > of_platform binding in each driver.  It's no different than having a
>>> > platform bus binding, except in the data structures used.
>>
>>> I really don't see what OF buys us then, apart from additional dependencies
>>> that have to be correct for the kernel to work.  I can only see disadvantages
>>> if all OF is, is a way to pass some file to the kernel to (effectively) tell
>>> it which drivers to use.
>>
>> The main selling points of the device tree AFAICT are that some
>> platforms have to use it it anyway due to the native OS and firmware for
>> the platform use it, the possibility of using the same device tree with
>> more than one OS (modulo unrepresentable holes) and the fact that some
>> people find it more convenient to use than straight data tables
>> (personally I find the two approaches to be much of a muchness there).
>> Perhaps I'm missing something, though?
>
> Here are some that I've find useful:
>
> There is the advantage that it decouples the machine description from
> the kernel code, which in turn seems to encourage code reuse.  There
> has been a significant decrease in the amount of platform specific
> code in powerpc since the switch to FDT booting.

I agree with this. I have observed the same thing.

>
> There is the advantage of easy multiplatform support.  I regularly
> build a single kernel image which boots on all my MPC5200 boards, and
> on my MPC83xx boards.  Because the machine description is a separate
> image blob, and not hard compiled into the kernel, the kernel doesn't
> have to be explicitly told what boards it may possibly be booted on
> (other than turning on the appropriate drivers; handled with modules,
> just like on x86).  It may not be much of an advantage for current
> deployed systems, but it is a huge win during development and
> testing....

I am routinely booting four different mpc5200 systems off from the
same NFS tree and the same kernel image. These four mpc5200 system
have quite different capabilities. There are different audio codecs,
PCI/no-PCI, ATA/no-ATA, SD cards, RAM, flash (some 8b others 16b),
they don't even have the console on the same serial port. I build a
single kernel and test it on all four of these systems. The device
tree customizes each kernel at boot time to support the right
hardware.

We want to use this capability in the field. A single update can
services multiple versions of the hardware.

> That being said, I've been told that Motorola has shipped phones with
> FDT support in the kernel for exactly the reason of booting a single
> kernel image on multiple versions of the device.
>
> g.
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
