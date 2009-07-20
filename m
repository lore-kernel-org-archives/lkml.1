Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZGTUn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZGTUn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZGTUn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:43:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:41180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZGTUn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UiVoAcb2Q3713/uhOdBneu4Wn2oMPbRYz0X28A2ZxCriDHI/WEZaFoA0M7NVE/RuTR
         EUgB/bPk80xyrndf+s+zyP+PDFOp0C6xNMWjsElhKx2/+342hiOEVAJUCpgxIE3u2CTk
         BT+URYPFJ6q5yoVxomv0Q2NV3fD/Ywtrqr1hI=
MIME-Version: 1.0
In-Reply-To: <4A64D16E.90903@shipmail.org>
References: <4A647358.1040009@shipmail.org>
	 <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org>
	 <6a89f9d50907201213x8e16e60s38b0a4bd929ce4ca@mail.gmail.com>
	 <4A64D16E.90903@shipmail.org>
Date: Tue, 21 Jul 2009 06:43:26 +1000
Message-ID: <21d7e9970907201343s7dbf1864ta51535ee58e4ff1a@mail.gmail.com>
Subject: Re: DRM drivers with closed source user-space: WAS [Patch 0/3] 
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Cc: Stephane Marchesin <marchesin@icps.u-strasbg.fr>,
       Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/21 Thomas Hellström <thomas@shipmail.org>:
> Stephane Marchesin wrote:
>>>
>>> You obviously got all this completely wrong.
>>>
>>> I avoid writing closed source drivers whenever I can, I'm not whining and
>>> I'm not trying to push any of them. The code VIA is trying to submit has
>>> not
>>> been written by me nor anybody I know. All VIA code I and the companies
>>> I've
>>> worked for has written is open-sourced and contributed to the Openchrome
>>> /
>>> mesa / drm project.
>>>
>>> The point I'm trying to make is the following:
>>>
>>> If the common agreement of the linux community is to *NOT* allow these
>>> drivers in, so be it, then be honest and go ahead and tell the driver
>>> writers. Don't make them respin their development trying to fix minor
>>> flaws
>>> when their driver won't get in anyway!
>>>
>>>
>>
>>
>
> Stephane,
> Some comments on how these things has been handled / could be handled.
>>
>> I would like to raise a couple of real-life issues I have in mind:
>>
>> * First example, let's say VIA gets their Chrome9 DRM merged into the
>> kernel. Now let's say I reverse engineer the hardware (or use the docs
>> whenever they're available) and write a 3D component that needs
>> modifications to the existing DRM interface (or maybe I realize I need
>> a completely new DRM). Then who gets the upper hand? Do I have to keep
>> compatibility with user space binary modules that I do not care about?
>>
>
> If there is a serious OS project, I'd start a new DRM driver.
> That's sort of what may happen with openChrome vs via..
>
>> * Second example, what is the policy if we find security holes in the
>> DRM for a closed user-space afterwards? This breaks the initial
>> promise of security, does that get the driver removed then? Or what if
>> the promise is pending updated documentation that never arrives?
>>
>
> I'd say the DRM driver gets disabled unless fixed. How would we handle that
> problem today with, for example, the SiS driver?
>
>> * Third example, what if down the line we need changes in the DRM that
>> require updating all DRM modules. Do we (we as in DRM developers)
>> touch the DRM files for the VIA Chrome9 stuff, at the risk of breaking
>> the code (since we don't test with proprietary modules)? Or do we let
>> the Chrome9 files as-is, keeping the old DRM infrastructure and
>> therefore add more and more DRM cruft?
>>
>
> Again, this has been done quite commonly in the past and was easier to get
> right with the old drm.git testing ground. Same issue with unmaintained
> drivers with OS user-space. Who has actually tested all the drivers when
> making such a change? I certainly haven't. The change was left for testing
> for a while in drm.git before Dave moved it upstream.
>
>> In my opinion, accepting GPL'ed DRM modules that support binary user
>> space components is like opening pandora's box.
>>
>> Stephane
>>
>
> Yeah, drivers supporting binary blobs only is out of the question as it
> seems.
>
> Now's the tricky question how do we handle VIA's patches where they claim
> they have an open-source 2D component that exercises all of the DRM module
> for EXA render acceleration, and on top of this the 3D binary driver that
> apparently uses no additional DRM functionality compared to the 2D
> component?
>
> In the ideal world I'd of course like to see a Chrome9 3D driver based of
> the new openChrome drm driver with a modern GPU memory manager, kernel
> modesetting and Gallium, but that's a dedicated man-year or more away if /
> when someone decides to work on it.
>

If VIA releases the DDX code to use the DRM code, and it exercises the ioctls
then we can add kernel support for the ioctls the DDX uses. If there a bunch
of ioctls specific to the 3D driver we should identify them and see if userspace
test code is available.

I think this is the same as when poulsbo was proposed, if open code uses
the interfaces we add them, if not we don't.

I'd also prefer a community approach to work more on the new world order
and ignore this interface.

Dave.
