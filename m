Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYJTRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYJTRWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYJTRFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:05:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:50393 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbYJTRDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:48 -0400
Date: Mon, 20 Oct 2008 13:03:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Isely <isely@pobox.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <Pine.LNX.4.64.0810201142270.12643@cnc.isely.net>
Message-ID: <alpine.DEB.1.10.0810201251490.6072@p34.internal.lan>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0810201119250.12643@cnc.isely.net> <alpine.DEB.1.10.0810201231020.6072@p34.internal.lan> <Pine.LNX.4.64.0810201142270.12643@cnc.isely.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Oct 2008, Mike Isely wrote:

> On Mon, 20 Oct 2008, Justin Piszcz wrote:
>
>>
>>
>> On Mon, 20 Oct 2008, Mike Isely wrote:
>>
>>>
>>> There's already a patch coming up through v4l-dvb that should remove the
>>> need for the reset completely for the pvrusb2 driver.  The reset had
>>> been there as "chicken soup" previously - it didn't hurt but its
>>> utility wasn't really that great at the time.  Now that it is hurting,
>>> I just removed it.
>>>
>>>  -Mike
>>>
>>
>> Should I wait for the patch coming up through v4l-dvb or test Alan's patch?
>> 2.6.27.2 has quite a few issues:
>>
>> 1. xfs is broken w/barrier (there is a patch for this)
>> 2. usb hangs (patch below)
>> 3. abit-guru (comsetic issue only, doesn't find mobo) (there is a patch for
>> this now as well)
>>
>> So I am sticking with 2.6.26.5 right now, let me know if you need me
>> to test Alan's patch to see if it fixes the issue.
>
> I'm sorry I didn't post my patch immediately in my previous response.
> It is however posted as a link in a followup, and for the record here it
> is again:
>
> http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4
>
> I have tested it, and it works as expected.  I've done all I can
> according to the process there to ready it for kernel inclusion and I've
> asked in my pull request there to get this patch into the next 2.6.27.x
> stable release.
>
> The driver really didn't "need" the reset anyway, and so from where I'm
> sitting the simplest thing is just to remove it which is what my patch
> does.  (I had put in that reset a long time ago when working on
> improving hardware stability.  I had never positively established that
> this actually helped during initialization, but it didn't hurt either so
> I left it in place.  Now that it is causing pain, it's best just to get
> it out of there.)  I don't see much point in testing Alan's patch.

Ok, so the following patche are what I have applied to 2.6.27.2:

1. http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4

--

1. aw9d-max-dmi-detection.diff
2. pvrusb2-hdw.patch
3. xfs-fix-remount-rw-with-unrecognized-options.patch

Rebooting 2.6.27.2 with applied patches (all 3) and will check to make 
sure everything is back to normal.

Done, after reboot with the [3] applied patches above, it has fixed all 
the problems I was having.

Justin.
