Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZGTVkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZGTVkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZGTVko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:40:44 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:39547 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZGTVkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sTyEP0DLQGZxnsQUfieM2F2bd5tVid/Uiw/xeFGQ0JvZMs89f3Xq8U2WQcRJwzWWqa
         qvF+w+JarwBUXZ+CJQenJ32yKTuEn8dEyKPjGfRzXyoRTPqZ59Jfdrz6XakIF1Bi0dS/
         mguVaAdWr/UbouClhUqATs3JIhQIuhgOqRotE=
MIME-Version: 1.0
In-Reply-To: <4A64D16E.90903@shipmail.org>
References: <4A647358.1040009@shipmail.org>
	 <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org>
	 <6a89f9d50907201213x8e16e60s38b0a4bd929ce4ca@mail.gmail.com>
	 <4A64D16E.90903@shipmail.org>
Date: Mon, 20 Jul 2009 23:40:41 +0200
X-Google-Sender-Auth: 8125bc9f33f9a5b3
Message-ID: <6a89f9d50907201440w534e1645q4d3d067c198090eb@mail.gmail.com>
Subject: Re: DRM drivers with closed source user-space: WAS [Patch 0/3] 
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
From: Stephane Marchesin <marchesin@icps.u-strasbg.fr>
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20 Thomas Hellström <thomas@shipmail.org>:
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

Well, for user space, there can be as many drivers as you want for a
given device. But the DRM policy always was one driver per hardware so
as to avoid confusing people, so what you're proposing is in fact not
possible. In that case, this would even deter a fully open source
driver as it would have to keep the same interface as some (possibly
unsupported) driver.

>> * Second example, what is the policy if we find security holes in the
>> DRM for a closed user-space afterwards? This breaks the initial
>> promise of security, does that get the driver removed then? Or what if
>> the promise is pending updated documentation that never arrives?
>>
>
> I'd say the DRM driver gets disabled unless fixed. How would we handle that
> problem today with, for example, the SiS driver?

If no one can fix it it gets killed, yes. I would expect this to
happen pretty quickly in fact, in which case the "driver merge/problem
found/driver removal" cycle requires more work than it's worth.

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

Well, some of us want to be thorough when doing invasive changes,
untestable code would prevent such changes (and then we get more of
the DRM cruft as a result). And yes, if people do not cooperate on all
drivers, this leads to issues in the code. At this point it's not a
matter of open source vs closed, but a problem of cooperation.

Stephane
