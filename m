Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZGYUVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZGYUVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZGYUVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:21:46 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:52300 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbZGYUVq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:21:46 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Sat, 25 Jul 2009 22:21:42 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Arnaud Faucher <arnaud.faucher@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <20090725191037.GE14062@dtor-d630.eng.vmware.com> <200907252139.30674.rjw@sisk.pl>
In-Reply-To: <200907252139.30674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200907252221.45407.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 20:21:46.0183 (UTC) FILETIME=[8839D570:01CA0D65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Rafael J. Wysocki wrote:
> > > > Was suspend to disk tested? It requires freeze()/thaw().
> > >
> > > Is that a regression introduced by this patch then? If so, many
> > > more of the recent dev_pm_ops conversion patches would need to be
> > > revisited.
>
> Yes, they would.  In general, you'd probably want to do something like
> this:
>
> static struct dev_pm_ops au1xmmc_pmops = {
>         .resume         = au1xmmc_resume,
>         .suspend                = au1xmmc_suspend,
>         .freeze         = au1xmmc_resume,
>         .thaw           = au1xmmc_suspend,
>         .restore                = au1xmmc_resume,
>         .poweroff       = au1xmmc_suspend,
> };
>
> but in this particular case it's probably better to define separate
> callbacks for .freeze() and .thaw() at least.
>
> During hibernation we call .freeze() and .thaw() before and after
> creating the image, respectively, and then .poweroff() is called right
> after the image has been saved.  During resume .freeze() is called
> after the image has been loaded and before the control goes to the
> image kernel, which then calls .restore().

Yes, I see that in drivers/base/platform.c (legacy) .suspend resp. .resume 
also got called for those cases?
Ouch :-(

I've added others who've submitted dev_pm_ops patches in CC.

> I'll fix up the floppy and hp-wmi patches.

Note that those are already in mainline, as is pcspkr.

Thanks,
FJP
