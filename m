Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXJAAHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXJAAHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 20:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXJAAHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 20:07:37 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:48494 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbXJAAHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 20:07:36 -0400
From: Frans Pop <elendil@planet.nl>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Date: Mon, 1 Oct 2007 02:07:33 +0200
User-Agent: KMail/1.9.7
References: <200709282225.21530.elendil@planet.nl> <200709302350.30612.elendil@planet.nl> <20071001000037.475473bd@laptop.hypervisor.org>
In-Reply-To: <20071001000037.475473bd@laptop.hypervisor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010207.34430.elendil@planet.nl>
X-OriginalArrivalTime: 01 Oct 2007 00:07:34.0757 (UTC) FILETIME=[11842950:01C803BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007, you wrote:
> On Sun, 30 Sep 2007 23:50:29 +0200 Frans Pop (FP) wrote:
> > I'm not sure what you mean. I fetched the branch I think you referred
> > to [1], but when I did a merge of that on top of v2.6.23-rc8-mm2 I
> > got "Already up-to-date", so AFAICT that branch is fully merged into mm
> > and I'm already running with you latest code...
>
> I was suggesting to download 2.6.23-rc8 and applying the -hrt patchset at
> http://www.kernel.org/pub/linux/kernel/people/tglx/hrtimers/2.6.23-rc8/
> on top of it.

Ah, OK. I'm afraid that was not at all clear from your previous message :-/

During 'make oldconfig' I got a config question about "CPU idle support", 
which does not seem to be in rc8-mm2; is that correct? I answered N.

> That excludes all the extra stuff in -mm and should give us a good hint
> whether HPET is really at fault.

The system does boot with rc8 + hrt1.

Andrew: any suggestions on how to trace the "real" culprit for the hang?


Udo: I did see one issue during boot with this rc8 + hrt1 kernel.
     System is Debian unstable.
Setting the system clock..
select() to /dev/rtc to wait for clock tick timed out

Also, if the patchset really is not the same as in mm, then that at least 
partially invalidates this test.

Relevant lines from dmesg diff:
-Linux version 2.6.23-rc6 [...]
+Linux version 2.6.23-rc8-hrt1 [...]
[...]
+hpet clockevent registered
+hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
+hpet0: 3 64-bit timers, 14318180 Hz
 ACPI: RTC can wake from S4
 Time: tsc clocksource has been installed.
[...]
-Marking TSC unstable due to: possible TSC halt in C2.
-Time: acpi_pm clocksource has been installed.
[...]
-Clocksource tsc unstable (delta = -473964036 ns)
[...]
 Real Time Clock Driver v1.12ac
[...]
+Marking TSC unstable due to: cpufreq changes.
+Time: hpet clocksource has been installed.
+Clocksource tsc unstable (delta = -125526392 ns)

# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
hpet acpi_pm pit jiffies tsc
# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
hpet

I noted that acpi_pm is no longer mentioned in dmesg, but is still present.

Cheers,
FJP
