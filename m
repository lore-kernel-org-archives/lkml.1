Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZFKLYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZFKLYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZFKLYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:24:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14527 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZFKLYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:24:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=r1zH7sb2Pah92obb+heuH2r5duA0lXNICDyFWcS3btNvxP3fW4mBR175V/WJH2/lR
	VlcbsNRzbgP+FpJ3TQrLw==
MIME-Version: 1.0
In-Reply-To: <20090611110946.GA7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	 <20090611081012.GD8592@elf.ucw.cz>
	 <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>
	 <20090611110946.GA7523@elf.ucw.cz>
Date: Thu, 11 Jun 2009 04:24:03 -0700
Message-ID: <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 4:09 AM, Pavel Machek<pavel@ucw.cz> wrote:
>
> Anyway, now I have a tree, and yes it compiles. (After some
> "interesting" questions; perhaps defconfig should be updated?)
>
> Unfortunately, upon fastboot boot uImage, it hangs with black screen
> and backlight on.

You'll need to fastboot boot arch/arm/boot/zImage ramdisk.img

Extracting the ramdisk.img from the boot.img in the boot partition on
an existing device is a pain.  If you happen to have a cupcake
userspace built from source that ramdisk.img should be suitable.  If
not, I'll try to dig up a suitable ramdisk image tomorrow -- it's just
init, init.rc, and adb, but it is necessary to boot.

> I _think_ I got config right, most "interesting"
> question was
>
> AMSS modem firmware version
>  1. 6.2.10 (MSM_AMSS_VERSION_6210)
>  2. 6.2.20 (MSM_AMSS_VERSION_6220)
>> 3. 6.2.20 + New ADSP (MSM_AMSS_VERSION_6225)
>  4. 6.3.50 (MSM_AMSS_VERSION_6350) (NEW)
>
> ...and I just selected "3" being default. No help available :-(. I
> have cupcake installed, and I believe I installed radio update
> required for cupcake. Can someone help? (And write Kconfig help text?
> :-).

This is correct.  The shipping dream/sapphire devices are using AMSS
6.2.20+patches, which is option 3.

I'll look over the Kconfig text and see what we can do here.  The
problem is that the baseband firmware (AMSS) changes some of the rpc
interfaces incompatibly between versions, and different generations of
the same hardware could be shipping with somewhat different baseband
firmware.  6210 and 6220 are completely obsolete (never used in
anything in production) and we should drop them to avoid confusion.

>> > Ok, could we get the boards renamed? g1 is known as dream, having
>> > trout+dream+g1+adp1 names for same piece of hardware is unnice.
>>
>> It's hard to have a single name since carriers tend to use different
>> names in different markets.  We often start work on kernel support
>> long before a product is announced, so we've been using the fish names
>> to allow us to register board names with the ARM machine registry
>> early on and not use bogus internal-only machine IDs.
>
> I know naming stuff is hard. But dream/g1/adp1 are both recognized by
> outside people. I don't think "trout" has similar level of
> recognition.

Would better descriptions in Kconfig help here?  That's a lot easier
and less disruptive than renaming the machine types (and the userspace
android world, for good or ill uses the machine name to identify the
hardware version for some hardware specific configuration stuff at
runtime).

Brian
