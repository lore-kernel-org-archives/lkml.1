Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbYJSQ62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbYJSQ62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 12:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYJSQ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 12:58:21 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:49930 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYJSQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 12:58:20 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2008 12:58:20 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48FB6193.8090803@gmail.com>
Date: Sun, 19 Oct 2008 17:34:27 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
References: <48FA3368.1040605@tremplin-utc.net>
In-Reply-To: <48FA3368.1040605@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Nice looking driver. 
> * Several people suggested to not put it in hwmon but in the future industrialio susbsystem: fine with that but as the industrialio subsystem is not available yet, it's still in hwmon with the other accelerometer drivers for now, and I'll happily move it whenever industrialio is integrated.
>   
Hmm.. might be a little while yet and there's still the debate on whether
support for input subsystem is a good idea (different requirements etc).
I'd be inclined to have a driver for this accelerometer in there, but the
form it may be somewhat  different (for example, that datardy signal
is vital in the sort of apps iio is designed for!)

Also, looking at the code, I'm not sure how similar things are to the
equivalent i2c or spi interfaces.  Guess that'll only become entirely
clear on implementation.

I'll try and get an updated version of industrialio patches as is out later
this week.
> +Sysfs attributes under /sys/devices/platform/lis3lv02d/:
> +position - 3D position that the accelerometer reports. Format: "(x,y,z)"
>   
Hmm. Position? I've probably missed the debate on why it is called
this.... 
> +calibrate - read: values (x, y, z) that are used as the base for input class device operation.
> +            write: forces the base to be recalibrated with the current position.
> +rate - reports the sampling rate of the accelerometer device in HZ
>
>   

> +/*
> + * The sensor can also generate interrupts (DRDY) but it's pretty pointless
> + * because their are generated even if the data do not change.
Unless there is some serious filtering the noise level on such a chip
will mean
it almost always changes anyway.  However, for this type of app I can
see your
point!
>  So it's better
> + * to keep the interrupt for the free-fall event. The values are updated at
> + * 40Hz (at the lowest frequency), but as it can be pretty time consuming on
> + * some low processor, we poll the sensor only at 20Hz... enough for the
> + * joystick.
> + */


