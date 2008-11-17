Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYKQCSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYKQCSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 21:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYKQCS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 21:18:27 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:30910 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbYKQCS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 21:18:26 -0500
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.28-rc5] TSC sync error and high hrtimer_start (was: Bootup time regression from 2.6.27 to 2.6.28-rc3+)
Date: Mon, 17 Nov 2008 03:18:22 +0100
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org
References: <20081104173300.GF6134@ics.muni.cz> <200811140245.40505.elendil@planet.nl> <200811162027.44988.elendil@planet.nl>
In-Reply-To: <200811162027.44988.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811170318.23640.elendil@planet.nl>
X-OriginalArrivalTime: 17 Nov 2008 02:18:24.0793 (UTC) FILETIME=[C51B5890:01C9485A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 November 2008, Frans Pop wrote:
> Possibly this may be related to this diff in the boot messages:
> -checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> +checking TSC synchronization [CPU#0 -> CPU#1]:
> +Measured 696 cycles TSC warp between CPUs, turning off TSC clock.
> +Marking TSC unstable due to check_tsc_sync_source failed
>
> With .27.4 TSC _always_ passed. Now, with .28-rc5 I get this warp. I've
> done two boots so far, for the other one the warp was 680 cycles.

Maybe this extra context a bit earlier in dmesg is relevant here:

-Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.76 BogoMIPS (lpj=12799520)
+HPET: 3 timers in total, 0 timers will be used for per-cpu timer
+Calibrating delay loop (skipped), value calculated using timer frequency.. 6399.73 BogoMIPS (lpj=12799476)
[...]
-ACPI: Core revision 20080609
+ACPI: Core revision 20080926
+Setting APIC routing to flat
 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
-Using local APIC timer interrupts.
-APIC timer calibration result 12499520
-Detected 12.499 MHz APIC timer.
-Booting processor 1/1 ip 6000
+Booting processor 1 APIC 0x1 ip 0x6000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 6399.94 BogoMIPS (lpj=12799898)
+Calibrating delay using timer specific routine.. 6198.05 BogoMIPS (lpj=12396107)

Note the rather large difference in BogoMIPS between core 0 and 1.
