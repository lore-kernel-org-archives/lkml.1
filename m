Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXHBIxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXHBIxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXHBIxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:53:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbXHBIxm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:53:42 -0400
Date: Thu, 2 Aug 2007 01:52:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel@vger.kernel.org, trenn@suse.de, pavel@ucw.cz,
       mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-Id: <20070802015248.45a40717.akpm@linux-foundation.org>
In-Reply-To: <46B1988C.3090302@t-online.de>
References: <46B1988C.3090302@t-online.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 10:40:44 +0200 Knut Petersen <Knut_Petersen@t-online.de> wrote:

> Hi everybody!
> 
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
> 
> Possible solutions:
> 
> 1. Get a better BIOS! --- There is none.
> 
> 2. Fix DSDT!  --- Recompiling gives a number of errors ... I do not  know
> how to fix it.
> 
> 3. Don´t include thermal.c! --- That does help, but as this is a 24/7
> system, the
> cpu fan could break. At that time I do not want to rely on the BIOS to
> save my
> system (the next trip point is at 100 deg. Celsius).
> 
> 4. Revert Len Browns commit 11ccc0f249cb01a129f54760b8ff087f242935d4
> 
> I would vote for option 4, but I do understand some of the arguments of
> Len in
> the 2.6.22-rc1-mm1 discussion in May. Yes, communicating trip points to
> thermal.c is a hack, it will fail on systems that change trip points
> dynamically
> and it might be dangerous for the machine if unreasonable trip points
> are chosen.
> But it does help to keep the machine quiet, and to work around a too low
> or too
> trip points defined by the BIOS.

I didn't understand the arguments either, actually.

Here we had obviously-useful-to-you functionality which was taken away
without, afaik, providing any alternative.

> If it should be not acceptable to revert the questionable commit without
> changes,
> would it be acceptable to make rw trip_points a kernel config option?

Well we obviously need to do _something_.  And reverting that commit until
we get a decent replacement in place sounds like a fine idea to me.

