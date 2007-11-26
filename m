Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXKZRTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXKZRTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXKZRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:19:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbXKZRT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:19:27 -0500
Subject: Re: [PATCH 2/2] iwlwifi: add power management support -v2
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       yi.zhu@intel.com
In-Reply-To: <1ba2fa240711260911i705350f3hefeddc7a09f76d1a@mail.gmail.com>
References: <200711170006.49654.mboton.lkml@gmail.com>
	 <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
	 <200711261718.14711.mboton@gmail.com>
	 <1ba2fa240711260911i705350f3hefeddc7a09f76d1a@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Nov 2007 12:14:30 -0500
Message-Id: <1196097270.23210.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-6.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-26 at 19:11 +0200, Tomas Winkler wrote:
> On Nov 26, 2007 6:18 PM, Miguel Botón <mboton.lkml@gmail.com> wrote:
> >
> > On Saturday 17 November 2007 07:15:05 Tomas Winkler wrote:
> > > Why power management shouldn't be enabled while in AC? The semantic of this
> > > ioctls is quite unclear.
> >
> I
> > IWL_POWER_AC and IWL_POWER_BATTERY are just two power modes. IWL_POWER_AC
> > would be the default power mode when we're in AC (no power saving) and
> > IWL_POWER_BATTERY would be the default power mode when we're in battery
> > (power saving mode). That's why we set IWL_POWER_ENABLED flag with
> > IWL_POWER_BATTERY, because it is the only power mode that saves power.
> >
> > We can change to IWL_POWER_BATTERY or IWL_POWER_AC in any moment.
> >
> > This patch, depending if power management is enabled or not, sets which power
> > mode we should use, Then, it checks if we're already using this mode or not.
> >
> I'm not sure who introduced this names (lazy to look to history) but
> that's very misleading. Nothing says that while in
> AC we cannot do power saving and vice versa. This naming is scattered
> all over the code, there should be only one place where AC and BATTERY
> are  translated into appropriate (maybe configurable) power levels. We
> have 5 power levels defined for iwlwifi.

At some point everyone needs to standardize on power levels so that
userland has a hope of mapping the right state to the right power level
in the driver.  Otherwise, we get into a situation where broadcom power
levels don't map the same way iwl powerlevels do, and then we can't ever
do the right thing.

dan

> Tomas
> 
> > --
> >        Miguel Botón
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

