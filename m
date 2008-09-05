Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYIENuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYIENuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYIENt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:49:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12659 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYIENt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:49:56 -0400
Date: Fri, 5 Sep 2008 15:49:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: qestion about I2C_CLASS_HWMON flag
Message-ID: <20080905154948.24d2b460@hyperion.delvare>
In-Reply-To: <38b2ab8a0809050638m524feaeet51817a8207505b87@mail.gmail.com>
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	<38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
	<20080904103707.557ac764@hyperion.delvare>
	<38b2ab8a0809040149u2bc0342h5c32b87f9277322f@mail.gmail.com>
	<20080904120855.7e7b9720@hyperion.delvare>
	<38b2ab8a0809050157yfb21b08v23ae368d3337c1ca@mail.gmail.com>
	<20080905112056.44b7b910@hyperion.delvare>
	<38b2ab8a0809050544l1914530clec53494e12c77ff5@mail.gmail.com>
	<20080905151157.21b7f8ce@hyperion.delvare>
	<38b2ab8a0809050638m524feaeet51817a8207505b87@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 15:38:23 +0200, Francis Moreau wrote:
> On Fri, Sep 5, 2008 at 3:11 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > It's not about hacking, it can be done cleanly. Just have the adapter
> > driver code check for information in the platform data, and if class
> > information is provided, use that instead of the default value. Or if
> > all users will provide the information, don't even have a default in
> > the driver. Again, the class flags are a (needed) mechanism, the policy
> > is left for driver authors and platform maintainers to establish.
> 
> Ah OK I see now.
> 
> On v2.6.23 i2c-gpio.c had no I2C_CLASS_HWMON flag set and
> had no way to pass this info from platform board.
> 
> But on v2.6.27 it is now set whatever the platforms.
> 
> Wouldn't it have been better to allow the platform code to pass this type
> information through the 'i2c_gpio_platform_data' structure for example ?

If you have a need for that, sure. If you don't, that's making the code
more complex for no good reason.

I expect I2C_CLASS_HWMON to be removed from that driver soon. Now that
almost all hwmon drivers have been converted to support instantiated
I2C devices, and given that all users of i2c-gpio are embedded
architectures with platform code, it should be no longer needed. But
again I am leaving it to whoever is actually using this driver to
decide what is best for them.

-- 
Jean Delvare
