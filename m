Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYEHOFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYEHOFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYEHOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:05:09 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:40596 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751099AbYEHOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:05:08 -0400
X-YMail-OSG: KhAR.LAVM1m.lV2Z_o3dUQlPtBt53pOdyhy.Ib3hDdTm7r_VabpjPjG5gwJ13tp5yA--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Thu, 8 May 2008 07:05:05 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Gabriel C <nix.or.die@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       hmh@hmh.eng.br
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <295530.5900.qm@web32602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Gabriel C <nix.or.die@googlemail.com>
> To: Thomas Gleixner <tglx@linutronix.de>
> Cc: Martin Knoblauch <spamtrap@knobisoft.de>; Bart Van Assche <bart.vanassche@gmail.com>; linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Thursday, May 8, 2008 2:21:57 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> Thomas Gleixner wrote:
> > On Wed, 7 May 2008, Martin Knoblauch wrote:
> >>> no this looks different. As soon as the timesource is detected, I see 
> non-zero 
> >>> timestamps
> >>> in dmesg, but they look smaller and jump in both directions. And I have 
> never 
> >>> seen this before
> >>> 2.6.25.
> >>>
> >>> It actually might be a good idea to get the dmesg output from 2.6.24.
> >>>
> >>> Cheers
> >>> Martin
> >>  interesting - maybe related to clocksources. The HPET seems to be detected 
> later in 2.6.25:
> >>
> >> 2.6.24:
> >>
> >> [    0.000000] Initializing CPU#0
> >> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> >> -->[    0.000000] hpet clockevent registered
> >> -->[    0.000000] TSC calibrated against HPET
> >  
> >> 2.6.25.2:
> >>
> >> [    0.000000] Initializing CPU#0
> >> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> >> -->[    0.000000] TSC calibrated against PM_TIMER
> >  
> > That's odd indeed. Is HPET not registered at all in 2.6.25 or does it just 
> happen late ?
> > 
> > please provide the output of:
> > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > /sys/devices/system/clocksource/clocksource0/current_clocksource
> 
> I was about to report / ask bout this issue too.
> 
> I see the same output for >=2.6.25 , TSC calibrated against PM_TIMER and not 
> against HPET anymore.
> 
> 
> [    0.000000] TSC calibrated against PM_TIMER
> [    0.000016] time.c: Detected 2499.949 MHz processor.
> ...
> [    0.000999] hpet clockevent registered
> 
> So it seems to register to late in >=2.6.25 kernels ?
> 
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> tsc hpet acpi_pm jiffies
> 
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> 
> 
on two different systems running 2.6.25.2:

ibm x3650(2xDualCore)
-------------------------------------
[root@lpsdm60 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc hpet acpi_pm jiffies
[root@lpsdm60 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

HP Proliant DL-380G4 (2xSingleCore)
------------------------------------------------------------
[root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc hpet acpi_pm jiffies
[root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

and on the DL380G4 running 2.6.24:
---------------------------------------------------------
[root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
hpet acpi_pm jiffies tsc
[root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
hpet


Cheers
Martin
