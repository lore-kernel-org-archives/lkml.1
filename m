Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZFENvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZFENvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZFENvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:51:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36062 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZFENvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:51:13 -0400
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>
In-Reply-To: <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
Date: Fri, 05 Jun 2009 16:51:13 +0300
Message-Id: <1244209873.23533.29.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin,

On Fri, 2009-06-05 at 15:02 +0200, Corentin Chary wrote:
> > That said, I am more than happy to measure this but I need a little bit
> > more information to get started as I have never used powertop. So what
> > is it exactly you want me to do?
> 
> PowerTop (with a corretly configured kernel) will give you a power
> usage estimate.
> 
> CONFIG_NO_HZ=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_KERNEL=y
> 
> For propers results, shutdown all services and just keep a shell
> (without X or network).
> You can also test that with and without the camera driver.

I did not see a power usage estimate. I am running PowerTOP 1.11 that
comes with Ubuntu 9.04. So I am not sure if what I did is what you
wanted me to do but I ran "powertop -t 60 -d" with camera enabled and
disabled and here are the results.

Also, when I run plain powertop, it keeps complaining that some USB
device causes wakeups (probably the camera?) and suggests suspending.
But doing that doesn't seem to help things.

			Pekka

Camera Disabled
---------------

$ powertop -t 60 -d

PowerTOP 1.11   (C) 2007, 2008 Intel Corporation 

Collecting data for 60 seconds 


Cn	          Avg residency
C0 (cpu running)        ( 0.0%)
polling		  0.0ms ( 0.0%)
C1		  0.0ms ( 0.0%)
C2		  0.9ms ( 0.0%)
C3		966.9ms (100.1%)
P-states (frequencies)
Wakeups-from-idle per second :  1.2	interval: 60.0s
no ACPI power usage estimate available
Top causes for wakeups:
  37.1% (  0.6)     <kernel core> : hrtimer_start (tick_sched_timer) 
  16.5% (  0.3)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
  12.4% (  0.2)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer) 
   8.2% (  0.1)       <interrupt> : acpi 
   6.2% (  0.1)     <kernel core> : sta_info_start (sta_info_cleanup) 
   4.1% (  0.1)       <interrupt> : ata_piix 
   4.1% (  0.1)     <kernel core> : page_writeback_init (wb_timer_fn) 
   4.1% (  0.1)          events/0 : queue_delayed_work (delayed_work_timer_fn) 
   1.0% (  0.0)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   1.0% (  0.0)     <kernel core> : inet_initpeers (peer_check_expire) 
   1.0% (  0.0)     <kernel core> : queue_delayed_work (delayed_work_timer_fn) 
   1.0% (  0.0)       cifsoplockd : schedule_timeout (process_timeout) 
   1.0% (  0.0)           async/2 : scsi_request_fn (blk_rq_timed_out_timer) 
   1.0% (  0.0)        khungtaskd : schedule_timeout (process_timeout) 
   1.0% (  0.0)     <kernel core> : addrconf_verify (addrconf_verify) 

A USB device is active 100.0% of the time:
USB device  1-5 : UB6225 (ENE)

Recent USB suspend statistics
Active  Device name
100.0%	USB device  1-5 : UB6225 (ENE)
  0.0%	USB device usb5 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
  0.0%	USB device usb4 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
  0.0%	USB device usb3 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
  0.0%	USB device usb2 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.30-rc8-eee ehci_hcd)

Camera Enabled
--------------

$ powertop -t 60 -d

PowerTOP 1.11   (C) 2007, 2008 Intel Corporation 

Collecting data for 60 seconds 


Cn	          Avg residency
C0 (cpu running)        ( 0.0%)
polling		  0.0ms ( 0.0%)
C1		  0.0ms ( 0.0%)
C2		  1.0ms ( 0.0%)
C3		 91.9ms (100.0%)
P-states (frequencies)
Wakeups-from-idle per second : 11.1	interval: 60.0s
no ACPI power usage estimate available
Top causes for wakeups:
  48.4% ( 10.6)     <kernel core> : hrtimer_start (tick_sched_timer) 
  45.7% ( 10.0)     <kernel core> : ehci_work (ehci_watchdog) 
   1.7% (  0.4)       <interrupt> : acpi 
   1.2% (  0.3)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   0.8% (  0.2)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer) 
   0.6% (  0.1)       <interrupt> : ata_piix 
   0.5% (  0.1)     <kernel core> : sta_info_start (sta_info_cleanup) 
   0.3% (  0.1)          events/0 : queue_delayed_work (delayed_work_timer_fn) 
   0.3% (  0.1)     <kernel core> : page_writeback_init (wb_timer_fn) 
   0.1% (  0.0)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   0.1% (  0.0)        khungtaskd : schedule_timeout (process_timeout) 
   0.1% (  0.0)     <kernel core> : hangcheck_init (hangcheck_fire) 
   0.1% (  0.0)     <kernel core> : addrconf_verify (addrconf_verify) 
   0.1% (  0.0)           pdflush : __make_request (blk_unplug_timeout) 
   0.1% (  0.0)           async/2 : scsi_request_fn (blk_rq_timed_out_timer) 
   0.1% (  0.0)       cifsoplockd : schedule_timeout (process_timeout) 
   0.1% (  0.0)     <kernel core> : queue_delayed_work (delayed_work_timer_fn) 

A USB device is active 100.0% of the time:
USB device  1-5 : UB6225 (ENE)

Suggestion: Enable USB autosuspend by pressing the U key or adding 
usbcore.autosuspend=1 to the kernel command line in the grub config

Recent USB suspend statistics
Active  Device name
100.0%	/sys/bus/usb/devices/1-8
100.0%	USB device  1-5 : UB6225 (ENE)
  0.0%	USB device usb5 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
  0.0%	USB device usb4 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
  0.0%	USB device usb3 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
  0.0%	USB device usb2 : UHCI Host Controller (Linux 2.6.30-rc8-eee uhci_hcd)
100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.30-rc8-eee ehci_hcd)

			Pekka

