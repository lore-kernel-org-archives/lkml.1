Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYJAMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYJAMvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJAMvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:51:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:41978 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYJAMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rg459x9Pmo2YNrVhzzirSqQedSGrJFr6oMHyT3b0WmBa/gJvJldLCd+FY3EFOrImwt
         wicPO+8CfuCXV+zlbjYYUbakCFps/Tg06kUEWfbsAVpSkNZBP4/C1ZmPyH8KyGK/LOTD
         OPrJh7QqCnY68f8z3ngFvtuK2yYkyZAPNkuPY=
Message-ID: <d6c8ef150810010551x174fad1mc788e2f6e97b21c5@mail.gmail.com>
Date: Wed, 1 Oct 2008 14:51:38 +0200
From: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
To: "Kim B. Heino" <Kim.Heino@bluegiga.com>
Subject: Re: [PATCH] add support for ST M41T94 SPI RTC (patch rev. 3)
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
In-Reply-To: <48315FF6.9070909@bluegiga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48315FF6.9070909@bluegiga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I sent a few private messages to Kim, but I'll sumarize my problem here ]

Hi all,

I have AT91SAM9260-based board, kernel is 2.6.26.3. M41T94 is
connected on SPI channel 1, chip select 0. I've applied Kim's patch
and added SPI device in board-sam9260ek.c:
#if defined(CONFIG_RTC_DRV_M41T94) || defined(CONFIG_RTC_DRV_M41T94_MODULE)
	{	/* External RTC */
		.modalias	= "rtc-m41t94",
		.chip_select	= 0,
		.max_speed_hz	= 2 * 1000 * 1000,
		.bus_num	= 1,
	},
#endif

During booting up everything seems fine (M41T94 is found etc), but it
is not working. Here is some output:

rtc-m41t94: dev (254:0)
rtc-m41t94 spi1.0: rtc core: registered rtc-m41t94 as rtc0
rtc-m41t94 spi1.0: read secs=0, mins=0, hours=0, mday=0, mon=-1,
year=100, wday=-1
rtc-m41t94 spi1.0: hctosys: unable to read the hardware clock
[..]
# hwclock -r;dmesg
hwclock: RTC_RD_TIME: Invalid argument
rtc-m41t94 spi1.0: read secs=0, mins=0, hours=0, mday=0, mon=-1,
year=100, wday=-1

#hwclock -w;dmesg
rtc-m41t94 spi1.0: write secs=15, mins=0, hours=0, mday=1, mon=0,
year=70, wday=4

I've tried both SPIMODE0 and SPIMODE3 (according to m41t94 datasheet)
but no improvements.

Thanks
