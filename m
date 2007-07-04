Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXGDTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXGDTWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXGDTWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 15:22:10 -0400
Received: from nn7.de ([85.214.94.156]:35274 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbXGDTWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 15:22:08 -0400
Subject: Re: ata1: soft resetting port
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <468BE06D.4010507@gmail.com>
References: <1182260902.14805.60.camel@localhost>
	 <4689EF48.8090506@gmail.com> <1183545657.22999.15.camel@localhost>
	 <468BE06D.4010507@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2007 21:22:04 +0200
Message-Id: <1183576924.4697.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 03:01 +0900, Tejun Heo wrote:
> Soeren Sonnenburg wrote:
> > On Tue, 2007-07-03 at 15:40 +0900, Tejun Heo wrote:
> >> Soeren Sonnenburg wrote:
> >>> Dear List,
> >>>
> >>> since the switch to 
> >>>
> >>> CONFIG_ATA=y
> >>> CONFIG_ATA_ACPI=y
> >>> CONFIG_ATA_PIIX=y,
> >>>
> >>> the ATA_PIIX driver manages both, internal sata disk aswell as cd/dvd
> >>> rom. However I am being flooded with the error messages below (well they
> >>> appear from time to time, dominating dmesg). 
> >>>
> >>> This happens on kernel 2.6.22-rc5, I am copying relevant parts from dmesg:
> >> Does 2.6.22-rc7 fare better?
> > 
> > Yes indeed. The only thing I've seen in the last two days was the
> > following on resume:
> > 
> > pci_express 0000:00:1c.2:pcie03: resuming
> > sr 0:0:0:0: resuming
> > sd 2:0:1:0: resuming
> > sd 2:0:1:0: [sda] Starting disk
> > ata1.00: configured for UDMA/33
> > ata3.01: revalidation failed (errno=-2)
> > ata3: failed to recover some devices, retrying in 5 secs
> > ata3.01: configured for UDMA/133
> 
> Hmmm... That's NODEV_HINT being triggered after resume.  Probably the
> device isn't ready to respond yet at that point.  How reproducible is
> the problem?

quite reproducible:

$ dmesg | grep 'revalidation failed' | wc -l
4

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
