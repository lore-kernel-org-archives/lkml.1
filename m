Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbZGUFac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbZGUFac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZGUFaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:30:30 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:40049 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZGUFa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:30:29 -0400
Date: Tue, 21 Jul 2009 08:30:21 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: "me@felipebalbi.com" <me@felipebalbi.com>,
       "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC][PATCH 1/4] OMAP4: PMIC: Add support for twl6030 irq
 framework
Message-ID: <20090721053021.GB13013@gandalf>
Reply-To: me@felipebalbi.com
References: <1248096992-14610-1-git-send-email-balajitk@ti.com>
 <20090720190706.GE7984@gandalf>
 <EAF47CD23C76F840A9E7FCE10091EFAB02B595037E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02B595037E@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

please send text mails and break your lines at 80 characters!

On Tue, Jul 21, 2009 at 10:45:04AM +0530, Shilimkar, Santosh wrote:
> Here is summary of Major difference between Triton(TWL4030) and
> Phoenix(TWL6030_ chips are:
>     -GPIO, Keypad is not present in Phoenix
>     -I2C Chips addresses of modules like RTC, BCI, ADC, USB, PMC Master/Slave 
>      have changed.  Base address of these module register is also changed.
>     -PIH and SIH, module interrupt status registers will be replaced by PIH 
>      (INT_STS_A, INT_STS_B and INT_STS_C) and module interrupt status registers
>     -MADC to GPADC in Phoenix, 17 channels supported
>      GPADC in Phoenix supports Realtime, Asynchronous SW request.
>     -RTC register offsets have changed. Addition/removal of LDO/SMPS Voltage 
>      Regulators

all of this can be addressed without ifdeferry around the code. Just add
proper abstraction via platform_data, and that 'features' you see in
twl4030-core.c

> 2. Usage of compile time macros like "CONFIG_TWL4030" and CONFIG_TWL6030"
> should be avoided and you think it would break multi-omap.
> 
> If we just go by definition " Multi-OMAP" is for different OMAP IC's. TWL4030
> and TWL6030 are external companion IC's to OMAP.

what will happen if you build on kernel image for booting omap3 and
omap4 ???

> Any ways, these compile time switches can be avoided if we make runtime
> provision for these TWL IC's like. 
> "is_twl4030(), is_twl6030" etc like "cpu_is_24xx(),cpu_is_44xx()" etc.

or you just use the 'features' in the twl4030-core.c and based on that
pass a flag to the children notifying it's triton/gaia/reno/phoenix.

> Obviously this asks to make the driver register map (which is different in
> case of TWL6030 w.r.t TWL4030) to be held in some arrays and select the
> appropriate one run-time.  But it's doable if it helps.

I'd say that's better than ifdeferry.

> The patch series was made under _assumption_ that either TWL4030 or TWL6030 
> would be used. I am not sure whether there will boards where both will
> co-exist.

not in the same board, but think of building one kernel image for both
omap3 and omap4. Nobody will do that in real life for real products, but
it's really useful when it goes about testing code on several boards.
You don't have to spend time building several different kernel images,
you build only one that boots on all.

-- 
balbi
