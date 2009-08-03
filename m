Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZHCUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZHCUwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZHCUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:52:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58891 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZHCUwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:52:30 -0400
Date: Mon, 3 Aug 2009 13:52:29 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/2] acpi_power_meter: hwmon driver for ACPI 4.0 power
	meters
Message-ID: <20090803205229.GB14694@plum>
Reply-To: djwong@us.ibm.com
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com> <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com> <1248677155.2670.132.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1248677155.2670.132.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 02:45:55PM +0800, Zhang Rui wrote:
> Hi, Darrick,
> 
> great job. :)

Thanks.

> we should at least send a netlink event for an ACPI power meter
> notification, shouldn't we?

Yes, an event would be useful at the very least for when the system starts
capping, though unfortunately there doesn't seem to be a Notify event for when
capping ends.

> we should create the hwmon sysfs I/F for the hwmon device,
> i.e. add the hwmon attributes
> under /sys/devices/LINUXSYS:00/.../ACPI000D:00/hwmon0/
> rather than ﻿/sys/devices/LINUXSYS:00/.../ACPI000D:00/

Hee, this is a tricky matter.  The other hwmon drivers create sysfs attributes
under the sysfs object, not in a separate "hwmonX" object, and as I recall
libsensors reads symlinks under the device object to figure out which bus the
sensor device lives on.  If it can't figure that out, it ignores the hwmon
device.

> 	  if (acpi_disable)
> 		return -ENODEV;

Noted.

> plus, _PMD is not supported in this driver, right?
> I agree with Yakui that we can create some ACPI device sysfs attributes
> besides the hwmon ones. e.g. exporting devices measured by the current
> ACPI power meter device to user space.

I agree.

--D
