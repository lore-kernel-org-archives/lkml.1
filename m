Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYIEJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYIEJVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYIEJVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:21:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45552 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYIEJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:21:06 -0400
Date: Fri, 5 Sep 2008 11:20:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: qestion about I2C_CLASS_HWMON flag
Message-ID: <20080905112056.44b7b910@hyperion.delvare>
In-Reply-To: <38b2ab8a0809050157yfb21b08v23ae368d3337c1ca@mail.gmail.com>
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	<38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
	<20080904103707.557ac764@hyperion.delvare>
	<38b2ab8a0809040149u2bc0342h5c32b87f9277322f@mail.gmail.com>
	<20080904120855.7e7b9720@hyperion.delvare>
	<38b2ab8a0809050157yfb21b08v23ae368d3337c1ca@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 10:57:56 +0200, Francis Moreau wrote:
> Good morning Jean,
> 
> On Thu, Sep 4, 2008 at 12:08 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > In general they can, yes (where they can't, it's due to restrictions in
> > protocol implementations, not device types.) But this isn't a matter of
> > what devices can be on the bus. This is a matter of what devices can be
> > probed for on a given bus. For example, hardware monitoring drivers
> > which handle I2C devices, make sure that I2C_CLASS_HWMON is set before
> > probing I2C addresses on a given bus in search of a device to
> > auto-detect. On the other hand, if they are merely attaching to an I2C
> > device which has already been instantiated (and thus no probing is
> > needed) they do not care about the class. The reason for this mechanism
> > is that probing can be risky, so we want to limit it to what is
> > strictly needed. For example, there is no point in probing the I2C bus
> > of a TV adapter for hardware monitoring chips - there simply can't be
> > any there. If there ever was any, that would be such a special case
> > that we would instantiate the I2C device in question explicitly from
> > the adapter code, so we have no need for probing.
> 
> OK but which devices that can be connected to an I2C bus is platform specific,
> isn't it ? For example, an I2C adapter can be used in a TV and in that
> case there
> may be no point to probe for a HW mon chips but this same I2C adapter can be
> used by other platforms in a different context where there's a HW mon chip.
> 
> So the flags probably are useful, but they're are hard coded in adapters...

Nothing prevents you from setting the class flags based on
platform-specific information if you have a need for that.

That being said, in cases where you have that level of information
about which devices are present on the I2C bus, you probably want to
declare the I2C devices at the platform level, and not rely on probing
at all (so .class is 0).

-- 
Jean Delvare
