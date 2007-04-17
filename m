Return-Path: <linux-kernel-owner+w=401wt.eu-S1031151AbXDQUNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031151AbXDQUNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031197AbXDQUNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:13:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55941 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031189AbXDQUNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:13:00 -0400
Subject: Re: Fw: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
From: john stultz <johnstul@us.ibm.com>
To: mikpe@it.uu.se
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@stusta.de>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070417100942.c990604b.akpm@linux-foundation.org>
References: <20070417100942.c990604b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 13:12:44 -0700
Message-Id: <1176840764.15198.136.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 10:09 -0700, Andrew Morton wrote:
> I guess this counts as a regression.
> 
> Begin forwarded message:
> 
> Date: Tue, 17 Apr 2007 14:16:25 +0200 (MEST)
> From: Mikael Pettersson 	
> To: linux-kernel@vger.kernel.org
> Subject: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
> 
> 
> The machine is an old Athlon64 laptop (Targa Visionary 811,
> OEMd as the Arima W720-K8, also sold as the eMachines m6805)
> with a VIA K8T800 chipset. ACPI is enabled.
> 
> Up to kernel 2.6.20, time-keeping worked fine. In the
> x86-64 kernel, the clock source is listed as "jiffies".
> 
> With current 2.6.21-rc7, the x86-64 kernel selects
> acpi_pm as its clock source. Unfortunately, with this
> clock time drifts and it loses several minutes per hour.
> 
> What's strange is that the i386 kernel on the same
> machine (with similar .config) does not lose time
> while using the acpi_pm clock source.

Huh. Quite strange as its the same acpi_pm clocksource driver!

The only difference I see right off is that verify_pmtmr_rate() isn't
done on x86_64. Although I'd expect you'd see "PM-Timer running at
invalid rate" w/ the i386 kernel if it made a difference.

Could you send me the dmesg output for both the x86_64 and i386 kernels
you tried?

thanks
-john


