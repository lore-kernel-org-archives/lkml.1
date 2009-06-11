Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbZFKUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbZFKUQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZFKUQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:16:12 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:36982 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZFKUQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:16:11 -0400
MIME-Version: 1.0
In-Reply-To: <20090611095432.2e3a4067@hskinnemoen-d830>
References: <c8284b5b0906101641v586c3487i465263bb6908e3f7@mail.gmail.com>
	 <20090611095432.2e3a4067@hskinnemoen-d830>
Date: Thu, 11 Jun 2009 13:16:12 -0700
X-Google-Sender-Auth: 2cfd987d77bec258
Message-ID: <c8284b5b0906111316p1367a508vdb59ee7c2a8d2ff1@mail.gmail.com>
Subject: Re: [PATCH][Fix] New Unified AVR32/AT91 MCI Driver that supports both 
	MCI slots used at the same time
From: Rob Emanuele <poorarm@shoreis.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Joey Oravec <joravec@drewtech.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

>> This patch unifies the at91 changes I had into the atmel-mci
>> (originally for AVR32) driver.
>
> That doesn't look so bad...but I suspect PDC support hasn't been
> integrated yet?

PDC support is not written yet.

>
>> As with the at91 port I had of this driver, I had to add more flags to
>> the ATMCI_DATA_ERROR_FLAGS as other communication errors were
>> occurring and they were not be reported back.  Can anyone add more
>> insight into this?
>
> Adding them to the data error bits doesn't sound like the right thing
> to do...but I guess there might be some sort of timing issue in there
> where we think we're done sending the command but the controller may
> still raise errors.
>
>> Again, anyone who can, please test (on either or both the AT91 and
>> AVR32) and comment.
>
> I haven't looked very closely at it yet, but I spotted a few things
> which might prevent the patch from being accepted as-is:
>  - I'm not sure if adding "unified" (or "now supports AT91") all over
>    the place is the right thing to do. If the driver is selectable
>    when you configure for AT91, it should obviously work on AT91.

Well, what is the best way to differentiate it from the at91_mci
driver and keep users from trying to use both drivers?

>  - The patch seems to do a bit too much all at once. The bug fix which
>    has already been fixed is one example, another is the clock cap
>    option -- we used to have a module parameter for the same purpose,
>    but Pierre (the MMC maintainer, who should probably be added to the
>    loop) had problems with it. If this feature was in a separate
>    patch, it could be rejected without blowing away the rest of the
>    driver.

Which kernel branch should I generate the patch against to have the
most recent set of changes?

I can break out the clock cap code without any issues.

>  - The AT91 platform parts should be separated from the rest since it
>    may need to go through a different maintainer.

Who would that be as I haven't seen anyone who maintains any of those
boards other than the at91rm8200 (at least nothing listed in the
MAINTAINERS file)?  The board-sam9g20ek.c platform only shows Atmel as
the most recent copyright.

Thank you,

Rob Emanuele
