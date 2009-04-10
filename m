Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbZDJPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbZDJPf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbZDJPfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:35:03 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51074 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZDJPe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=H7/vVNgWy7JK5H5Nq0HQwxiFwDuf7aDOufkUCcXVnbJO6IT3k0mPCjdgfyTPdWm1sD
         OKSDmL/IVX+oaaD1iJ3cjBO17tsKQ1tpKruK9gtPeuJpYWsOZGV6WzfuieYA0iYES4se
         QnGdKxAQDsjtL8c1UqbSqymstzsJnBmeKJ7Gk=
Message-ID: <49DF6835.9040501@tuffmail.co.uk>
Date: Fri, 10 Apr 2009 16:39:33 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Regression: 20 ACPI interrupts per second on EEEPC 4G
Content-Type: multipart/mixed;
 boundary="------------080501080405070107050804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080501080405070107050804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On latest git, powertop shows 20 ACPI interrupts per second.  
Previously, this was closer to 1 per second.  See attached output (a vs 
b, "a" is from 2.6.29-rc8).

This is from a pretty sparse KDE desktop.  Normally I run 
gnome-power-manager, but I killed it to make sure that wasn't causing 
any problems.

alan@alan-eeepc:/sys/firmware/acpi/interrupts$ grep -v "invalid" *
error:       0
ff_gbl_lock:       0    enabled
ff_pwr_btn:       0     enabled
ff_rt_clk:       0      disabled
gpe03:       0  disabled
gpe04:       0  disabled
gpe05:       0  disabled
gpe09:       0  disabled
gpe0B:       0  disabled
gpe0C:       0  disabled
gpe0D:       0  disabled
gpe0E:       0  disabled
gpe18:   60975  enabled
gpe_all:   60975
sci:   60975

which I presume means lots of EC interrupts.

[    0.134068] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62

Any ideas?

Thanks
Alan

--------------080501080405070107050804
Content-Type: text/plain;
 name="a"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="a"

PowerTOP 1.11   (C) 2007, 2008 Intel Corporation 

Collecting data for 100 seconds 


Cn	          Avg residency
C0 (cpu running)        ( 0.0%)
polling		  0.0ms ( 0.0%)
C1		  0.1ms ( 0.0%)
C2		  0.0ms ( 0.0%)
C3		 93.5ms (100.0%)
P-states (frequencies)
Wakeups-from-idle per second : 10.7	interval: 100.0s
no ACPI power usage estimate available
Top causes for wakeups:
  17.0% (  2.0)       <interrupt> : ehci_hcd:usb1, uhci_hcd:usb2 
  15.1% (  1.8)       <interrupt> : extra timer interrupt 
  12.7% (  1.5)             udevd : ehci_work (ehci_watchdog) 
   8.6% (  1.0)              Xorg : schedule_hrtimeout_range (hrtimer_wakeup) 
   8.5% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup) 
   8.5% (  1.0)              kwin : schedule_hrtimeout_range (hrtimer_wakeup) 
   8.5% (  1.0)   USB device  1-5 : UB6225 (ENE) 
   4.2% (  0.5)   hald-addon-stor : schedule_hrtimeout_range (hrtimer_wakeup) 
   2.4% (  0.3)       <interrupt> : ata_piix 
   2.1% (  0.2)    NetworkManager : atl2_open (atl2_watchdog) 
   1.8% (  0.2)       <interrupt> : acpi 
   1.7% (  0.2)              kded : schedule_hrtimeout_range (hrtimer_wakeup) 
   1.7% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
   1.6% (  0.2)              init : schedule_hrtimeout_range (hrtimer_wakeup) 
   1.0% (  0.1)   <kernel module> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   1.0% (  0.1)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
   0.8% (  0.1)         ssh-agent : schedule_hrtimeout_range (hrtimer_wakeup) 
   0.8% (  0.1)         klauncher : schedule_hrtimeout_range (hrtimer_wakeup) 
   0.3% (  0.0)   <kernel module> : acpi_thermal_check (acpi_thermal_run) 
   0.3% (  0.0)       scsi_scan_2 : blk_add_timer (blk_rq_timed_out_timer) 
   0.3% (  0.0)     <kernel core> : blk_add_timer (blk_rq_timed_out_timer) 
   0.3% (  0.0)              hald : schedule_hrtimeout_range (hrtimer_wakeup) 
   0.2% (  0.0)          kdesktop : schedule_hrtimeout_range (hrtimer_wakeup) 
   0.2% (  0.0)     <kernel core> : queue_delayed_work (delayed_work_timer_fn) 
   0.2% (  0.0)            kicker : schedule_hrtimeout_range (hrtimer_wakeup) 
   0.1% (  0.0)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   0.1% (  0.0)              cron : do_nanosleep (hrtimer_wakeup) 
   0.1% (  0.0)     <kernel core> : addrconf_verify (addrconf_verify) 
   0.1% (  0.0)     <kernel core> : inet_initpeers (peer_check_expire) 
   0.1% (  0.0)          rsyslogd : futex_wait (hrtimer_wakeup) 

A USB device is active 100.0% of the time:
USB device  1-5 : UB6225 (ENE)

Suggestion: Enable USB autosuspend by pressing the U key or adding 
usbcore.autosuspend=1 to the kernel command line in the grub config

Suggestion: increase the VM dirty writeback time from 4.99 to 15 seconds with:
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 
This wakes the disk up less frequently for background VM activity

Suggestion: Disable 'hal' from polling your cdrom with:  
hal-disable-polling --device /dev/cdrom 'hal' is the component that auto-opens a
window if you plug in a CD but disables SATA power saving from kicking in.

Recent USB suspend statistics
Active  Device name
100.0%	USB device  1-5 : UB6225 (ENE)
  0.0%	USB device usb5 : UHCI Host Controller (Linux 2.6.29-rc8eeepc uhci_hcd)
  0.0%	USB device usb4 : UHCI Host Controller (Linux 2.6.29-rc8eeepc uhci_hcd)
  0.0%	USB device usb3 : UHCI Host Controller (Linux 2.6.29-rc8eeepc uhci_hcd)
  0.0%	USB device usb2 : UHCI Host Controller (Linux 2.6.29-rc8eeepc uhci_hcd)
100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.29-rc8eeepc ehci_hcd)

--------------080501080405070107050804
Content-Type: text/plain;
 name="b"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="b"

PowerTOP 1.11   (C) 2007, 2008 Intel Corporation 

Collecting data for 100 seconds 


Cn	          Avg residency
C0 (cpu running)        ( 0.3%)
polling		  0.0ms ( 0.0%)
C1		  0.0ms ( 0.0%)
C2		  1.1ms ( 0.0%)
C3		 42.1ms (99.7%)
P-states (frequencies)
Wakeups-from-idle per second : 23.9	interval: 100.0s
no ACPI power usage estimate available
Top causes for wakeups:
  64.2% ( 19.7)       <interrupt> : acpi 
  10.6% (  3.3)          events/0 : queue_delayed_work (delayed_work_timer_fn) 
   9.0% (  2.8)       <interrupt> : extra timer interrupt 
   3.4% (  1.0)              kwin : hrtimer_start_range_ns (hrtimer_wakeup) 
   3.3% (  1.0)              Xorg : hrtimer_start_range_ns (hrtimer_wakeup) 
   3.3% (  1.0)          kwrapper : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.8% (  0.2)       <interrupt> : ata_piix 
   0.8% (  0.2)    NetworkManager : atl2_open (atl2_watchdog) 
   0.7% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
   0.7% (  0.2)              kded : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.6% (  0.2)              init : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.4% (  0.1)     <kernel core> : add_timer (neigh_periodic_timer) 
   0.4% (  0.1)   <kernel module> : add_timer (neigh_periodic_timer) 
   0.3% (  0.1)         ssh-agent : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.3% (  0.1)          kdesktop : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.2% (  0.1)           konsole : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.2% (  0.1)   knetworkmanager : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.2% (  0.1)              kmix : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.1% (  0.0)            kicker : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.1% (  0.0)              hald : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.1% (  0.0)           async/1 : blk_add_timer (blk_rq_timed_out_timer) 
   0.1% (  0.0)           pdflush : blk_plug_device (blk_unplug_timeout) 
   0.1% (  0.0)     <kernel core> : queue_delayed_work (delayed_work_timer_fn) 
   0.0% (  0.0)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   0.0% (  0.0)       <interrupt> : uhci_hcd:usb5, HDA Intel, i915@pci:0000:00:02.0 
   0.0% (  0.0)   <kernel module> : queue_delayed_work (delayed_work_timer_fn) 
   0.0% (  0.0)         hd-audio0 : schedule_timeout_uninterruptible (process_timeout) 
   0.0% (  0.0)              cron : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.0% (  0.0)          rsyslogd : hrtimer_start_range_ns (hrtimer_wakeup) 
   0.0% (  0.0)        khungtaskd : schedule_timeout_interruptible (process_timeout) 
   0.0% (  0.0)   <kernel module> : add_timer (addrconf_verify) 
   0.0% (  0.0)     <kernel core> : add_timer (peer_check_expire) 

A USB device is active 100.0% of the time:
USB device  1-5 : UB6225 (ENE)

Suggestion: Enable USB autosuspend by pressing the U key or adding 
usbcore.autosuspend=1 to the kernel command line in the grub config

Suggestion: increase the VM dirty writeback time from 5.00 to 15 seconds with:
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 
This wakes the disk up less frequently for background VM activity

Recent USB suspend statistics
Active  Device name
100.0%	USB device  1-5 : UB6225 (ENE)
  0.0%	USB device usb5 : UHCI Host Controller (Linux 2.6.30-rc1eeepc uhci_hcd)
  0.0%	USB device usb4 : UHCI Host Controller (Linux 2.6.30-rc1eeepc uhci_hcd)
  0.0%	USB device usb3 : UHCI Host Controller (Linux 2.6.30-rc1eeepc uhci_hcd)
  0.0%	USB device usb2 : UHCI Host Controller (Linux 2.6.30-rc1eeepc uhci_hcd)
100.0%	USB device usb1 : EHCI Host Controller (Linux 2.6.30-rc1eeepc ehci_hcd)

--------------080501080405070107050804--
