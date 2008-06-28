Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYF1OP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYF1OP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 10:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYF1OPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 10:15:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49887 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbYF1OPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 10:15:14 -0400
Date: Sat, 28 Jun 2008 16:15:24 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628161524.5c3fd45f@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628160110.41ec91f7@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153745.027b0817@mjolnir.drzeus.cx>
	<20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
	<20080628160110.41ec91f7@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 14:15:11.0807 (UTC) FILETIME=[60A064F0:01C8D929]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Sat, 28 Jun 2008 15:48:44 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > The status command doesn't work on SDIO cards, so this seems like the
> > > wrong place for it.
> > 
> > Where do you want it then?
> > 
> 
> drivers/mmc/core/mmc.c seems like the correct place (and some coupling
> from sd.c as well). See if you can do something that's similar to how
> sysfs nodes are handled by the bus handlers.

Hmm...I thought card.c seemed like a good place for card-specific debug
information. Even though this particular attribute isn't relevant to
some types of cards, is that a reason to create the whole directory
elsewhere and add complicated dependencies between files?

How about I check card->type and just not create the "status" attribute
for SDIO cards?

Haavard
