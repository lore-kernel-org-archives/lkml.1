Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbXEaEv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbXEaEv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbXEaEvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:51:37 -0400
Received: from eazy.amigager.de ([213.239.192.238]:46725 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760158AbXEaEvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:51:35 -0400
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 00:51:35 EDT
Date: Thu, 31 May 2007 06:32:29 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Message-ID: <20070531043229.GA30888@dose.home.local>
Mail-Followup-To: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705281406.57396.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 14:06:52 -0700, David Brownell wrote:

[...]

> That seems to be true.  And those particular users should learn the
> portable /sys/class/rtc/rtc0/wakealarm syntax ... e.g. using numeric
> seconds-since-epoch ("date '+%s'") instead of strings the kernel needs
> to parse.  That way, they can start converting usage sooner.

Hi,

I use /proc/acpi/alarm a lot and tried to learn how to use
/sys/class/rtc/rtc0/wakealarm. However, I have no /sys/class/rtc/rtc0
until I load the rtc-test driver. I tried all RTC drivers that are
available in 2.6.21, without success:

$ grep RTC /boot/config-2.6.21
CONFIG_RTC=y
# CONFIG_HPET_RTC_IRQ is not set
# CONFIG_SND_RTCTIMER is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
# RTC interfaces
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# RTC drivers
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_TEST=m
CONFIG_RTC_DRV_V3020=m

In dmesg, I see these messages from RTC_DRV_CMOS:

rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:09 failed with error -16
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

So all I can do is to continue to use /proc/acpi/alarm.

Regards,
Tino
