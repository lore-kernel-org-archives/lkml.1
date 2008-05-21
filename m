Return-Path: <linux-kernel-owner+w=401wt.eu-S933395AbYEUL5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbYEUL5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbYEUL50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:57:26 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50854 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755334AbYEUL5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:57:25 -0400
Date: Wed, 21 May 2008 06:57:24 -0500
From: Robin Holt <holt@sgi.com>
To: astarikovskiy@suse.de, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Sony laptop battery has odd behavior with 2.6.26-rc3ish build.
Message-ID: <20080521115723.GF4287@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A couple days ago, I updated my test build to commit
8033c6e9736c29cce5f0d0abbca9a44dffb20c39 and noticed an odd behavior
with the battery.  If I unplug the power, the battery discharges and
that is reflected in /proc/acpi/battery/BAT0/state.  I am not certain
the discharge is continuous and uniform or if it goes in steps.  When I
plug the power back in, the level stays at a constant value (+-1mAh)
for a considerable period of time.  It then does a single step back to
the fully charged value.

I have not done any searching to see when this began.  I had been running
the ubuntu 2.6.22-14 kernel before this and the behavior was normal.

I am not certain what information you will need.  Commit is above.

$ cat /proc/acpi/battery/BAT0/alarm
alarm:                   unsupported
$ cat /proc/acpi/battery/BAT0/info
present:                 yes
design capacity:         4800 mAh
last full capacity:      4096 mAh
battery technology:      non-rechargeable
design voltage:          12588 mV
design capacity warning: 1000 mAh
design capacity low:     400 mAh
capacity granularity 1:  100 mAh
capacity granularity 2:  100 mAh
model number:            
serial number:           
battery type:            LiOn
OEM info:                Sony Corp.
$ cat /proc/acpi/battery/BAT0/state
present:                 yes
capacity state:          ok
charging state:          charging
present rate:            unknown
remaining capacity:      4096 mAh
present voltage:         unknown

What I think is relevant .config information:
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_WMI=m
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2000
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_PNPACPI=y
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_ATA_ACPI=y
CONFIG_PATA_ACPI=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_SONYPI=m

Thanks,
Robin Holt
