Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379Ab0AIVlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0AIVlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 16:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683Ab0AIVlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 16:41:03 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:63998 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0AIVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 16:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cl6yfw45vQOZgAub2Gsq4lfaHKnKrlESgd6GPA6YWE9X9ebXTLVW0G4SmFqCTKLtQn
         xrH/VdIQ7GpF9WzsrtZfwUMjauRlDLzmVonxLL8VoPVtLBjEjxrVXKVKuw6/vQonudVE
         2NYOWRdqmh8Tjq2CzEfVvU+mZcNHqYWaxfF1s=
MIME-Version: 1.0
In-Reply-To: <201001091435.56157.rjw@sisk.pl>
References: <201001090045.33784.rjw@sisk.pl>
	 <alpine.LFD.2.00.1001081648490.7821@localhost.localdomain>
	 <20100108171311.128c43d0@jbarnes-piketon>
	 <201001091435.56157.rjw@sisk.pl>
Date: Sun, 10 Jan 2010 07:41:00 +1000
Message-ID: <21d7e9971001091341j313e6274vd883c0d5301b2586@mail.gmail.com>
Subject: Re: [PATCH] i915: Always register as a PCI driver (was: Re: [PATCH] 
	DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS)
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Anholt <eric@anholt.net>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 9, 2010 at 11:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 09 January 2010, Jesse Barnes wrote:
>> On Fri, 8 Jan 2010 16:50:57 -0800 (PST)
>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> >
>> >
>> > On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
>> > >
>> > > Which is functionally equivalent to my patch, because
>> > > i915_suspend/resume() won't be called by drm_class_suspend/resume()
>> > > in the KMS case anyway.
>> >
>> > Ahh, right you are - that class suspend function does a check for
>> > DRIVER_MODESET, and only does the suspend/resume if it's not a
>> > MODESET driver.
>> >
>> > Ok, so I withdraw my objections to your original patch - it's
>> > confusing, but that's just because DRM is such a horrible mess with
>> > subtle things.
>>
>> Yeah the non-KMS paths just suck.
>>
>> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>>
>> Though hopefully you can get the PCI driver registration working w/o
>> too much trouble; that would be even better.
>
> Actually, I have a working patch, with one tiny detail I'm not sure of.
>
> Namely, I need to call pci_set_drvdata(pdev, dev) unconditionally in drm_stub.c
> for the things to work, but I _think_ it won't hurt even if we're not going to
> use the pdev's private data.
>
> The benefit of this is having just one code path for suspend/resume instead of
> two different code paths depending on whether the driver is using the KMS or
> not, which is well worth it IMO.
>
> The patch is appended.

NAK

for the reasons I explained in the previous email. This conflicts with systems
where intelfb and intel drm are used together, this is something that ppl do use
prior to KMS happening.

We just need to document in the headers why the hooks are needed,
and maybe a bit of patch review to make sure nobody removes them again.

Dave.
