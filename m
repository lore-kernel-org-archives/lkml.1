Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYJBRdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYJBRdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYJBRdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:33:44 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:38229 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbYJBRdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:33:43 -0400
Date: Thu, 2 Oct 2008 20:33:30 +0300
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>
To: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
Subject: Re: [PATCH] add support for ST M41T94 SPI RTC (patch rev. 3)
Message-ID: <20081002203330.295ad5c0@why.bbbs.net>
In-Reply-To: <d6c8ef150810010551x174fad1mc788e2f6e97b21c5@mail.gmail.com>
References: <48315FF6.9070909@bluegiga.com>
	<d6c8ef150810010551x174fad1mc788e2f6e97b21c5@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have AT91SAM9260-based board, kernel is 2.6.26.3.

I'm using my RTC-patch with the same CPU. Custom AT91SAM9260 board,
external RTC because of AT's errata...

> M41T94 is connected on SPI channel 1, chip select 0. I've applied
> Kim's patch and added SPI device in board-sam9260ek.c

> 	{	/* External RTC */
> 		.modalias	= "rtc-m41t94",
> 		.chip_select	= 0,
> 		.max_speed_hz	= 2 * 1000 * 1000,
> 		.bus_num	= 1,
> 	},

I'm using it with ".max_speed_hz = 1 * 1000 * 1000," instead of 2 MHz.
Can you try with slower speed? My patch (rev 3) and this small
ek_spi_devices[] modification should be enough.

I have it on bus = 0, chip_select = 1, so I've also removed dataflash
parts from ek_spi_devices[] (we're using NOR flash). But for you this
is not needed.

I also have a patch to add support for M41T94's watchdog timer. It's
not clean enough to be submitted upstreams yet. If you need it I can
email it to you.
