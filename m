Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZGRDek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZGRDek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 23:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZGRDef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 23:34:35 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:59598 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbZGRDef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 23:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q72B/vPAHUllpblv2Qh1mcTWl0ETDY4pGUSOs2SuzqiY3nfc4iqGoG4Gu/B/SPt+wv
         jp8Wd2KLOB7GRXOO0jqczGL5JcCDFOUtxO2kf9L51QRua9F8jViaJoHKA6gUjypG1kaM
         qSv92Znbrfv3gQ9Ekr5wwUC87smst5vLGHwrY=
MIME-Version: 1.0
In-Reply-To: <20090717182212.4675d0e1@jbarnes-g45>
References: <20090703112446.5a69971b@jbarnes-g45>
	 <20090717171326.4a71d8e3.akpm@linux-foundation.org>
	 <20090717182212.4675d0e1@jbarnes-g45>
Date: Sat, 18 Jul 2009 13:34:34 +1000
Message-ID: <21d7e9970907172034x40cbc65emb627ebc58b91a483@mail.gmail.com>
Subject: Re: [PATCH] fb/intelfb: conflict with DRM_I915 and hide by default
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 11:22 AM, Jesse Barnes<jbarnes@virtuousgeek.org> wrote:
> On Fri, 17 Jul 2009 17:13:26 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Fri, 3 Jul 2009 11:24:46 -0700
>> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> > Users get confused by this driver.  It's really a special purpose
>> > embedded driver, and causes a lot of problems if enabled.  So hide
>> > it under EMBEDDED by default, and make sure it doesn't get enabled
>> > with the i915 DRM driver.
>> >
>> > Dave, I'm hoping you can feed this to Linus through your tree.  It's
>> > appropriate for 2.6.31 I think.
>> >
>> > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>> >
>> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
>> > index d6d65ef..ec12f7a 100644
>> > --- a/drivers/video/Kconfig
>> > +++ b/drivers/video/Kconfig
>> > @@ -1117,12 +1117,13 @@ config FB_CARILLO_RANCH
>> >
>> >  config FB_INTEL
>> >     tristate "Intel
>> > 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support
>> > (EXPERIMENTAL)"
>> > -   depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
>> > +   depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
>> > && EMBEDDED select FB_MODE_HELPERS
>> >     select FB_CFB_FILLRECT
>> >     select FB_CFB_COPYAREA
>> >     select FB_CFB_IMAGEBLIT
>> >     select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
>> > +   depends on !DRM_I915
>> >     help
>> >       This driver supports the on-board graphics built in to
>> > the Intel
>> > 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM
>> > chipsets.
>>
>> Nothing happened?
>>
>> I'll merge this next week(ish) unless given a reason not to.
>
> It's in Dave's tree, pull requested to Linus already, so it should land
> soon.
>

I suspect Linus isn't pulling from me post -rc2 anymore, or maybe
he just missed it.

Dave.
