Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYAMTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYAMTFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 14:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYAMTFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 14:05:10 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:55298 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753533AbYAMTFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 14:05:08 -0500
Date: Sun, 13 Jan 2008 20:05:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Greg KH" <greg@kroah.com>, linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Implement module aliasing for i2c to translate from
 device tree names
Message-ID: <20080113200501.22ee5b0d@hyperion.delvare>
In-Reply-To: <9e4733910801131050h5349f3c7g459f5dfb07724b19@mail.gmail.com>
References: <20071220044136.20091.70984.stgit@terra.home>
	<20071220044138.20091.31417.stgit@terra.home>
	<20080111202015.65c3c160@hyperion.delvare>
	<20080112094658.197acb08@hyperion.delvare>
	<9e4733910801120826haa8905dk863ed1c8e9f420c9@mail.gmail.com>
	<20080113154114.4a1c5166@hyperion.delvare>
	<9e4733910801130824i547b65a9n64e415f9626d6ab5@mail.gmail.com>
	<20080113184017.7e3b409f@hyperion.delvare>
	<9e4733910801131001o604c1474vc2fd021d32b8c2a3@mail.gmail.com>
	<20080113194523.51683e97@hyperion.delvare>
	<9e4733910801131050h5349f3c7g459f5dfb07724b19@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 13:50:46 -0500, Jon Smirl wrote:
> On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> > The eeprom case might be a bit confusing because that i2c driver
> > supports a single device type, so the driver name is the same as the
> > device name. Take a look at the hwmon/lm90 driver for a better example:
> > this device supports 7 different devices. The devices are mostly
> > compatible so it made sense to have a single driver for them, but they
> > all differ in some way. For example, the LM90 doesn't support PEC,
> > while the ADM1032 does. User-space needs to be able to distinguish
> > between the various types. That's the reason why we export the device
> > name through sysfs.
> >
> > Most i2c sensor drivers support several chip types, and libsensors has
> > been relying heavily on the name attribute. Less so with the lm-sensors
> > 3.0.0 rewrite, where most things are automatically detected, but if
> > nothing else, giving humans a way to distinguish between the different
> > sensor chip types is very useful. Also, not everyone will upgrade to
> > lm-sensors 3.0.0 so we need to keep supporting the previous versions.
> 
> Another way to handle this is to have the drivers register multiple
> times using different names. So LM90 would register as both LM90 and
> ADM1032. All the code is shared, you just register it multiple times
> under different names.

This won't let us get rid of the name attribute. As I repeatedly
explained, removing that file now would instantly break at least all
versions of lm-sensors before 3.0.0. This alone is enough to make it
unacceptable for the years to come.

Not to mention that this seems like a waste of kernel memory. The name
attribute certainly takes one order of magnitude less memory than
registering the same driver multiple times.

I'm not sure why you want these i2c chip names to go way, given that
the module aliases you'd like to add are almost the same, just in a
different form and using OF names instead of arbitrary names.

-- 
Jean Delvare
