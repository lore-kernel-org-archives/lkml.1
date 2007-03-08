Return-Path: <linux-kernel-owner+w=401wt.eu-S1030688AbXCHVsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030688AbXCHVsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030684AbXCHVsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:48:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:58934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030688AbXCHVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:48:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PPVqSNuF5xwsQ/84le3Tr4XgtntcFAMpohhKD4mGMoDFOA/b7H5Hbz1mjAt7P3xpgwLI0IDkMVDpvwDXK3VWACLK4r4NFx/VisTXhgYsC71+5Od6Px+CJXs53AqkVJKtGISFDvoGqnasiPUOzShNrdAdxdHaT3kuLT5AroWraRI=
Message-ID: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com>
Date: Thu, 8 Mar 2007 13:48:43 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: KVM and rtc missing interupts 2.6.21-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When ever I try and start a guest OS with kvm I get a lot of these rtc
missing interupt messages from the kernel

[  468.510878] rtc: lost some interrupts at 1024Hz.
[  468.530876] rtc: lost some interrupts at 1024Hz.
[  468.550868] rtc: lost some interrupts at 1024Hz.
[  468.570864] rtc: lost some interrupts at 1024Hz.
[  468.590856] rtc: lost some interrupts at 1024Hz.
[  468.610850] rtc: lost some interrupts at 1024Hz.
[  468.630844] rtc: lost some interrupts at 1024Hz.
[  468.650839] rtc: lost some interrupts at 1024Hz.
[  468.670832] rtc: lost some interrupts at 1024Hz.
[  468.690826] rtc: lost some interrupts at 1024Hz.
[  468.710819] rtc: lost some interrupts at 1024Hz.
[  468.730813] rtc: lost some interrupts at 1024Hz.
[  468.750807] rtc: lost some interrupts at 1024Hz.
[  468.770801] rtc: lost some interrupts at 1024Hz.
[  468.790795] rtc: lost some interrupts at 1024Hz.
[  468.810790] rtc: lost some interrupts at 1024Hz.
[  468.830783] rtc: lost some interrupts at 1024Hz.
[  468.850778] rtc: lost some interrupts at 1024Hz.
[  468.870774] rtc: lost some interrupts at 1024Hz.
[  468.890772] rtc: lost some interrupts at 1024Hz.
[  468.910760] rtc: lost some interrupts at 1024Hz.
[  468.930754] rtc: lost some interrupts at 1024Hz.

I don't have the dynamic ticker set or some of the other high
resolution timer things set

# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

I do have the rtc group selected as modules though

CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
...
#
# Real Time Clock
#
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=m
CONFIG_RTC_INTF_PROC=m
CONFIG_RTC_INTF_DEV=m
CONFIG_RTC_INTF_DEV_UIE_EMUL=y

#
# RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_ISL1208=m
... and the rest of the drivers as modules

I have the latest kvm-16 and here's how I'm starting the guest OS.

KVER="2.6.9-42.EL"
INITRD_BASE="initrd"
INITRD_APPEND=".img"
APPEND="ro root=LABEL=/ 3 console=ttyS0"
DEV=hda

kvm -kernel "/boot/vmlinuz-${KVER}" \
    -initrd "/boot/${INITRD_BASE}-${KVER}${INITRD_APPEND}" \
    -append "${APPEND}" \
    -nographic -m 256 \
    -net nic,vlan0 \
    -net tap,vlan=0,ifname=tap1,script=no \
    /dev/hda


Anymore information can be easily provided.

Thanks,
- David Brown
