Return-Path: <linux-kernel-owner+w=401wt.eu-S1760058AbYARB0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058AbYARB0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYARB0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:26:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:60131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbYARB0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:26:20 -0500
X-ExtLoop1: 1
Subject: Re: [PATCH 6/10] ACPI: register ACPI Video LCD as generic thermal
	cooling device
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Thomas, Sujith" <sujith.thomas@intel.com>
In-Reply-To: <20080117122431.GA32133@srcf.ucam.org>
References: <1200556282.2935.122.camel@acpi-sony.sh.intel.com>
	 <20080117122431.GA32133@srcf.ucam.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 09:31:40 +0800
Message-Id: <1200619900.2935.161.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mattew,

thanks for your comments.

On Thu, 2008-01-17 at 20:24 +0800, Matthew Garrett wrote:
> On Thu, Jan 17, 2008 at 03:51:22PM +0800, Zhang Rui wrote:
> > From: Zhang Rui <rui.zhang@intel.com>
> >
> > Register ACPI video device as thermal cooling devices as they may be
> listed
> > in _TZD method and the backlight control can be used for throttling.
> 
> I'm worried to some extent about how ungeneric this is. A thermal zone
> may cover any devices, not just processor and video ones.
>  Perhaps this
> should be added to the acpi_device struct instead, and then let
> individual drivers implement whatever callbacks are appropriate?
Yes, we can do this. But it's kinda early to add the
thermal_cooling_device struct to the acpi_device struct now.
I don't think any other individual drivers know whether they can or how
to throttle the device except processor, fan and lcd currently.

Just like I don't think lcd should be used for ACPI thermal management
before I saw it is listed in _TZD and intel_menlow requires to throttle
it when overheating, why not let the individual drivers implement the
callbacks if there is clearly a request to do this.
And we can add this to the generic acpi_device struct then if this is a
common feature for all ACPI devices.
> 
> > +static int
> > +video_set_cur_state(struct thermal_cooling_device *cdev, unsigned
> int state)
> > +{
> > +     struct acpi_device *device = cdev->devdata;
> > +     struct acpi_video_device *video = acpi_driver_data(device);
> > +     int level;
> > +
> > +     if ( state >= video->brightness->count - 2)
> > +             return -EINVAL;
> > +
> > +     state = video->brightness->count - state;
> > +     level = video->brightness->levels[state -1];
> > +     return acpi_video_device_lcd_set_level(video, level);
> 
> This all seems like duplication of the backlight interface?
Well, you're right.
But in order to throttle the lcd, this is reasonable, right?

Thanks,
Rui

