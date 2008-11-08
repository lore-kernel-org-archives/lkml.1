Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKHXM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKHXM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 18:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYKHXMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 18:12:50 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:39690 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYKHXMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 18:12:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cdYULhH1HWZCAB1fllCN1El76WHIig5E2lcK+p4t2zny0OWctorFHrq70YOoN9dAtV
         ycLKERP5h12u1d7m6yRDdGNlnAVxPJqmbkqdPq6MvxeYlJ9paZYWqVwamwr4jsmXQIl7
         nfXVVOhhGhmXK98rDSkEtcLrbgU/j5IcjbEoM=
Message-ID: <bc64b4640811081512ta8bfd90m921760839bdf8ffa@mail.gmail.com>
Date: Sun, 9 Nov 2008 02:12:47 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Richard Purdie" <rpurdie@rpsys.net>
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>, "Pavel Machek" <pavel@suse.cz>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Cyril Hrubis" <metan@ucw.cz>,
       lenz@cs.wisc.edu, "kernel list" <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, pavel.urban@ct.cz,
       thommycheck@gmail.com
In-Reply-To: <1226155540.5379.5.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031150601.GA1457@ucw.cz> <20081105173303.GC2038@elf.ucw.cz>
	 <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com>
	 <20081106080416.GA1531@ucw.cz>
	 <20081106191424.GA2273@atrey.karlin.mff.cuni.cz>
	 <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com>
	 <20081107142923.GA1616@ucw.cz>
	 <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com>
	 <20081107182311.GA28600@flint.arm.linux.org.uk>
	 <1226155540.5379.5.camel@dax.rpnet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/8 Richard Purdie <rpurdie@rpsys.net>:
>
> On Fri, 2008-11-07 at 18:23 +0000, Russell King wrote:
>> On Fri, Nov 07, 2008 at 05:57:33PM +0300, Dmitry wrote:
>> > 2008/11/7 Pavel Machek <pavel@suse.cz>:
>> > > On Fri 2008-11-07 21:23:41, Eric Miao wrote:
>> > >> Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
>> > >> Did you guys ever try that?
>> > >
>> > > I never heard about that patch, do you have it handy?
>> >
>> > http://rpsys.net/openzaurus/patches/archive/pxa-linking-bug.patch
>> >
>> > I plan to submit a bit modified version of this patch later.
>>
>> That doesn't look like something that should be accepted.  Take a moment
>> to put some thought into the question.  Why should we _allocate_ and
>> contain the stack in the resulting image?  Does the stack contain any
>> data that must be pre-initialized?
>>
>> Obviously not.
>
> Firstly, I don't think that patch should ever make it into a mainline
> kernel. I can perhaps give some clues why its required though. I think
> the bootloader on the zaurus truncates the image when writing the kernel
> into flash using the standard flashing process. By having that much
> extra padding on the end of the kernel, nothing important is lost.

>From what I do understand from updater.sh, the kernel is fully written to nand.
Otherwise there will be lot's more problems. Maybe w/o padding the image is
loaded too high? Can't verify ATM.

BTW: Since I'm away from my zaurii for few days, can one please send
me the whole
ROM (I mean the one at CS0, not NAND) image of any Zaurus device?

> How did the original 2.4 kernels ever work? Binutils used to be buggy
> and left this padding in. Nobody therefore ever noticed the bug in the
> bootloader.
>
> The above theory is guesswork based on the kernels I've seen work and
> not work and I wrote the patch mentioned above as a workaround a long
> time ago and more pressing issues meant I never got back to it. I'd love
> to see someone work out the problem for sure!

I did rewrote your patch in a bit cleaner way (to apply the hack to
vmlinux.lds.in
in a cleaner way and only on PXA_SHARPSL), however I'm not submitting it
till I find what's the real reason for this problem.

-- 
With best wishes
Dmitry
