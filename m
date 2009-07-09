Return-Path: <linux-kernel-owner+w=401wt.eu-S1751017AbZGIXXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751017AbZGIXXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbZGIXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:23:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34683 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZGIXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:23:03 -0400
Subject: Re: Clock incorrect on 2.6.31-rc2
From: john stultz <johnstul@us.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090709153855.6230729e@nehalam>
References: <20090709141000.584d199a@nehalam>
	 <1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
	 <20090709153855.6230729e@nehalam>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 16:22:59 -0700
Message-Id: <1247181779.3259.6.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 15:38 -0700, Stephen Hemminger wrote:
> On Thu, 9 Jul 2009 14:58:37 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Thu, Jul 9, 2009 at 2:10 PM, Stephen Hemminger<shemminger@vyatta.com> wrote:
> > > My system (desktop Ubuntu 9.0) runs fine with 2.6.30, but with 2.6.31-rc2 it does
> > > not keep time correctly. Also ntptime reports an error.
> > 
> > Can you better describe how it does not keep time? Is time moving too
> > slow? too fast?
> 
> The clock just seemed to stop, or be wildly stuck in past.

Hrmm. And the box continues to function? If the clock stops, so does
timers, which will usually make a box seem to be totally hung.

>From the messages below, it doesn't seem to be stopped.

> > Could you include output from the following commands with 2.6.31-rc2
> > (and 2.6.30 if you have the time).
> >  $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >  $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >  $ dmesg
> >  $ ntpdc -c peers
> >  $ ntpdc -c kerninfo
> 
> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource 
> tsc hpet acpi_pm 
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> tsc


Ok. One thing to check is if the issue goes away if you either boot with
"clocksource=acpi_pm" or run

echo acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource

> # ntpdc -c peers
>      remote           local      st poll reach  delay   offset    disp
> =======================================================================
> *ussprometheus.r 192.168.1.3      2  128  377 0.09094  0.007730 0.06786

You don't seem to be very far off right now. Only 7ms. And it seems you
have gone into NTP sync state (the * denotes that). 

I'm guessing ntptime no longer gives you errors now?

> # ntpdc -c kerninfo
> pll offset:           0.005107 s
> pll frequency:        155.028 ppm
> maximum error:        0.219122 s
> estimated error:      0.007209 s
> status:               0001  pll
> pll time constant:    7
> precision:            1e-06 s
> frequency tolerance:  500 ppm

This all looks normal.



> $ dmesg
> [    0.000000] Linux version 2.6.31-rc2 (shemminger@nehalam) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #149 SMP Tue Jul 7 18:22:50 PDT 2009
[snip]
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2673.143 MHz processor.

You might watch from boot to boot if the above MHz is varying by too
much.

Everything else looks ok.


I'm a little stumped.  Does the problem occur on every reboot? How long
does the box need to be up before you see an issue?  Or does it go away
after a little while?

thanks
-john


