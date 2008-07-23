Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYGWTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYGWTTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGWTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:19:23 -0400
Received: from trinity.fluff.org ([89.145.97.151]:50370 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYGWTTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:19:22 -0400
Date: Wed, 23 Jul 2008 20:19:18 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, David Brownell <david-b@pacbell.net>,
       hmh@hmh.eng.br, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
Message-ID: <20080723191918.GC26938@trinity.fluff.org>
References: <488763AD.4050400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488763AD.4050400@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 06:00:29PM +0100, Jonathan Cameron wrote:
> Dear All,
> 
> The need for an industrialio subsystem was discussed in
> http://lkml.org/lkml/2008/5/20/135

The name is really bad, this sounds like something for doing large
scale industrial process control.
 
> Firstly thanks to all the people who have contributed to the discussion
> of this in the past.
> 
> In brief the intention is provide a kernel subsystem directed towards the
> handling on sensors (and later related output devices) such as ADC's,
> accelerometers and many others.

We've already got an perfectly good hwmon framework, do we really need
to do this again?

> Key features of the subsystem include:
> 
> * Provision of sysfs access for direct reading from devices (similar to hwmon
>   but without the buffering / update rate restrictions)
> 
> * Provision of chrdevs through which events may be passed to userspace in a
>   similar fashion to the input subsystem.  These events may be anything from
>   hardware thresholds set on the sensor itself to sw / hw ring buffer event
>   notifications (50% full etc).
> 
> * Provision of access via chrdevs to hardware ring buffers on devices that
>   provide them.
> 
> * Software ring buffer support to allow semi regular capture of data form the
>   device.  Typically this will be driven from either datardy events, or from
>   a periodic timer interrupt (to this end a very simple wrapper for periodic
>   RTC's is included. This will move to more generic timer interfaces as and when
>   they become available.  For now available rtc's must be registered with the
>   subsystem via the industrialio_register_ptimer function form within a board
>   init.
> 
> * A set of sample drivers illustrating the main 'classes' of device. By classes
>   I really mean devices that are interfaced with in a similar way.
> 
> The subsystem is now in a functional state with a small set of drivers:
> 
> Max1363 (supports numerous Maxim i2c ADC's) (tested with max1363 and max1238 chips)
>    - Uses a periodic timer to provide ring buffer mode.
>    - All reads form these devices are scan modes so direct single element access
>      is not provided.
>    - Monitor mode on max1363 is not yet supported (need to do a bit debugging of
>      the board I have so as to be able to test this).
> 
> ST LIS3L02DQ - SPI accelerometer.
>    - Uses a datardy interrupt to driver a software ring buffer.
>    - Most functionality of this device is supported.
> 
> VTI SCA3000 (tested with an e05)
>    - Hardware ring buffer.
> 
> More drivers in preparation.
> 
> Next focus will be on cleaning up / implementing a more generic timer framework
> and allowing the system to partly run if not all dependencies are met 
> (particularly availability of timers).
> 
> An initial set of patches will be attached to this thread shortly.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

