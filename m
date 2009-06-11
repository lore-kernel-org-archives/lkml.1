Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbZFKHyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbZFKHyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZFKHyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:54:46 -0400
Received: from relay.atmel.no ([80.232.32.139]:53246 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbZFKHyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:54:46 -0400
Date: Thu, 11 Jun 2009 09:54:32 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Rob Emanuele <poorarm@shoreis.com>
Cc: Joey Oravec <joravec@drewtech.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports
 both MCI  slots used at the same time
Message-ID: <20090611095432.2e3a4067@hskinnemoen-d830>
In-Reply-To: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cutting the redundant bits from Subject]

Hi Rob,

Rob Emanuele wrote:
> This patch unifies the at91 changes I had into the atmel-mci
> (originally for AVR32) driver.

That doesn't look so bad...but I suspect PDC support hasn't been
integrated yet?

> This also fixes an important bug where in 4-bit mode you could only
> select Slot A.

It has already been fixed in mainline.

> As with the at91 port I had of this driver, I had to add more flags to
> the ATMCI_DATA_ERROR_FLAGS as other communication errors were
> occurring and they were not be reported back.  Can anyone add more
> insight into this?

Adding them to the data error bits doesn't sound like the right thing
to do...but I guess there might be some sort of timing issue in there
where we think we're done sending the command but the controller may
still raise errors.

> Again, anyone who can, please test (on either or both the AT91 and
> AVR32) and comment.

I haven't looked very closely at it yet, but I spotted a few things
which might prevent the patch from being accepted as-is:
  - I'm not sure if adding "unified" (or "now supports AT91") all over
    the place is the right thing to do. If the driver is selectable
    when you configure for AT91, it should obviously work on AT91.
  - The patch seems to do a bit too much all at once. The bug fix which
    has already been fixed is one example, another is the clock cap
    option -- we used to have a module parameter for the same purpose,
    but Pierre (the MMC maintainer, who should probably be added to the
    loop) had problems with it. If this feature was in a separate
    patch, it could be rejected without blowing away the rest of the
    driver.
  - The AT91 platform parts should be separated from the rest since it
    may need to go through a different maintainer.

Haavard
