Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYAVQW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYAVQW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYAVQWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:22:16 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:40872 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbYAVQWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:22:15 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Date: Tue, 22 Jan 2008 18:22:04 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200801220119.42312.caglar@pardus.org.tr> <20080122160557.GA31831@elte.hu> <200801221811.25867.caglar@pardus.org.tr>
In-Reply-To: <200801221811.25867.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801221822.05659.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

22 Oca 2008 Sal tarihinde, S.Çağlar Onur şunları yazmıştı: 
> > hm, the IPI sending and receiving is nicely paired up:
> > 
> > [  625.795008] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
> > [  625.795223] IPI (@native_smp_send_reschedule) from task amarokapp:2882 on CPU#1:
> > 
> > amarokapp does wake up threads every 20 microseconds - that could 
> > explain it. It's probably Xorg running on one core, amarokapp on the 
> > other core. That's already 100 reschedules/sec.
> 
> Heh, killing amarok ends up with following;
> 
>      PowerTOP version 1.9       (C) 2007 Intel Corporation
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        ( 0,9%)
> C1                0,0ms ( 0,0%)
> C2                0,2ms ( 0,0%)
> C3                5,1ms (99,1%)
> 
> 
> Wakeups-from-idle per second : 197,8    interval: 10,0s
> no ACPI power usage estimate available
> 
> Top causes for wakeups:
>   34,7% (130,7)   USB device  3-2 : HP Integrated Module (Broadcom Corp)
>   26,5% (100,0)       <interrupt> : uhci_hcd:usb3
>    5,8% ( 22,0)              java : futex_wait (hrtimer_wakeup)
>    5,3% ( 20,0)       <interrupt> : iwl3945
>    4,1% ( 15,4)   USB device  2-2 : Microsoft Wireless Optical Mouse .00 (Microsoft)
>    2,9% ( 11,0)       <interrupt> : libata
>    2,7% ( 10,1)       <interrupt> : extra timer interrupt
>    2,7% ( 10,0)              java : schedule_timeout (process_timeout)
>    2,7% ( 10,0)     <kernel core> : scan_async (ehci_watchdog)
>    2,4% (  9,0)      <kernel IPI> : Rescheduling interrupts
>    2,1% (  8,0)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
>    1,7% (  6,4)       <interrupt> : uhci_hcd:usb2
>    1,7% (  6,4)             artsd : schedule_timeout (process_timeout)
>    0,6% (  2,1)       <interrupt> : ohci1394, uhci_hcd:usb4, nvidia
>    0,5% (  2,0)     <kernel core> : clocksource_check_watchdog (clocksource_watchdog)
>    0,5% (  1,7)    wpa_supplicant : schedule_timeout (process_timeout)
>    0,3% (  1,0)            kicker : schedule_timeout (process_timeout)
>    0,3% (  1,0)              kwin : schedule_timeout (process_timeout)
>    0,3% (  1,0)          kdesktop : schedule_timeout (process_timeout)
>    0,3% (  1,0)           klipper : schedule_timeout (process_timeout)
>    0,3% (  1,0)          kwrapper : do_nanosleep (hrtimer_wakeup)
>    0,3% (  1,0)                 X : nv_start_rc_timer (nv_kern_rc_timer)
 
By the way loging out from KDE also suffers same problem, this time kdm migrated to CPU1 and powertop reports ~300 wakeups for "<kernel IPI> : Rescheduling interrupts" again.

[...]
[ 2058.246692] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#0:
[ 2058.246737] IPI (@native_smp_send_reschedule) from task kdm_greet:6122 on CPU#1:
[ 2058.246812] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
[ 2058.278947] IPI (@native_smp_send_reschedule) from task X:2073 on CPU#0:
[ 2058.279070] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#0:
[ 2058.279175] IPI (@native_smp_send_reschedule) from task kdm_greet:6122 on CPU#1:
[ 2058.279251] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
[ 2058.279301] IPI (@native_smp_send_reschedule) from task X:2073 on CPU#0:
[ 2058.279377] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#0:
[ 2058.279425] IPI (@native_smp_send_reschedule) from task kdm_greet:6122 on CPU#1:
[ 2058.279503] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
[ 2058.279565] IPI (@native_smp_send_reschedule) from task X:2073 on CPU#0:
[ 2058.279637] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#0:
[ 2058.279683] IPI (@native_smp_send_reschedule) from task kdm_greet:6122 on CPU#1:
[ 2058.279758] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
[ 2058.311903] IPI (@native_smp_send_reschedule) from task X:2073 on CPU#0:
[ 2058.312028] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#0:
[...]

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
