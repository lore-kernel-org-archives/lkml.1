Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYGZRyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYGZRyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYGZRx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:53:59 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:36763 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYGZRx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:53:58 -0400
Message-ID: <fa686aa40807261053r5a8ebe40l7e8061f926f185f9@mail.gmail.com>
Date: Sat, 26 Jul 2008 13:53:57 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Milton Miller" <miltonm@bga.com>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "Jeremy Kerr" <jk@ozlabs.org>
In-Reply-To: <913573e2092839fbe37a0bfa37119eb6@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216887460.306306.238738123378.1.gpush@pingu>
	 <200807250108.m6P18f4B099179@sullivan.realtime.net>
	 <fa686aa40807252155l4f785920qdb14d117067b30f4@mail.gmail.com>
	 <913573e2092839fbe37a0bfa37119eb6@bga.com>
X-Google-Sender-Auth: 10821f110bba0f7d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 1:20 PM, Milton Miller <miltonm@bga.com> wrote:
> On Jul 25, 2008, at 11:55 PM, Grant Likely wrote:
>>
>> On Thu, Jul 24, 2008 at 9:08 PM, Milton Miller <miltonm@bga.com> wrote:
>>>>
>>>> Add support for powerpc builds in the buildtar script, to include
>>>> a few default images.
>>>> ---
>>>> RFC: any requests for more/less boot images?
>>>
>>> ..
>>>>
>>>> +             for img in zImage zImage.pseries zImage.iseries \
>>>> +                             dtbImage dtbImage.ps3
>>>
>>> Yes.  How about all dtbImage, zImage, cuboot, treeboot, etc
>>> that are newer than vmlinux?
>>
>> dtbImage is not a buildable image.  Neither is cuImage, treeImage or
>> simpleImage.  All of those targets embed a device tree which is
>> specified by adding the .dts filename to the target name.
>
> I intended "all dtbImage" as a wildcard for dtbImage.*, etc.

Yeah, okay.  That's a good idea.

>> so, for example, 'make cuImage' fails.  Instead you do 'make
>> cuImage.lite5200b' which pulls in dts/lite5200b.dts.
>
> The user does make zImage which makes cuImage.lite5200b based on Kconfig.
> Or it was that way until your change in 2.6.25 to allow the later, but they
> can still do the former.

Yes, both methods should work (at least they both work for me).  There
is also now a Kconfig option (CONFIG_EXTRA_TARGETS) which can be used
to add additional images to the zImage target list.  Should be useful
for some of the defconfigs.

> Hmm, we really need to fix our calls to make boot images with make -j.
>  Something for my todo list.

Good idea

>
>> Also, zImage is a 'meta' target that builds all the default image
>> targets (the $image-y list).  The zImage is actually just a symlink to
>> the first file in the list of default images.  So zImage can actually
>> point to any kind of kernel image depending on how the kernel is
>> configured.  I wonder if we should just remove the zImage file
>> entirely, or at least make it always linked to one particular image
>> type.
>
> I think its fine as it is.   It says "make what is configured" that lets
> cross-platform building scripts be dumb and not need to know specificially
> what image makes sense to make.  Perhaps we should make it default to our
> additional target in Kconfig if specified, this allowing the user to specify
> which version he gets.

It makes sense if only one target is ever built at a time; but since
we build multiple targets, I don't want users to get caught just using
zImage and then get bitten when a a config or source change causes it
to be linked to a different kernel type.

Come to think of it, I'd support just removing the zImage symlink
entirely to eliminate confusion so that everyone knows that 'make
zImage' is the 'make all' for default image targets.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
