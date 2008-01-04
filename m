Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYADBbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYADBbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYADBbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:31:14 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:39864 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYADBbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z/Kt8Lnxys4J8qGtsQCAusy9Lr6PdqxLfESzQwhid4i0MS7HJO7I/ndj+Nim4GlIG/ckTehYhi2sT1b+F1K/ZdzOJdQ5ng+i0m0bpLEv4/UFS7ClIg3LeIW+APGdpZBORshnof6QI5SpmsSZhfvPuyiNJyHATUH7KbUKtHChZsc=
Message-ID: <bc64b4640801031731s1e36c576i399a0b9efed59f49@mail.gmail.com>
Date: Fri, 4 Jan 2008 04:31:10 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH] pda-power: only register available psu
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
In-Reply-To: <20080104002907.GA767@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103005319.GA714@doriath.ww600.siemens.net>
	 <20080104002907.GA767@zarina>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Anton,

2008/1/4, Anton Vorontsov <cbouatmailru@gmail.com>:
> Hi Dmitry,
>
> On Thu, Jan 03, 2008 at 03:53:19AM +0300, Dmitry Baryshkov wrote:
> > Currently pda-power adds both ac and usb power supply units.
> > This patch fixes it so that psu are added only if they are enabled.
>
> Thanks for the patch, this should be fixed of course. A comment
> though...
>
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> >
> > diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> > index c058f28..42eac09 100644
> > --- a/drivers/power/pda_power.c
> > +++ b/drivers/power/pda_power.c
> [...]
> >       if (ac_irq) {
> > +             ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
>
> I don't think we should check for IRQs when determining which one
> of power supplies to register. Better use is_{ac,usb}_online
> callbacks, this will not produce an obstacle to implement polling --
> when irqs aren't mandatory. I'll send my two pending patches to show
> the idea.
>
> For this particular issue, I think something like that should work.
> If it works for you, I'll commit that version, preserving your
> authorship, of course.

Yes, it works. Thank you very much!

-- 
With best wishes
Dmitry
