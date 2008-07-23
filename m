Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYGWTds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYGWTds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 15:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYGWTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 15:33:37 -0400
Received: from trinity.fluff.org ([89.145.97.151]:51897 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYGWTdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 15:33:37 -0400
Date: Wed, 23 Jul 2008 20:33:34 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, David Brownell <david-b@pacbell.net>,
       hmh@hmh.eng.br, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
Message-ID: <20080723193334.GD26938@trinity.fluff.org>
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
> 
> Firstly thanks to all the people who have contributed to the discussion
> of this in the past.
> 
> In brief the intention is provide a kernel subsystem directed towards the
> handling on sensors (and later related output devices) such as ADC's,
> accelerometers and many others.

Thinking about this, basically we have an event buffer and management
system that could live in  drivers/event. It manages the event sources
and buffering, including tagging the data and buffering it ready for
consumption.

One thing I'd like to see is that the reading application should be
able to choose to have events aggregated or not, so that if a few
events turn up very fast it can choose to take them as one single
item.
 
> Key features of the subsystem include:
> 
> * Provision of sysfs access for direct reading from devices (similar to hwmon
>   but without the buffering / update rate restrictions)

Having an update rate and buffering is possibly useful, given that if you
have say a number of ADC inputs but only one converter, then it is possible
that there will be some form of resource starvation.
 
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

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

