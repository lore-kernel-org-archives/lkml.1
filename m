Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbZEHPNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbZEHPNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZEHPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:12:59 -0400
Received: from science.horizon.com ([192.35.100.1]:64368 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759367AbZEHPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:12:54 -0400
Date: 8 May 2009 11:12:48 -0400
Message-ID: <20090508151248.6888.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: johnstul@us.ibm.com, mingo@elte.hu
Subject: Re: [RFC][PATCH] tsc_khz= boot option to avoid TSC calibration variance
Cc: linux-kernel@vger.kernel.org, linux@horizon.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, ulrich.windl@rz.uni-regensburg.de,
       williams@redhat.com, zippel@linux-m68k.org
In-Reply-To: <20090508121521.GC18758@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wouldnt it be a lot more flexible to have a sysctl for this, which 
> would be set before ntpd is started? (or which would be set by ntpd)

I thought so, but a boot-time option is sufficient and simpler.

> The mechanism and semantics would be similar: we would _not_ expose 
> cpu_khz directly, we'd have a boot_cpu_khz value saved for sure, and 
> we'd allow the sysctl to set the cpu_khz to within 1MHz of cpu_khz - 
> and we'd re-scale the timer irq and other calibrated values 
> accordingly.

Yes, that would be nicer.

> Alternatively, a much simpler method: why doesnt ntpd save its own 
> notion of cpu_khz once it has reached stability, and reads cpu_khz 
> (from /proc/cpuinfo) during bootup and re-scales its initial offset 
> and phase shift accordingly, compensating for that noise? (if it's 
> within 1MHz)

The problem is, it's only an issue if the TSC is used as the system
time base, which is a kernel detail that a) NTP really doesn't want to
be bothered with, and b) can change at run time.

It's possible, but it feels like a kludge.  It's such a Linux-specific
detail that it seems cleaner to fix it at the source.
