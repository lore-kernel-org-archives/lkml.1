Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400Ab0ANVCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0ANVCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832Ab0ANVCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:02:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45612 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754507Ab0ANVCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:02:01 -0500
Date: Thu, 14 Jan 2010 21:05:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
Message-ID: <20100114210515.7a477a43@lxorguk.ukuu.org.uk>
In-Reply-To: <m3my0gh2dc.fsf@intrepid.localdomain>
References: <m33a4nfvva.fsf@intrepid.localdomain>
	<201001141659.19687.bzolnier@gmail.com>
	<20100114192210.62593ead@lxorguk.ukuu.org.uk>
	<m3my0gh2dc.fsf@intrepid.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We need to use the MMIO BAR at least for starting DMA transfers, the
> I/O ones are 64KB-limited. We can't just use read[bw] if reading all
> 32 bits has side effects.

Last time I instrumented this on x86 we never issued a > 64K linear block
in our s/g lists. In fact we went for years before anyone noticed we had
a bug with CS5530 and a couple of other chips that mishandled 64K segment
sizes, and that was only finally noticed in a very specific and weird
circumstance.

> Most of the time there are no problems with MMIO on IXP4xx as modern
> devices usually use 32-bit registers anyway, or at least they have no
> problem with read[bw] always driving all four PCI byte enable lines
> (write[bw] doesn't have this issue).

Fair enough

