Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbXFUSuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbXFUSuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXFUSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:50:12 -0400
Received: from ms.trustica.cz ([82.208.32.68]:34638 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbXFUSuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:50:11 -0400
Message-ID: <467AC84A.303@assembler.cz>
Date: Thu, 21 Jun 2007 20:49:46 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
References: <20070513223329.GA29207@dreamland.darkstar.lan> <46520F36.4080006@assembler.cz> <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com> <46528B6F.3050701@assembler.cz> <20070602222829.GA11893@dreamland.darkstar.lan>
In-Reply-To: <20070602222829.GA11893@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Luca,

Sorry for delay,

> Ok, it makes sense :)
> 
> Name (FBUF, Package (0x06)
> {
>     0x03,
>     CPUF,
>     CHAF,
>     PWRF,
>     CHPF,
>     CH2F
> })
> 
> Clearly the first number is not the number of available readings (though
> it matches the count in the other DSDTs I've seen); don't know what it
> is :|

Maybe study the Pro2.dll from Asus Probe II?


> The last field of the individual fan packages is far more interesting: 0
> means disabled, anything else means enabled. In your DSDT "CHIPSET FAN
> Speed" is marked as disabled and there's no AML code to read the
> rotation.
> This may be true also for the other packages (temp and voltage), but for
> now I've modified only the fan code.

Ok.

Fan3 is disabled because the chip is programed to disabled - (IO pin)

> Here's another iteration of the driver, please give it a try:

It loads now. I have moved my extra fan to some other connector, now it is fan1 
for w83627EHF chip.


ATK0110 ATK0110:00: removing...
ATK0110 ATK0110:00: atk: adding...
ATK0110 ATK0110:00: board ID = A8VE-SE
ATK0110 ATK0110:00: temp 0: 0x6030000 CPU Temperature [900-1250]
ATK0110 ATK0110:00: temp 1: 0x6030001 MB Temperature [700-1250]
ATK0110 ATK0110:00: voltage 0: 0x6020000 Vcore Voltage [1450-1750]
ATK0110 ATK0110:00: voltage 1: 0x6020001  +3.3 Voltage [3000-3600]
ATK0110 ATK0110:00: voltage 2: 0x6020002  +5.0 Voltage [4500-5500]
ATK0110 ATK0110:00: voltage 3: 0x6020003 +12.0 Voltage [11200-13200]
ATK0110 ATK0110:00: atk_enumerate_fan: invalid fan count? 3 (should be 5)
ATK0110 ATK0110:00: fan 0: 0x6040000 CPU FAN Speed [0-1800] enabled
ATK0110 ATK0110:00: fan 1: 0x6040001 CHASSIS FAN Speed [0-1800] enabled
ATK0110 ATK0110:00: fan 2: 0x6040002 POWER FAN Speed [0-1800] enabled
ATK0110 ATK0110:00: fan 3: 0x6040005 CHIPSET FAN Speed [0-1800] disabled
ATK0110 ATK0110:00: fan 4: 0x6040006 CHASSIS2 FAN Speed [0-1800] enabled
ATK0110 ATK0110:00: registering hwmon device
ATK0110 ATK0110:00: populating sysfs directory

Although it says it has been registered to hwmon class, I cant find it in sysfs. 
I have loaded/unloaded the driver several times before I checked the dir, so 
maybe is something wrong?

Does it show up in your /sys/class/hwmon?

Thanks,

Rudolf
