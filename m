Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0BVVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:50:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:52602 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754170Ab0BVVuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:50:09 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+ZHMoU8bKZTHAyEfNaOeOVg3OUeBsn7240mhoZyZ
	q9CadT7tyuhjne
Date: Mon, 22 Feb 2010 22:50:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: What's the right value for idle= (was: Re: [linux-pm] regression
 on P-II SMP)
In-Reply-To: <20100221131144.34a9b8e1@infradead.org>
Message-ID: <Pine.LNX.4.64.1002222241430.4120@axis700.grange>
References: <Pine.LNX.4.64.1002212117540.9624@axis700.grange>
 <201002212136.03783.rjw@sisk.pl> <20100221131144.34a9b8e1@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Arjan van de Ven wrote:

> can you get us /proc/cpuinfo ?
> (only one of the cpus, the other ones are just duplicates)

They are a bit different (different stepping):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 5
model name	: Pentium II (Deschutes)
stepping	: 2
cpu MHz		: 399.077
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr
bogomips	: 799.35
clflush size	: 32

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 5
model name	: Pentium II (Deschutes)
stepping	: 1
cpu MHz		: 399.077
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr
bogomips	: 798.19
clflush size	: 32

> if the CPU advertizes mwait, we normally ought to use it,
> but there's some exceptions to that due to buggy-as-**** bioses.
> 
> can you also run powertop -d and get that output ?
> (preferably on a fully known working kernel)

on 2.6.25 with "root=/dev/sdb1 acpi=noirq scsi_mod.scan=sync netconsole=..." 
kernel command line (dmesg follows in a reply to another mail)

# powertop -d
PowerTOP 1.10    (C) 2007, 2008 Intel Corporation

Collecting data for 15 seconds


< Detailed C-state information is not available.>
P-states (frequencies)
Wakeups-from-idle per second : 40.3     interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
  41.2% ( 26.1)       <interrupt> : ohci_hcd:usb3, tmscsim
  40.2% ( 25.5)       <interrupt> : ohci_hcd:usb1, bttv0
   6.3% (  4.0)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
   3.2% (  2.0)     <kernel core> : clocksource_register (clocksource_watchdog)
   3.2% (  2.0)     <kernel core> : sym_timer (sym53c8xx_timer)
   0.9% (  0.6)       <interrupt> : eth0
   0.8% (  0.5)   hald-addon-stor : schedule_timeout (process_timeout)
   0.8% (  0.5)     <kernel core> : __netdev_watchdog_up (dev_watchdog)
   0.8% (  0.5)     <kernel core> : e100_up (e100_watchdog)
   0.7% (  0.5)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer)
   0.3% (  0.2)       <interrupt> : sym53c8xx
   0.3% (  0.2)              init : schedule_timeout (process_timeout)
   0.3% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn)
   0.3% (  0.2)   hald-addon-acpi : do_nanosleep (hrtimer_wakeup)
   0.1% (  0.1)              sshd : sk_reset_timer (tcp_write_timer)
   0.1% (  0.1)     <kernel core> : neigh_add_timer (neigh_timer_handler)
   0.1% (  0.1)                sh : start_this_handle (commit_timeout)
   0.1% (  0.1)              cron : do_nanosleep (hrtimer_wakeup)
   0.1% (  0.1)           syslogd : do_setitimer (it_real_fn)

A USB device is active  0.0% of the time:
/sys/bus/usb/devices/3-2.3

Suggestion: increase the VM dirty writeback time from 5.00 to 15 seconds 
with:
  echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
This wakes the disk up less frequenty for background VM activity

Suggestion: enable the noatime filesystem option by executing the 
following command:
   mount -o remount,noatime /          or by pressing the T key
noatime disables persistent access time of file accesses, which causes lots of disk IO.

Suggestion: Disable 'hal' from polling your cdrom with:
hal-disable-polling --device /dev/cdrom 'hal' is the component that auto-opens a
window if you plug in a CD but disables SATA power saving from kicking in.

Suggestion: Enable the CONFIG_CPU_FREQ_STAT kernel configuration option.
This option allows PowerTOP to show P-state percentages
P-states correspond to CPU frequencies.

Suggestion: Enable the CONFIG_ACPI_BATTERY kernel configuration option.
 This option is required to get power estimages from PowerTOP

Suggestion: Enable the CONFIG_CPU_FREQ_GOV_ONDEMAND kernel configuration option.
The 'ondemand' CPU speed governor will minimize the CPU power usage while
giving you performance when it is needed.

Suggestion: Enable the CONFIG_USB_SUSPEND kernel configuration option.
This option will automatically disable UHCI USB when not in use, and may
save approximately 1 Watt of power.

Recent USB suspend statistics
Active  Device name
  0.0%  USB device usb5 : EHCI Host Controller (Linux 2.6.25 ehci_hcd)
  0.0%  USB device usb4 : UHCI Host Controller (Linux 2.6.25 uhci_hcd)
  0.0%  USB device 3-2.4 : USB Multimedia Keyboard (BTC)
  0.0%  /sys/bus/usb/devices/3-2.3
  0.0%  USB device  3-2 : Generic USB Hub (ALCOR)
  0.0%  USB device usb3 : OHCI Host Controller (Linux 2.6.25 ohci_hcd)
  0.0%  USB device usb2 : OHCI Host Controller (Linux 2.6.25 ohci_hcd)
  0.0%  USB device usb1 : OHCI Host Controller (Linux 2.6.25 ohci_hcd)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
