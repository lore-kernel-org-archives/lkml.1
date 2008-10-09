Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYJILsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYJILsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYJILs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:48:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:27427 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbYJILs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=g0YQ7/NSnLUftkzMNmDnAPChUziQXb9SI3+5qLdQTJQZggrGFnWisG+wUhZhvuVWwa
         EeXZXHwzdsb+L9m8S1hDuw7Ur/XeXMKGVdQK0JKESOJ+SksZAIlCmd5yeAjZ47YMQKtx
         0b5cMGlyUSOqyFNX30Vm4Zsk9b0uuD/r4aZxE=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Date: Thu, 9 Oct 2008 13:48:19 +0200
User-Agent: PLD Linux KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810091348.19828.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No udev on the system. kernel 2.6.25.18-1. 

After loading ipmi_watchdog and doing "cat /dev/watchdog" tons of other, 
useles, watchdog modules is loaded. Any idea what introduced such weird 
behaviour?

# zgrep WATCH /proc/config.gz
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_SOFT_WATCHDOG=m
CONFIG_HP_WATCHDOG=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_PCIPCWATCHDOG=m
CONFIG_USBPCWATCHDOG=m



[ 1428.949724] ipmi message handler version 39.1
[ 1428.954908] IPMI Watchdog: driver initialized
[ 1428.991475] WDT driver for Wafer 5823 single board computer initialising.
[ 1428.991475] Wafer 5823 WDT: initialized. timeout=60 sec (nowayout=0)
[ 1428.999069] W83977F WDT: W83977F WDT driver, v1.00
[ 1428.999069] W83977F WDT: cannot register miscdev on minor=130 (err=-16)
[ 1429.018171] w83877f_wdt: I/O address 0x0443 already in use
[ 1429.029361] w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
[ 1429.029361] w83697hf/hg WDT: Looking for watchdog at address 0x2e
[ 1429.029361] w83697hf/hg WDT: watchdog not found at address 0x2e
[ 1429.029361] w83697hf/hg WDT: No W83697HF/HG could be found
[ 1429.039465] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip 
initialising.
[ 1429.039465] w83627hf/thf/hg WDT: cannot register miscdev on minor=130 
(err=-16)
[ 1429.049504] SoftDog: cannot register miscdev on minor=130 (err=-16)
[ 1429.059574] SMsC 37B787 watchdog component driver 1.1 initialising...
[ 1429.059574] smsc37b787_wdt: Unable to register miscdev on minor 130
[ 1429.069971] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[ 1429.080149] sc1200wdt: build 20020303
[ 1429.080149] sc1200wdt: io parameter must be specified
[ 1429.096875] epx_c3: cannot register miscdev on minor=130 (err=-16)
[ 1429.106937] sbc8360: failed to register misc device
[ 1429.116985] sbc60xxwdt: I/O address 0x0443 already in use
[ 1429.127056] usbcore: registered new interface driver pcwd_usb
[ 1429.127056] pcwd_usb: Berkshire USB-PC Watchdog driver v1.02 (21 Jan 2007)
[ 1429.128503] pc87413 WDT: Version 1.1 at io 0x2E
[ 1429.128507] pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
[ 1429.150453] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[ 1429.150453] machzwd: no ZF-Logic found
[ 1429.180669] ib700wdt: WDT driver for IB700 single board computer 
initialising.
[ 1429.180676] ib700wdt: START method I/O 443 is not available.
[ 1429.180676] ib700wdt: probe of ib700wdt failed with error -5
[ 1429.180695] iTCO_vendor_support: vendor-support=0
[ 1429.183584] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[ 1429.183700] iTCO_wdt: No card detected
[ 1429.211892] eurwdt: can't misc_register on minor=130
[ 1429.235205] cpu5wdt: misc_register failed
[ 1429.245262] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[ 1429.245262] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[ 1429.265354] WDT driver for Advantech single board computer initialising.
[ 1429.265361] advantechwdt: I/O address 0x0443 already in use
[ 1429.265361] advantechwdt: probe of advantechwdt failed with error -5
[ 1429.265378] WDT driver for Acquire single board computer initialising.
[ 1429.265385] acquirewdt: I/O address 0x0043 already in use
[ 1429.265385] acquirewdt: probe of acquirewdt failed with error -5

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
