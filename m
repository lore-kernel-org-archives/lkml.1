Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYF1Pgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYF1Pgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYF1Pgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:36:35 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:50164 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYF1Pge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:36:34 -0400
Date: Sat, 28 Jun 2008 17:36:37 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: Add per-card debugfs support
Message-ID: <20080628173637.53e3279f@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080628172205.430b35b2@mjolnir.drzeus.cx>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214478589-21291-3-git-send-email-haavard.skinnemoen@atmel.com>
	<20080628153745.027b0817@mjolnir.drzeus.cx>
	<20080628154844.35a90ae9@hskinnemo-gx745.norway.atmel.com>
	<20080628160110.41ec91f7@mjolnir.drzeus.cx>
	<20080628161524.5c3fd45f@hskinnemo-gx745.norway.atmel.com>
	<20080628172205.430b35b2@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 15:36:25.0228 (UTC) FILETIME=[B9696CC0:01C8D934]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > Hmm...I thought card.c seemed like a good place for card-specific debug

That should be bus.c of course...

> > information. Even though this particular attribute isn't relevant to
> > some types of cards, is that a reason to create the whole directory
> > elsewhere and add complicated dependencies between files?
> >   
> 
> The directory might be suitable there, just not the "status" file. The
> MMC code used to be a horrible mess of "if":s, "but":s and "when":s in
> order to handle the crappy details of MMC vs SD. I'd like to avoid
> going back to that nightmare as much as possible. The layering can
> never be perfect, but right now it's at least just core.c that needs to
> know about the different systems.
> 
> An alternative to sticking it into mmc.c is to create a debugfs.c that
> contains all the uglyness. Debugging code isn't quite as important to
> keep crystal clear.

But if we're going to rely on gcc optimizing the whole thing away when
debugfs is disabled, we must keep these buggers in the same file as its
caller...

Though I suppose an extra function call that does nothing at host and
card registration time isn't a very high price to pay for cleaner code.

Haavard
