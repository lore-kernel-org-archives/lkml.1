Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYAVQLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYAVQLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYAVQLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:11:36 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:55393 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbYAVQLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:11:35 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Date: Tue, 22 Jan 2008 18:11:24 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200801220119.42312.caglar@pardus.org.tr> <200801221755.56470.caglar@pardus.org.tr> <20080122160557.GA31831@elte.hu>
In-Reply-To: <20080122160557.GA31831@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801221811.25867.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22 Oca 2008 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
> 
> * S.Çağlar Onur <caglar@pardus.org.tr> wrote:
> 
> > > My theory is that for whatever reason we get "repeat" IPIs: multiple 
> > > reschedule IPIs although the other CPU only initiated one.
> > 
> > Ok, please see http://cekirdek.pardus.org.tr/~caglar/dmesg.3rd :)
> 
> hm, the IPI sending and receiving is nicely paired up:
> 
> [  625.795008] IPI (@smp_reschedule_interrupt) from task swapper:0 on CPU#1:
> [  625.795223] IPI (@native_smp_send_reschedule) from task amarokapp:2882 on CPU#1:
> 
> amarokapp does wake up threads every 20 microseconds - that could 
> explain it. It's probably Xorg running on one core, amarokapp on the 
> other core. That's already 100 reschedules/sec.

Heh, killing amarok ends up with following;

     PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0,9%)
C1                0,0ms ( 0,0%)
C2                0,2ms ( 0,0%)
C3                5,1ms (99,1%)


Wakeups-from-idle per second : 197,8    interval: 10,0s
no ACPI power usage estimate available

Top causes for wakeups:
  34,7% (130,7)   USB device  3-2 : HP Integrated Module (Broadcom Corp)
  26,5% (100,0)       <interrupt> : uhci_hcd:usb3
   5,8% ( 22,0)              java : futex_wait (hrtimer_wakeup)
   5,3% ( 20,0)       <interrupt> : iwl3945
   4,1% ( 15,4)   USB device  2-2 : Microsoft Wireless Optical Mouse .00 (Microsoft)
   2,9% ( 11,0)       <interrupt> : libata
   2,7% ( 10,1)       <interrupt> : extra timer interrupt
   2,7% ( 10,0)              java : schedule_timeout (process_timeout)
   2,7% ( 10,0)     <kernel core> : scan_async (ehci_watchdog)
   2,4% (  9,0)      <kernel IPI> : Rescheduling interrupts
   2,1% (  8,0)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
   1,7% (  6,4)       <interrupt> : uhci_hcd:usb2
   1,7% (  6,4)             artsd : schedule_timeout (process_timeout)
   0,6% (  2,1)       <interrupt> : ohci1394, uhci_hcd:usb4, nvidia
   0,5% (  2,0)     <kernel core> : clocksource_check_watchdog (clocksource_watchdog)
   0,5% (  1,7)    wpa_supplicant : schedule_timeout (process_timeout)
   0,3% (  1,0)            kicker : schedule_timeout (process_timeout)
   0,3% (  1,0)              kwin : schedule_timeout (process_timeout)
   0,3% (  1,0)          kdesktop : schedule_timeout (process_timeout)
   0,3% (  1,0)           klipper : schedule_timeout (process_timeout)
   0,3% (  1,0)          kwrapper : do_nanosleep (hrtimer_wakeup)
   0,3% (  1,0)                 X : nv_start_rc_timer (nv_kern_rc_timer)

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
