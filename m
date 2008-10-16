Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYJPVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYJPVl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYJPVlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:41:18 -0400
Received: from mx0.towertech.it ([213.215.222.73]:41858 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753077AbYJPVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:41:18 -0400
Date: Thu, 16 Oct 2008 23:41:08 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org,
       =?ISO-8859-1?Q?J=FCri?= Reitel <juri.reitel@liewenthal.ee>,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Jean Delvare <khali@linux-fr.org>, Rodolfo Giometti <giometti@linux.it>
Subject: Re: [rtc-linux] Re: invalid default values in RTC chip
Message-ID: <20081016234108.1268f65c@i1501.lan.towertech.it>
In-Reply-To: <20081016135846.8b06d9f8.akpm@linux-foundation.org>
References: <48F45FA5.6040308@liewenthal.ee>
	<20081016135846.8b06d9f8.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 13:58:46 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > My question relates to RTC driver linux/drivers/rtc/rtc-ds1307.c for 
> > device m41t00. Driver probe function will fail if some of the chip's 
> > registers contain invalid date time values i.e. if month register is 32 
> > or minutes is 61. Is this correct behavior? Probe function's purpose is 
> > to check if the device is as was assumed (this time RTC and it is). The 
> > chip's values are incorrect but the chip works, even the m41t00 chip 
> > manual states that after initial powerup (RTC battery power applied) 
> > internal registers will contain random data.
> > 
> > There are two solutions first is driver patch and another is i2c-dev and 
> > i2cset tool to use from user space during bootup. Whitch one should be used?

 Given we transitioned to the new i2c model, which mandates
 a platform device to be declared, there's no more the need
 to check for the device in the probing function.

 this should be fixed in the driver.

 however, a driver may still return a failure when reading
 the time if there are inappropriate values in the registers.

 the solution is to patch the driver for detection and then
 use a recent hwclock on bootup to write the time if required.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

