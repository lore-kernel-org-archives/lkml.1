Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYHMQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYHMQzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYHMQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:55:16 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32925 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYHMQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:55:14 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: pnp bug in 2.6.27-rc1 (ad1816a / mpu401 / parport_pc issue)
Date: Wed, 13 Aug 2008 10:54:05 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@osdl.org, perex@perex.cz, abelay@mit.edu,
       debian-kernel@lists.debian.org, linux-kernel@vger.kernel.org
References: <200808041531.10557.uwe.bugla@gmx.de> <200808121526.12483.bjorn.helgaas@hp.com> <200808131747.04798.uwe.bugla@gmx.de>
In-Reply-To: <200808131747.04798.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808131054.06469.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008 09:47:04 am Uwe Bugla wrote:
> Am Tuesday 12 August 2008 23:26:12 schrieben Sie:
> > On Tuesday 12 August 2008 12:10:51 pm Bjorn Helgaas wrote:
> > > On Tuesday 12 August 2008 05:17:26 am Uwe Bugla wrote:
> > > > Case C:
> > > > same preconditions as case B, but additionally:
> > > > 1. no IRQs reserved for ISA use only (in BIOS)
> > > > This option I would call "PNP pure"
> > > >
> > > > ...
> > > > My only criticism within the desired case C (no additional screwing
> > > > around done by user)
> > > > consists of two points:
> > > > 1. I'd prefer the second parport running with IRQ 5 instead of in
> > > > polling mode.
> > >
> > > Yes, that would be good.  But I think the only way to achieve this
> > > reliably is to use the "pnp_reserve_irq=5" kernel parameter and the
> > > "options parport_pc io=0x278 irq=5" module parameter.

I see several things that should be fixed in ISAPNP.  I'm working
on those, but they're probably post-2.6.27 material.

In the meantime, are you seeing new problems that were introduced
between 2.6.26 and 2.6.27-rc3?  If so, I should try to fix them
right away so we can get a fix in 2.6.27.

Your original report of "WARNING: at lib/vsprintf.c:609 vsnprintf+0x36/0x43d()"
has been fixed already.  I *think* the remaining issues about the
parport1 IRQ and the MPU401 are related to the BIOS configuration
and the parport_pc module parameters and are not regressions from
2.6.26, but please correct me if I'm wrong.

Thanks for your patience with all this.  I'm putting together an ISA
machine at home now, so hopefully I'll soon have a way to test this
better without wasting your time.

Bjorn
