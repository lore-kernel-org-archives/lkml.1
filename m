Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYCMORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYCMORQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYCMORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:17:00 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:60360 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYCMOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:16:59 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 10:16:58 EDT
Message-ID: <47D93435.1080402@aitel.hist.no>
Date: Thu, 13 Mar 2008 15:03:33 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc5-mm1 shutdown crash
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
In-Reply-To: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel hangs during shutdown, and that prevents automatic poweroff.
I have one small patch that improves the iwl3945 wireless driver a little.
Dell D830 laptop, 64-bit smp


It looks like this:
*** Last service has quit. ***
Your system will now POWER OFF!
Goodbye
Bug: unable to handle kernel paging request at ffffffff8020a7ad
IP: [<ffffffff80211b5a>] text_poke+0xe/0x15
PGD 203067 PUD 2+7+63 PMD 7f3ba163 PTE 20a161
Oops: 0003 [1] SMP
last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/ACPI0003:00/power_supply/AC/online
CPU 0
Modules linked in: tun pcmcia dock piix iTCO_wdt ata_piix watchdog_core 
watchdog_dev intel_agp ata_generic hci_usb

Pid: 7606, comm: initng Not tainted 2.6.25-rc5-mm1

RIP: 0010:[<ffffffff80211b5a>] [<ffffffff80211b5a>]text_poke+0xe/0x15
RSP: 0000:ffff81007e559cb8 EFLAGS: 00010083

(register dump omitted, but I can reproduce anytime if it matters)
Process initng (pid 7606, threadinfo...)
call trace:
alternatives_smp_unlock
alternatives_smp_switch
? schedule_timeout
__cpu_die
_cpu_down
disable_nonboot_cpus
kernel_power_off
sys_reboot
? handle_mm_fault
? __up_read
? do_page_fault
? __put_user
? error_exit
system_call_after_swapgs

(rest omitted)

sysrq still works at this point
sysrq+P gives:

CPU 0:
Modules linked in (same as before)
Pid: 0, comm: swapper Tainted: G D 2.6.25-rc5-mm1
RIP ... acpi_idle_enter
(register dump omitted)
acpi_idle_enter_bm
menu_select
cpuidle_idle_call
cpuidle_idle_call
default_idle
cpu_idle
rest_init


sysrq+O fails to deactivate a mouse, complains that the disk
may not be spun down properly, prepares for sleep state S5,
but don't power off. sysrq doesn't work after this.

Helge Hafting

