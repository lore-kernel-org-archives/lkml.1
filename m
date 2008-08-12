Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYHLV2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYHLV2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYHLV14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:27:56 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11326 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHLV1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:27:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: pnp bug in 2.6.27-rc1 (ad1816a / mpu401 / parport_pc issue)
Date: Tue, 12 Aug 2008 15:26:12 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@osdl.org, perex@perex.cz, abelay@mit.edu,
       debian-kernel@lists.debian.org, linux-kernel@vger.kernel.org
References: <200808041531.10557.uwe.bugla@gmx.de> <200808121317.27323.uwe.bugla@gmx.de> <200808121210.52589.bjorn.helgaas@hp.com>
In-Reply-To: <200808121210.52589.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121526.12483.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 12:10:51 pm Bjorn Helgaas wrote:
> On Tuesday 12 August 2008 05:17:26 am Uwe Bugla wrote:
> > Case C:
> > same preconditions as case B, but additionally:
> > 1. no IRQs reserved for ISA use only (in BIOS)
> > This option I would call "PNP pure"

> > ...
> > My only criticism within the desired case C (no additional screwing around 
> > done by user)
> > consists of two points:
> > 1. I'd prefer the second parport running with IRQ 5 instead of in polling 
> > mode.
> 
> Yes, that would be good.  But I think the only way to achieve this
> reliably is to use the "pnp_reserve_irq=5" kernel parameter and the
> "options parport_pc io=0x278 irq=5" module parameter.  Otherwise the
> kernel doesn't know how the jumpers on the ISA parport card are set.

One more thing: since you have a non-PNP ISA card, I don't think
you can reliably use a "pure PNP" approach.  In addition to the
kernel and module parameters, I think you need to configure the
BIOS to reserve IRQ 5 for ISA use.  Otherwise, the BIOS might put
some other device on IRQ 5.

Of course, if you are content to run the second parport in polling
mode, you wouldn't need the BIOS configuration.

Bjorn
