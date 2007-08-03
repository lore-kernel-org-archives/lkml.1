Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbXHCSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbXHCSfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXHCSfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:35:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:46128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbXHCSfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:35:42 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Subject: Re: 2.6.22 regression: thermal trip points
Date: Fri, 3 Aug 2007 14:35:25 -0400
User-Agent: KMail/1.9.5
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, trenn@suse.de, pavel@ucw.cz,
       mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org
References: <46B1988C.3090302@t-online.de> <200708021756.30776.lenb@kernel.org> <46B314F0.1070503@mandic.com.br>
In-Reply-To: <46B314F0.1070503@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031435.25416.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 07:43, Renato S. Yamane wrote:
> Len Brown escreveu:
> > On Thursday 02 August 2007 04:40, Knut Petersen wrote:
> >> mainboard: AOpen i915GMm-hfs, AWARD BIOS
> >> cpu: Pentium-M 750 (0.8 to 1.86 MHz)
> >> openSuSE 10.2 with kernel 2.6.22.1
> >>
> >> The cpu fan can not be controled by linux kernel.
> >> The BIOS will switch on the cpu fan a bit above 50 deg. Celsius.
> >> The active and passive trip points both are set to 50 deg. Celsius.
> >> Temperature of the idle cpu at 800 Mhz: 34 to 42 deg. C.
> >> The BIOS never changes the trip points.
> >> Cpufreq does work perfectly.
> 
> On my Toshiba M45-S355 (Toshiba Bios, Pentium M 750 - 0.8 at 1.86GHz, 
> Debian Etch) I see the same using Kernel 2.6.21.6
> 
> >> Previously there was the possibility  to add something like
> >>
> >> echo  "100:0:65:70:0" > /proc/acpi/thermal_zone/THRM/trip_points
> >> echo  2 > /proc/acpi/thermal_zone/THRM/polling_frequency
> >> echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> 
> I never do that, but see below (Kernel 2.6.21.6):
> 
> cat /proc/acpi/thermal_zone/TZCL/trip_points
> critical (S5):           105 C
> 
> cat /proc/acpi/thermal_zone/TZCL/polling_frequency
> polling frequency:       2 seconds
> 
> cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> ondemand
> 

Renato,
I don't understand how your Toshiba is similar to Knut's Aopen.
You've got a single critical trip point at 105C, but no active or passive
trip points.

Are you reporting some kind of failure?

The only thing wrong with your system is that polling_frequency != 0 --
but that is probably a distro configuration issue rather than
a kernel issue.

thanks,
-Len

