Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZBKPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZBKPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZBKPZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:25:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZBKPZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:25:48 -0500
Date: Wed, 11 Feb 2009 16:25:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [bug] sata detection problem
Message-ID: <20090211152530.GA18660@elte.hu>
References: <20090208063516.GA2318@elte.hu> <4992EAAB.3010809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4992EAAB.3010809@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> Hello,
> 
> Ingo Molnar wrote:
> > Hm, in a boot test i had this boot failure:
> > 
> > [   15.504053] calling  piix_init+0x0/0x30 @ 1
> > [   15.508050] ata_piix 0000:00:1f.1: version 2.12
> > [   15.516193] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
> > [   15.520029] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKG] -> GSI 11 (level, low) -> IRQ 11
> > [   15.524072] ata_piix 0000:00:1f.1: setting latency timer to 64
> > [   15.528115] scsi0 : ata_piix
> > [   15.531526] scsi1 : ata_piix
> > [   15.544044] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> > [   15.548028] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> > [   15.716358] ata1.00: ATAPI: ýVýVýVýVýVýýýýýýýýýýýýýýýýýýýýýýýýýýýýýý, ýýVýVýV, max UDMA7
> > [   15.720044] ata1.00: limited to UDMA/33 due to 40-wire cable
> > [   15.740296] ata1.00: configured for UDMA/33
> 
> That's one strange ghost device detection.  Because PATA doesn't have
> a reliable way of determining device presence, libata uses combination
> of tests along the probing sequence to determine device presence.
> Each test is intentionally made somewhat relaxed to avoid missing a
> present device (and those condition often do trigger).  It seems
> somehow it is passing all the existing tests.  The hardest part
> probably is the IDENTIFY command sequence but for SFF controllers it's
> done via polling instead of IRQ and thus by having the right (or
> wrong) status register value a port with floating pins may be able to
> pass it.
> 
> How reproducible is the problem?  It can probably be worked around by
> making the NODEV_HINT checking a tad bit tighter in SFF host state
> machine.  PATA device presence detection is an art not an exact
> science.  :-)

it's very sporadic - out of thousands of bootups this is the first time :-/

	Ingo
