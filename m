Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYKZW7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYKZW7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYKZW7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:59:05 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:25988 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750911AbYKZW7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:59:03 -0500
Date: Thu, 27 Nov 2008 01:58:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] of_gpio: Return GPIO flags from of_get_gpio()
Message-ID: <20081126225859.GA7589@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081030111500.GB22008@oksana.dev.rtsoft.ru> <1225418589-8545-1-git-send-email-tpiepho@freescale.com> <20081126162033.GA13397@oksana.dev.rtsoft.ru> <18733.49643.63081.163437@cargo.ozlabs.ibm.com> <Pine.LNX.4.64.0811261423120.5161@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811261423120.5161@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 02:35:54PM -0800, Trent Piepho wrote:
> On Thu, 27 Nov 2008, Paul Mackerras wrote:
> > Anton Vorontsov writes:
> >
> >> Can we apply it? Paul, Benjamin?
> >>
> >> The patchwork url for this patch is:
> >> http://patchwork.ozlabs.org/patch/6650/
> >>
> >>
> >> Thanks!
> >>
> >>>  drivers/mtd/nand/fsl_upm.c              |    2 +-
> >>>  drivers/net/fs_enet/fs_enet-main.c      |    2 +-
> >>>  drivers/net/phy/mdio-ofgpio.c           |    4 ++--
> >>>  drivers/of/gpio.c                       |   13 ++++++++++---
> >>>  drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
> >>>  include/linux/of_gpio.h                 |   21 +++++++++++++++++----
> >>>  6 files changed, 32 insertions(+), 12 deletions(-)
> >
> > That would need acks from Jeff Garzik and David Woodhouse.
> >
> > Alternatively you could add a new function (called, for instance,
> > of_get_gpio_flags) with the extra parameter to eliminate the need to
> > change any drivers at this stage, since they all seem to pass NULL for
> > the flags argument.
> 
> But if we did this every time any exported function needs to change, think
> how bloated the API would be with cruft.

Stable API is nonsense, yes. But we tend to change the API evolutionary,
not revolutionary. That is,

1. Implement of_get_gpio_flags();
2. Now we can start using it (no stall in development, see?);
3. Then somebody comes with the _cleanup_ patch:
   "[PATCH] Merge of_get_gpio_flags() and of_get_gpio(), convert users"

   ^^ That patch is trivial and could be applied at any appropriate
   moment (i.e. when there are no of_*_gpio*() patches queued in the
   -next trees). And as time goes by, the patch collects all the needed
   Acks, no need to hurry -- it's trivial cleanup.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
