Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYKMMiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYKMMiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 07:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYKMMim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:38:42 -0500
Received: from mga10.intel.com ([192.55.52.92]:8565 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845AbYKMMil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:38:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,597,1220252400"; 
   d="scan'208";a="403165570"
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
From: Richard Purdie <rpurdie@linux.intel.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Greg KH <greg@kroah.com>, Pierre Ossman <drzeus@drzeus.cx>
In-Reply-To: <1226545753-6640-1-git-send-email-me@felipebalbi.com>
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 12:38:32 +0000
Message-Id: <1226579912.5402.21.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 05:09 +0200, Felipe Balbi wrote:
> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> We can make led_trigger_register_simple by returning a
> struct led_trigger *, instead of passing a struct led_trigger **
> as a parameter and changing it inside the function.

This misses the whole point that it was intentionally written that way.

> Note that I could only test ide, power_supply and mmc changes with my laptop.
> The other changes weren't tested.
> 
>  drivers/leds/led-triggers.c         |   25 ++++++++++++++---------
>  drivers/leds/ledtrig-ide-disk.c     |    6 ++++-
>  drivers/mmc/core/host.c             |    4 ++-
>  drivers/mtd/nand/nand_base.c        |    5 +++-
>  drivers/power/power_supply_leds.c   |   36 ++++++++++++++++++++++++++++------
>  drivers/staging/at76_usb/at76_usb.c |    6 ++++-
>  include/linux/leds.h                |    5 +--
>  7 files changed, 63 insertions(+), 24 deletions(-)

The simple triggers were designed to cause minimum interference to the
usually external subsystem code they were added into. As an example this
meant things like errors were just handled gracefully with a printk
warning and did not take down the whole subsystem. I therefore don't
regard this patch as a simplification, more a complication.

Regards,

Richard




