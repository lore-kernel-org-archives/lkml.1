Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYGINes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYGINes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYGINec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:34:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:43277 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbYGINeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fXk3JRlouw6Z5bKT+WfOT9riBYZb6Su1gnOdnkpBgg7HDGdydKs1FCXqQuu4Vsy38y
         bt8FFKplkkzPbskBz81v+nu8KlmuvQxFNH0m+U5I7UXEzd5Fu7aqENg5IA1lToZV3tKC
         bBogvaTG7Jd02DbNDWVitKwAWH7E2SgbVHNcA=
Message-ID: <74d0deb30807090634h6feb1f2eu53f8b13d810b8b3d@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:34:29 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: ian <spyro@f2s.com>
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Cc: "Ben Dooks" <ben-linux@fluff.org>, Dmitry <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1215610118.3295.92.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <20080709112426.GN8489@trinity.fluff.org>
	 <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com>
	 <20080709115045.GK8517@trinity.fluff.org>
	 <bc64b4640807090456u15d12378qe25375ce4a6cd100@mail.gmail.com>
	 <20080709120720.GL8517@trinity.fluff.org>
	 <1215610118.3295.92.camel@wirenth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 3:28 PM, ian <spyro@f2s.com> wrote:
> On Wed, 2008-07-09 at 13:07 +0100, Ben Dooks wrote:
>> > They should be here for exactly the same reason. They are used by
>> the drivers
>> > that will be submitted later. E.g. OHCI driver needs such
>> > suspend/resume handling.
>>
>> No, you don't understand. I'll make a rather explicit point about the
>> very clever way the device tree works since the devices are registered
>> with their parent device set.
>
> Actually I misthought here too.
>
> The problem comes when the subdevices arent *quite* truely independant
> of their core, and thus need to ask the core to turn off power /
> clokcs / etc. for them

I agree "power" and "etc." are issues. Clocks should be handled by the
clock API just fine.

> they cant just do it themselves because the subdevices may be used on
> more than one core that does this hanling in different ways (eg. T7L and
> TC6393XB handle the 32KHz clock completely differently.

That shouln't matter with generic clocks. If they
clk_get(&mfd_cell->pdev.dev, "my_clk_input"), that should be
dispatched to the correct MFD clock regardless of the actual chip.

> on tc6393xb,
> theres a clock gate on the MFD core chip and on t7l66xb the clock has to
> be handled right back at the platform layer, in board specific code
> because the core has no gate, and the clock is fed to it from an
> external pin.

Still, that could be done inside the MFD driver's custom clock
enable/disable methods.

> Thats one example - there are others, not all clocks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
