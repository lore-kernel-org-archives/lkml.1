Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXKIQrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXKIQrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbXKIQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:47:42 -0500
Received: from nef2.ens.fr ([129.199.96.40]:3893 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbXKIQrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:47:42 -0500
X-Greylist: delayed 1429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 11:47:41 EST
Date: Fri, 9 Nov 2007 17:23:48 +0100
From: David Madore <david.madore@ens.fr>
To: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>
Subject: any help on RTC-related config? (and "rtc_cmos: probe of 00:03 failed with error -16" error message)
Message-ID: <20071109162348.GA13051@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Fri, 09 Nov 2007 17:23:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm extremely confused as to what all the RTC-related config variables
in the kernel mean and what I'm supposed to do with them, and I wonder
if someone can help me or point me to some doc beside rtc.txt (which
I've read, of course).

I understand (from reading Documentation/rtc.txt) that there are two
different RTC driver systems for Linux: an "old" one, supporting only
one PC-AT-compatible RTC source, which drives /dev/rtc, and a "new"
one, supporting different sources, which drives /dev/rtc[0123...].
But I'm not sure which configuration variables enable which, whether
they should be enabled together or whether I should choose between the
twain, and what I should be using on my system anyway.

I sort of gathered (I hope not too incorrectly) that the "genrtc"
module is brought by the CONFIG_GEN_RTC configuration choice and that
it contains the "old" driver, whereas the "new" driver is split
between modules such as "rtc", "rtc_lib", "rtc_core" and actual
drivers like "rtc_cmos" - right? - and configured by such switches as
CONFIG_RTC_CLASS, CONFIG_RTC_LIB and CONFIG_RTC_DRV_CMOS.  There might
also be a CONFIG_RTC variable, about which I'm not sure.

I'm also very confused about how HPET's tie into this, and what
CONFIG_HPET_EMULATE_RTC does, for example.

Now how do I know what's on my system?  (It's an ASUS P5W64 WS Pro
based x86_64.)  I certainly have some kind of CMOS clock that I can
configure in my BIOS, but I don't know about HPET's or other kind of
RTC sources.

I tried using the following config (this is all with 2.6.22.10):

CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_V3020 is not set

Now if I load the genrtc module (to use the "old" driver?), I get a
/dev/rtc which may or may not be satisfactory but the
dev.rtc.max-user-freq sysctl does not exist and ALSA does not use
snd_rtctimer.  If I try unloading genrtc and instead loading the rtc,
rtc_lib, rtc_core and rtc_cmos modules (to use the "new" driver?), I
get the following error in dmesg:

Real Time Clock Driver v1.12ac
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:03 failed with error -16

After what attempts to, e.g., play a MIDI file with ALSA, fail (only a
single note is played) and the following error occurs in dmesg:

rtc: lost some interrupts at 1024Hz.

So, why does rtc_cmos fail that way?  And how am I supposed to
configure RTC as a whole?  (I will, of course, gladly provide more
information if requested.)

Thanks for any help!

-- 
     David A. Madore
    (david.madore@ens.fr,
     http://www.madore.org/~david/ )
