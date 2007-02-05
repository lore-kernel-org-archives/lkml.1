Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbXBEPgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbXBEPgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 10:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbXBEPgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 10:36:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933001AbXBEPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 10:36:08 -0500
Date: Mon, 5 Feb 2007 15:49:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx: don't
 configure udma mode higher than BIOS did)
Message-ID: <20070205154903.0ac71232@localhost.localdomain>
In-Reply-To: <45C7444F.4070500@gmail.com>
References: <20070205075836.GG1625@htj.dyndns.org>
	<20070205112410.5a3c3182@localhost.localdomain>
	<45C72012.7050605@gmail.com>
	<20070205132247.6f611e3c@localhost.localdomain>
	<45C73A3E.6080700@gmail.com>
	<20070205143439.6962c076@localhost.localdomain>
	<45C7444F.4070500@gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > No the IDE layer does DMA changedown fine, well apart from all the
> > error/timer races in the old IDE code.
> 
> I dunno.  It always ended up in PIO mode in my case.  I can post the log
> if necessary.

Ok testing my hardware

- AMD get it right for those with host cable detect
- AMD get it right for disk side detect

- My NV03 gets it wrong on all counts but it pauses only briefly to
change neatly down to UDMA33 with old IDE.

(We could speed that with libata by going straight to UDMA33 on cable
error with PATA_CBL_UNK or some other way to flag "cable detection
untrusted")

The BIOS seems to get the detection it does right, so we need an Nvidia
person to answer this properly. Nvidia + 40pin cable is still clearly such
an obscure setting we don't want to damage general behaviour for it.

Good news is that the AMD just works, that AFAIK means all the non x86 PC
cases just work.

Alan
