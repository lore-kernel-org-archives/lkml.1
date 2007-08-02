Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXHBV50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXHBV50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXHBV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:57:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbXHBV5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:57:16 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: 2.6.22 regression: thermal trip points
Date: Thu, 2 Aug 2007 17:56:30 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, trenn@suse.de,
       pavel@ucw.cz, mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org
References: <46B1988C.3090302@t-online.de>
In-Reply-To: <46B1988C.3090302@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708021756.30776.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 04:40, Knut Petersen wrote:

> Kernel 2.6.22 decreases performance by about 50% on my system.
> No, I do not like that. The reason is a broken BIOS, granted, but there
> was a perfect workaround in the kernel that has been dropped.
> 
> mainboard: AOpen i915GMm-hfs, AWARD BIOS
> cpu: Pentium-M 750 (0.8 to 1.86 MHz)
> openSuSE 10.2 with kernel 2.6.22.1
> 
> The cpu fan can not be controled by linux kernel.
> The BIOS will switch on the cpu fan a bit above 50 deg. Celsius.
> The active and passive trip points both are set to 50 deg. Celsius.
> Temperature of the idle cpu at 800 Mhz: 34 to 42 deg. C.
> The BIOS never changes the trip points.
> Cpufreq does work perfectly.
> 
> Previously there was the possibility  to add something like
> 
> echo  "100:0:65:70:0" > /proc/acpi/thermal_zone/THRM/trip_points
> echo  2 > /proc/acpi/thermal_zone/THRM/polling_frequency
> echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> 
> to e.g. /etc/init.d/boot.local. With 2.6.22 that solution does not exist
> any longer. Now the code in thermal.c slows down the cpu under load
> to prevent "overheating". Kernel compile time increases from about 12
> to 18 minutes. No, I don´t like that, nobody would.
 

Thanks for the sighting, Knut!
This regression is dramatic when put in the terms of 50% performance hit!
I guess the good news is that thermal throttling is doing the job
we are asking it to:-)

The statement above regarding the existence of active trip points
and the kernel not being able to control the fan are inconsistent
with each other.

Please open a sighting for this machine here:

http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
vs. Power-Thermal
and attach the output from acpidump, cat /proc/acpi/thermal_zone/*/*
and assign it to len.brown@intel.com

BTW. does the board boot and run properly with "acpi=off"?

thanks,
-Len
