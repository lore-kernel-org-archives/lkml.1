Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZLDBuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZLDBuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZLDBuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:50:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:23118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZLDBuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:50:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218669041"
Subject: Re: Backlight device class redesign
From: Zhang Rui <rui.zhang@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Rafa?? Mi??ecki <zajec5@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20091203105223.GB32571@khazad-dum.debian.net>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
	 <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com>
	 <1259827274.27069.50.camel@rzhang1-desktop>
	 <20091203105223.GB32571@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 09:50:48 +0800
Message-ID: <1259891448.27069.83.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 18:52 +0800, Henrique de Moraes Holschuh wrote:
> On Thu, 03 Dec 2009, Zhang Rui wrote:
> > For example, device /sys/class/backlight/panel0 is created the first
> > time a backlight_ops for this display is registered.
> > And create the symbol link from the backlight class device to "physical
> > device" (device that invokes backlight_device_register) in the backlight
> > class device driver, if we really need it.
> > Remove and recreate a link pointing to the new physical device when the
> > backlight mode is changed.
> 
> FWIW, I agree the above solution is simple enough and quite good enough.
> 
> I just have absolutely _NO_ idea whatsoever how a platform driver can ask
> the PCI or APCI layer "where is the video device driving the LVDS panel so
> that I can bind to it"...
> 
well. this is the question I want to ask. :)

IMO, if we want to create one device for one display, we must have a
unique ID for each display and the ID must be generic enough so that
both ACPI & platform & graphics driver can understand it.

ACPI&platform drivers have no idea about the display info it's bind to.
But they're always used to control the integrated panel, no?
we can use something like DEFAULT_ACPI_DISPLAY/DEFAULT_PLATFORM_DISPLAY
which stands for the integrated LVDS panel, which can also be understood
by the graphics driver.

ACPI video driver -->ACPI_DISPLAY-->|
                                    |
platform driver->PLATFORM_DISPLAY-->|--->/sys/class/backlight/panel0
                                    |
          |-->integrated panel----->|
          |
graphics  |-->TV------------------->|--->/sys/class/backlight/tv0
          |
          |-->external LCD--------->|--->...

I'm not a graphics guy so I don't if there are any other ways to control
the TV/external LCD device, if yes, they can use something else as the
unique ID, say EDID, right?

thanks,
rui

