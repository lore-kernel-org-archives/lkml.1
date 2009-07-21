Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbZGUFPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbZGUFPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZGUFPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:15:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60619 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZGUFPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:15:51 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: "me@felipebalbi.com" <me@felipebalbi.com>,
       "Krishnamoorthy, Balaji T" <balajitk@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "sameo@openedhand.com" <sameo@openedhand.com>,
       "wim@iguana.be" <wim@iguana.be>,
       "timo.t.kokkonen@nokia.com" <timo.t.kokkonen@nokia.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "Nayak, Rajendra" <rnayak@ti.com>
Date: Tue, 21 Jul 2009 10:45:04 +0530
Subject: RE: [RFC][PATCH 1/4] OMAP4: PMIC: Add support for twl6030 irq
 framework
Thread-Topic: [RFC][PATCH 1/4] OMAP4: PMIC: Add support for twl6030 irq
 framework
Thread-Index: AcoJbVZJkoXrFMf0TROXX1zrGUrHcAAT0aHw
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02B595037E@dbde02.ent.ti.com>
References: <1248096992-14610-1-git-send-email-balajitk@ti.com>
 <20090720190706.GE7984@gandalf>
In-Reply-To: <20090720190706.GE7984@gandalf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,
Thanks for the review.

> -----Original Message-----
> From: Felipe Balbi [mailto:me@felipebalbi.com] 
> Sent: Tuesday, July 21, 2009 12:37 AM
> To: Krishnamoorthy, Balaji T
> Cc: linux-kernel@vger.kernel.org; tony@atomide.com; 
> khilman@deeprootsystems.com; david-b@pacbell.net; 
> linux-omap@vger.kernel.org; linux-i2c@vger.kernel.org; 
> sameo@openedhand.com; wim@iguana.be; 
> timo.t.kokkonen@nokia.com; ben-linux@fluff.org; 
> lrg@slimlogic.co.uk; broonie@opensource.wolfsonmicro.com; 
> Nayak, Rajendra; Shilimkar, Santosh
> Subject: Re: [RFC][PATCH 1/4] OMAP4: PMIC: Add support for 
> twl6030 irq framework
 
I can summarize all your review comments in two points.

1. Renaming is some thing __you__ think in not necessary.

For this, I have already responded but just to clarify others on
the list, I am just copy pasting your point and our view on this topic. 
************************************************************************
> this is kinda useless, we can consider twl6030 as being sw compatible
> (almost) with twl4030. And twl4030 driver already support plenty of
> other devices, just look at drivers/mfd/twl4030-core.c lines 
> 807 - 814.
> We have twl4003, twl5030, tps65950, tps65930 and tps65920.
> 
> So IMO, renaming the files is unnecessary.
Well tps* are just another catalog names of the twl4* family. So you can
keep adding whatever names there as long it's a same IC.

Perhaps you look in hurry to comment about this. Please look at the
intention of these patches. TWL6030 has PM IC similar to TWL4030 with
bit different interrupt management. Audio IC is a separate one as
compared to combined in case of TWL4030.

If it allows code re-use by renaming files, it should be good. Isn't it ?
************************************************************************
Here is summary of Major difference between Triton(TWL4030) and
Phoenix(TWL6030_ chips are:
    -GPIO, Keypad is not present in Phoenix
    -I2C Chips addresses of modules like RTC, BCI, ADC, USB, PMC Master/Slave 
     have changed.  Base address of these module register is also changed.
    -PIH and SIH, module interrupt status registers will be replaced by PIH 
     (INT_STS_A, INT_STS_B and INT_STS_C) and module interrupt status registers
    -MADC to GPADC in Phoenix, 17 channels supported
     GPADC in Phoenix supports Realtime, Asynchronous SW request.
    -RTC register offsets have changed. Addition/removal of LDO/SMPS Voltage 
     Regulators

2. Usage of compile time macros like "CONFIG_TWL4030" and CONFIG_TWL6030"
should be avoided and you think it would break multi-omap.

If we just go by definition " Multi-OMAP" is for different OMAP IC's. TWL4030
and TWL6030 are external companion IC's to OMAP.
Any ways, these compile time switches can be avoided if we make runtime
provision for these TWL IC's like. 
"is_twl4030(), is_twl6030" etc like "cpu_is_24xx(),cpu_is_44xx()" etc.

Obviously this asks to make the driver register map (which is different in
case of TWL6030 w.r.t TWL4030) to be held in some arrays and select the
appropriate one run-time.  But it's doable if it helps.

The patch series was made under _assumption_ that either TWL4030 or TWL6030 
would be used. I am not sure whether there will boards where both will
co-exist.

Regards
Santosh