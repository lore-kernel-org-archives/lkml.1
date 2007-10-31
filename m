Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXJaGac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXJaGac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXJaGaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:30:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6993 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbXJaGaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:30:09 -0400
X-IronPort-AV: i="4.21,350,1188792000"; 
   d="scan'208"; a="42760323:sNHT27327727"
Subject: Re: [PATCH 13/14] Blackfin SPI driver: Move cs_chg_udelay to
	cs_deactive to fix bug when some SPI LCD driver needs delay after
	cs_deactive
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>,
       Cameron Barfield <cbarfield@cyberdata.net>
Cc: Bryan Wu <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710301319.00071.david-b@pacbell.net>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <1193735885-8202-14-git-send-email-bryan.wu@analog.com>
	 <200710301319.00071.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 31 Oct 2007 14:30:04 +0800
Message-Id: <1193812204.6971.14.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 31 Oct 2007 06:30:07.0893 (UTC) FILETIME=[7B0B4450:01C81B87]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 13:18 -0700, David Brownell wrote:
> On Tuesday 30 October 2007, Bryan Wu wrote:
> > @@ -211,6 +211,10 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
> >         flag |= (chip->flag << 8);
> >  
> >         write_FLAG(drv_data, flag);
> > +
> > +       /* Move delay here for consistency */
> > +       if (chip->cs_chg_udelay)
> > +               udelay(chip->cs_chg_udelay);
> >  }
> >  
> 
> By the way, if this is something needed very often, that mechanism
> should be moved into the SPI framework.  It wouldn't be polite if
> such LCD drivers could only work on Blackfin boards.  :)

I am not sure whether this LCD needs cs_chg_udelay on other boards.
It is found by Cameron Barfield. Maybe it is some timing requirement for
specific hardware.

-Bryan Wu
