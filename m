Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZGVPYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZGVPYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZGVPYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:24:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:19536 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZGVPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:24:02 -0400
To: me@felipebalbi.com
Cc: balajitk@ti.com, linux-kernel@vger.kernel.org, tony@atomide.com,
       david-b@pacbell.net, linux-omap@vger.kernel.org,
       linux-i2c@vger.kernel.org, sameo@openedhand.com, wim@iguana.be,
       timo.t.kokkonen@nokia.com, ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH 1/4] ARM: OMAP: Rename twl4030* driver files to enable re-use
References: <1248096671-13828-1-git-send-email-balajitk@ti.com>
	<20090720185253.GA7984@gandalf>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 22 Jul 2009 07:54:01 -0700
In-Reply-To: <20090720185253.GA7984@gandalf> (Felipe Balbi's message of "Mon\, 20 Jul 2009 21\:52\:54 +0300")
Message-ID: <87prbslqeu.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <me@felipebalbi.com> writes:

> Hi,
>
> On Mon, Jul 20, 2009 at 07:01:11PM +0530, balajitk@ti.com wrote:
>> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> 
>> The upcoming TWL6030 is companion chip for OMAP4 like the current TWL4030
>> for OMAP3. The common modules like RTC, Regulator creates opportunity
>> to re-use the most of the code from twl4030.
>> 
>> This patch renames few common drivers twl4030* files to twl* to enable
>> the code re-use.
>> 
>> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
>> Signed-off-by: Balaji T K <balajitk@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>  arch/arm/mach-omap2/board-2430sdp.c                |    2 +-
>>  arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
>>  arch/arm/mach-omap2/board-ldp.c                    |    2 +-
>>  arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
>>  arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
>>  arch/arm/mach-omap2/board-overo.c                  |    2 +-
>>  drivers/gpio/twl4030-gpio.c                        |    2 +-
>>  drivers/mfd/Makefile                               |    2 +-
>>  drivers/mfd/{twl4030-core.c => twl-core.c}         |    8 +++-----
>>  drivers/mfd/twl4030-irq.c                          |    2 +-
>>  drivers/regulator/Makefile                         |    2 +-
>>  .../{twl4030-regulator.c => twl-regulator.c}       |    6 +++---
>>  drivers/rtc/Makefile                               |    2 +-
>>  drivers/rtc/{rtc-twl4030.c => rtc-twl.c}           |    2 +-
>>  drivers/usb/otg/twl4030-usb.c                      |    2 +-
>>  include/linux/i2c/{twl4030.h => twl.h}             |    5 ++++-
>>  sound/soc/codecs/twl4030.c                         |    2 +-
>
> this is kinda useless, we can consider twl6030 as being sw compatible
> (almost) with twl4030. And twl4030 driver already support plenty of
> other devices, just look at drivers/mfd/twl4030-core.c lines 807 - 814.
> We have twl4003, twl5030, tps65950, tps65930 and tps65920.
>
> So IMO, renaming the files is unnecessary.

I support the renaming.

I think the renaming part of a cleanup and a generalization so that
this code can be reused for other parts in the same family, and still
be readable and maintainable.

Yes, we *could* keep the current names, but that's a shortcut that
will lead to code that is more difficult to follow and thus maintain.

Kevin
