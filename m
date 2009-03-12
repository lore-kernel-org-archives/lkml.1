Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZCLCOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZCLCOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZCLCNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:13:53 -0400
Received: from mail-gx0-f167.google.com ([209.85.217.167]:45694 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZCLCNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S3UnPtLXcLBV4N0kuNn6nwgC/+HpFH1/IQ6R6wY4zgoj9bAtBaxDVkVZ3KsP1pjn65
         V/PFR2u8dg/weC4Wcgi0QsvhbraCHBseThg1Czu2aWUHp+M4HHb4qvjVoFMfaDYRQ5Pu
         N49o5qv6oNbE2vmBBRoI6mH3xM6lSaZfhcdjw=
MIME-Version: 1.0
In-Reply-To: <49B7CD1B.2080704@mnementh.co.uk>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	 <20090311125911.1563.27785.sendpatchset@rx1.opensource.se>
	 <49B7CD1B.2080704@mnementh.co.uk>
Date: Thu, 12 Mar 2009 11:13:49 +0900
Message-ID: <aec7e5c30903111913y38041a68r4742779103c7df1b@mail.gmail.com>
Subject: Re: [PATCH 03/05] tmio_mmc: Break out cnf area operations
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 11:39 PM, Ian Molton <ian@mnementh.co.uk> wrote:
> Magnus Damm wrote:
>>
>> From:  Magnus Damm <damm@opensource.se>
>>
>> Break out tmio_mmc io operations for the cnf area.
>> This moves similar register operations into one place.
>
> Not sure about this one yet. AFAICT this totally disables the HBA power
> control.

Hm, my plan was not to introduce any changes to the register accesses.
With this patch code is only broken out, and the patch after this
makes it possible to use this driver without the cnf block. For
hardware with the cnf block included there should be no change. Unless
I made some mistake that is. =)

> I'm wondering if this is a common problem.
>
> It seems to me  that its likely that clock and power control are often
> external to the host controller chip. (not just on TMIO MMC).

I agree. These patches show just that.

> I think it'd be a good idea if we came up with an infrastructre that allowed
> a set of clock / power control callbacks into the platform code.
>
> Whats your use case for this? samee applies to the related cnf patch too.

Please wait for platform data patches. They will be sent out late
before -rc1 if we can agree on some way to make the cnf area optional.
Without that (this patch and the next) we can't really use this driver
so platform data patches are pointless. =)

This is lucky guesswork. I just happened to figure out that I can use
the tmio_mmc driver to drive the ctl block of this hardware. As for
memory window setup, voltage control, and hotplug - I have no idea. No
docs apart from the Toshiba docs that I can find online. But breaking
out the power control and hotplug management sounds like a good plan.

As for clock control, maybe breaking out that as well is a good idea.
At least part of it. The first thought that pops into my mind is to
tie in the clock framework. So we can use clk_enable() and
clk_disable() for run time power management and call clk_get_rate() to
figure out the parent clock rate and use that to calculate the divider
for CTL_SD_CARD_CLK_CTL. Not sure if the clock framework is supported
on your target platforms though.

Do you have any recommended hardware platform to test this driver?
I'll try to find such hardware platform (or similar) so I have
something to compare with. Unfortunately I don't have that much time
to spend on this. But an hour here and there is probably fine.

How would you like to proceed? I'd prefer to merge this first and
break out after, but I'm not sure if that fits well with your plan.

Thanks for your help!

Cheers,

/ magnus
