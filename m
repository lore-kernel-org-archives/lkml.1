Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbZGATdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbZGATdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbZGATdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:33:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:10636 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbZGATdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:33:23 -0400
Date: Wed, 1 Jul 2009 21:33:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>,
       Chris Verges <chrisv@cyberswitching.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Message-ID: <20090701213311.04d9a8bd@hyperion.delvare>
In-Reply-To: <4A4BB4AB.7010003@cam.ac.uk>
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>
	<4A4BB4AB.7010003@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 19:10:35 +0000, Jonathan Cameron wrote:
> 
> > Hi kernel hackers,
> > 
> > Here is a patch that adds support to the Linux kernel for Analog
> > Device's ADXL345 chip.  It is an accelerometer that uses I2C and HWMON.
> > When I looked into the MAINTAINERS file for the appropriate list, the
> > "Orphan" status of "Hardware Monitoring" confused me as to the proper
> > list for this patch ... please let me know if I need to forward it
> > elsewhere.
> Hi Chris,
> 
> Just for reference this chip is definitely on my list of ones to support
> via the Industrial I/O (iio) framework, I just haven't managed to get hold
> of one as yet!  It's particualrly interesting to me because of the fifo
> buffering functionality as currently I only have access to a VTI chip
> that does something similar.
> 
> A new version of the IIO framework will get posted just
> as soon as I've had a few mins to bring the documentation / demo userspace
> apps up to date with the current code state.
> I've been chasing down bugs for the last week.
> 
> First big question is:
> 
> What are you actually doing with it?  If you aren't doing hardware
> monitoring then I would expect you aren't going to receive a favourable
> response on here.

Absolutely correct. Chris' driver doesn't implement any attribute
listed in Documentation/hwmon/sysfs-interface. The device registers as
a hwmon device for no good reason I can think of, and the driver
includes hwmon headers it doesn't make any use of. So to me it doesn't
look like a good candidate for drivers/hwmon. Chris, I suggest that you
remove all references to hwmon from your driver, and resubmit it to a
different subsystem (iio, misc, input, whatever.)

> (see the original IIO discussion on LKML for why I
> started writing that in the first place.
> http://lkml.org/lkml/2008/5/20/135)
> It's somewhat out of date and incomplete, but there is a white paper draft at
> http://www-sigproc.eng.cam.ac.uk/~jic23/iio.pdf
> 
> I'll take a look at the actual code tomorrow.  Always good to see another
> accelerometer driver.

-- 
Jean Delvare
