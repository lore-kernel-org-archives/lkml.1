Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbYF1PWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbYF1PWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYF1PWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:22:09 -0400
Received: from server.drzeus.cx ([85.8.24.28]:56965 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211AbYF1PWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:22:07 -0400
Date: Sat, 28 Jun 2008 17:22:05 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628172205.430b35b2@mjolnir.drzeus.cx>
In-Reply-To: <20080628161524.5c3fd45f@hskinnemo-gx745.norway.atmel.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153745.027b0817@mjolnir.drzeus.cx>
	<20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
	<20080628160110.41ec91f7@mjolnir.drzeus.cx>
	<20080628161524.5c3fd45f@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 16:15:24 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > On Sat, 28 Jun 2008 15:48:44 +0200
> > Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > 
> > > Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > > The status command doesn't work on SDIO cards, so this seems like the
> > > > wrong place for it.
> > > 
> > > Where do you want it then?
> > > 
> > 
> > drivers/mmc/core/mmc.c seems like the correct place (and some coupling
> > from sd.c as well). See if you can do something that's similar to how
> > sysfs nodes are handled by the bus handlers.
> 
> Hmm...I thought card.c seemed like a good place for card-specific debug
> information. Even though this particular attribute isn't relevant to
> some types of cards, is that a reason to create the whole directory
> elsewhere and add complicated dependencies between files?
> 

The directory might be suitable there, just not the "status" file. The
MMC code used to be a horrible mess of "if":s, "but":s and "when":s in
order to handle the crappy details of MMC vs SD. I'd like to avoid
going back to that nightmare as much as possible. The layering can
never be perfect, but right now it's at least just core.c that needs to
know about the different systems.

An alternative to sticking it into mmc.c is to create a debugfs.c that
contains all the uglyness. Debugging code isn't quite as important to
keep crystal clear.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
