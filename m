Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXJZSMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXJZSMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbXJZSMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:12:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:39667 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbXJZSMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JRB3BzboPpx9gHQoNt0+D+GbsVQc40hR/H4OVKoqLG969Q6MH0rCQWCnvwV2Aup1jzuhOzjv/znR9ukj6ETtVXKd7h4WycZYUGKKEiJaA6o94cuDg+ZFmj48sHtYa4hmeu+IVT9x5al3QOIV+vrKGqFqU1llnV0Nr4DbkkgRgGM=
Message-ID: <47222DF3.3040208@gmail.com>
Date: Fri, 26 Oct 2007 22:12:03 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.624-rc1 regression] lost battery information
References: <200710262024.06012.arvidjaar@mail.ru> <47221C67.9050502@gmail.com> <200710262120.22536.arvidjaar@mail.ru>
In-Reply-To: <200710262120.22536.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Friday 26 October 2007, Alexey Starikovskiy wrote:
>> Andrey Borzenkov wrote:
>>> I have lost battery in 2.6.24-rc1. Without CONFIG_ACPI_PROCFS I have
>>> no /proc/acpi/battery and cannot test netlink interface because right now
>>> there is no consumer of this.
>> for /sysfs interface you need to enable power_supply driver.
>> or you could apply this patch and power_supply will be selected by battery
>> itself.
>>
> 
> I already have power_supply module, battery depends on it and it is autloaded. 
> But I fail to see where I can get battery info in /sys
Intent was to put into /sysfs same information:
aystarik@samsung:~/client_conf$ ls /sys/class/power_supply/BAT1/
alarm  charge_full  charge_full_design  charge_now  current_now  device  manufacturer  model_name  present  status  subsystem  technology  type  uevent  voltage_min_design  voltage_now

aystarik@samsung:~/client_conf$ cat /sys/class/power_supply/BAT1/*
0
4172000
4300000
4172000
0
cat: /sys/class/power_supply/BAT1/device: Is a directory
Pacifi
Bat1
1
Full
cat: /sys/class/power_supply/BAT1/subsystem: Is a directory
Li-ion
Battery
PHYSDEVPATH=/devices/LNXSYSTM:00/device:00/PNP0C0A:00
PHYSDEVBUS=acpi
PHYSDEVDRIVER=battery
POWER_SUPPLY_NAME=BAT1
POWER_SUPPLY_TYPE=Battery
POWER_SUPPLY_STATUS=Full
POWER_SUPPLY_PRESENT=1
POWER_SUPPLY_TECHNOLOGY=Li-ion
POWER_SUPPLY_VOLTAGE_MIN_DESIGN=14800000
POWER_SUPPLY_VOLTAGE_NOW=16522000
POWER_SUPPLY_CURRENT_NOW=0
POWER_SUPPLY_CHARGE_FULL_DESIGN=4300000
POWER_SUPPLY_CHARGE_FULL=4172000
POWER_SUPPLY_CHARGE_NOW=4172000
POWER_SUPPLY_MODEL_NAME=Bat1
POWER_SUPPLY_MANUFACTURER=Pacifi
14800000
16522000

aystarik@samsung:~/client_conf$ cat /proc/acpi/battery/BAT1/*
alarm:                   unsupported
present:                 yes
design capacity:         4300 mAh
last full capacity:      4172 mAh
battery technology:      rechargeable
design voltage:          14800 mV
design capacity warning: 208 mAh
design capacity low:     41 mAh
capacity granularity 1:  41 mAh
capacity granularity 2:  41 mAh
model number:            Bat1
serial number:           001
battery type:            LION
OEM info:                Pacifi
present:                 yes
capacity state:          ok
charging state:          charged
present rate:            0 mA
remaining capacity:      4172 mAh
present voltage:         16518 mV
