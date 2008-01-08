Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYAHIWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYAHIWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYAHIWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:22:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:31109 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYAHIV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:21:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lK0ekp1/mabS+X2fs3S+V8YI4xTZMFt9mopVemTDIfr122Fxr5RCj8/DNU/BJcgd0U4N0GG1zDqdUfkc0M0iu3zJ4eQYS6PW8TXmjY8LyMyI6Z2JUB0vmvy7xW3AoKqcrKsVVbopm2ocF333SiFWw1hwPsB6IiNZSDZ1orlltr4=
Message-ID: <74d0deb30801080021q63df5fcfw5ff3673ec9965d08@mail.gmail.com>
Date: Tue, 8 Jan 2008 09:21:55 +0100
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Matt Reimer" <mreimer@vpop.net>
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state settings.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       johnpol@2ka.mipt.ru, szabolcs.gyurko@tlt.hu
In-Reply-To: <1199751203.26310.64.camel@bilbo.vpop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199627174.28826.11.camel@localhost.localdomain>
	 <20080107151022.82901fcc.akpm@linux-foundation.org>
	 <1199751203.26310.64.camel@bilbo.vpop.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 1:13 AM, Matt Reimer <mreimer@vpop.net> wrote:
> On Mon, 2008-01-07 at 15:10 -0800, Andrew Morton wrote:
> > On Sun, 06 Jan 2008 14:46:14 +0100
> > Philipp Zabel <philipp.zabel@gmail.com> wrote:
> >
> > > The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
> > > high) from IRQ settings. There are devices that have IAS=0 but still need
> > > the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
> > > that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.
>
> > But no drivers are converted to set ds1wm_platform_data.active_high.  Won't
> > IORESOURCE_IRQ_HIGHEDGE devices be broken by this change?
>
> Good point; I think you're right. I'd guess the other platforms that use
> this driver are in the handhelds.org tree, but I've been out of the loop
> a while. Philipp, is this the case?

Yes, I think so. I am only aware of four chips that include a DS1WM:
HTC's ASIC3, PASIC2 and PASIC3 and Samsung SAMCOP.
All of those drivers have yet to be submitted.

I will also apply this patch to hh.org CVS and fix up the devices that are
affected by this change (aximx30, blueangel, magician, h1900, h4000,
h5400, himalaya, hx4700, sable, universal).
But none of those set IORESOURCE_IRQ_HIGHEDGE (most are just
missing the IORESOURCE_IRQ_LOWEDGE flag). I am not sure about
the status of rx3000 or other devices that might live in other trees.

I'm currently cleaning up the PASIC2/3 driver. After that I'll try to help
cleaning up ASIC3 and finally getting it ready for submission.
A whole load of devices in the hh.org tree depend on it.

regards
Philipp
