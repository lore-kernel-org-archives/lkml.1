Return-Path: <linux-kernel-owner+w=401wt.eu-S1031693AbXEDVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031693AbXEDVDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031701AbXEDVDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:03:45 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:40233 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031693AbXEDVDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:03:44 -0400
Date: Fri, 4 May 2007 23:02:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: john stultz <johnstul@us.ibm.com>
cc: davej@codemonkey.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <1178311052.6094.0.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705042259160.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <1178311052.6094.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 13:37, john stultz wrote:
>> 
>> I found that setting the cpufreq governor to ondemand making the box 
>> lock up solid in 2.6.20.2 and 2.6.21 after a few seconds. Sysrq 
>> does not work anymore, and the last messages are:
>> 
>> May  3 19:16:58 cn kernel: longhaul: VIA C3 'Nehemiah C' [C5P] CPU 
>> detected.  Powersaver supported.
>> May  3 19:16:58 cn kernel: longhaul: Using northbridge support.
>> May  3 19:17:22 cn kernel: Time: acpi_pm clocksource has been installed.
>> May  3 19:17:22 cn kernel: Clocksource tsc unstable (delta = -136422685 
>> ns)
>
>What happens if you boot wihtout the ondemand governor but w/
>clocksource=acpi_pm ?

I always let it boot with the default gov (performance), then
use cpufreq-set to change it.

acpi_pm+performance behaves like tsc+performance, which works

When switching from tsc+performance to (tsc+)ondemand, acpi_pm gets
used because of the unstable tsc (of course, since we changed
frequency and the cpu does NOT have constant_tsc), so it's
becoming acpi_pm+ondemand naturally.

Switching from acpi_pm+performance to acpi_pm+ondemand also
locks up after a few minutes.


Jan
-- 
