Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZLDMOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZLDMOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZLDMOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:14:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38016 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755576AbZLDMOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:14:03 -0500
Date: Fri, 4 Dec 2009 12:16:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
Message-ID: <20091204121604.37be4da2@lxorguk.ukuu.org.uk>
In-Reply-To: <4B182A9F.5090708@garzik.org>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<200912031339.14440.bzolnier@gmail.com>
	<4B17FB37.2030501@garzik.org>
	<200912032045.48728.bzolnier@gmail.com>
	<4B182A9F.5090708@garzik.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >        pata_oldpiix: MWDMA0 is unsupported
> 
> skipped -- Alan, Sergey, comments?

Would need to look at the chip docs again. Certainly the ICH documents
the lack of MWDMA. Dunno about the original PIIX.

Rest looks sane, and that one probably is as the only way to to DMA0
appears to be with TIME0 clear. Unfortunately I can't lay my hands on a
PIIX errata sheet right now. The PIIX4 programming tables don't list
MWDMA0.

The original PIIX datasheet clarifies one other point too

For 32bit PIO it seems you must have bit 4 and 0 of IDETIM set for 32bit
data port access. That is you cannot use 32bit PIO when TIME0/TIME1 are
not set for that device.

MPIIX fixes that restriction (no DMA but does have 32bit PIO for all
modes) by inserting the needed mode 0 two clocks of CS deselect even if
not visible on the ISA bus. The restriction is also not mentioned on
PIIX4+ so presumably is specific to the original chip.




