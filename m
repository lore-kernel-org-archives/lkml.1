Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZFWAZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZFWAZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZFWAY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:24:58 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34873 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZFWAY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MbxtEYZKz4mq+UNPSyKfkbbcRIPxJeK16nhFJ1Vka/4c/PECKj6fV3/qwJpcrIDOa/
         I8TxDEpyYJNGhE7wJ7jMQbeE8n71paJYlayvZtrKVCA1vEYsp9tXfw2eysc0btgbwzgA
         z0w6PwApu+Zj6D3wpK/Hu23Y35KwNDIVMR0r8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Date: Tue, 23 Jun 2009 02:30:11 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906221348.02632.bzolnier@gmail.com> <20090622.163136.246300819.davem@davemloft.net>
In-Reply-To: <20090622.163136.246300819.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230230.14074.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009 01:31:36 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 22 Jun 2009 13:48:02 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] cs5520: add missing IRQ setup for the second port
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > This is obviously correct regression fix.  The only problem is that
> > it cannot be applied under the new rigid policy before somebody with
> > the hardware verifies it.  This will only result in a needless delay
> > in this case (IMHO a common sense works better than rigid policies).
> 
> Such hard rules don't apply to regression fixes.  Patch
> applied, thanks.
> 
> But I certainly would have required some positive testing for the
> commit which introduced this problem!

You can from now on.

> I've added some verbosity to the commit message, so that people can
> track where the problem was introduced, and exactly how this problem
> arose, like so:
> 
> cs5520: add missing IRQ setup for the second port

> This fixes a regression introduced by commit
> 86ccf37c6acd74cf7e4b7751ee045de19943c5a0 ("ide: remove pciirq argument
> from ide_pci_setup_ports()")
> 
> ide_pci_setup_ports() would loop over the available ports, one
> by one, recording IRQ numbers increasingly from the one passed
> in as "pciirq".  The conversion only assigned the initial port's
> IRQ, 14, but left the second one not setup.
> 
> [ Make commit message more verbose -DaveM ]

I didn't remember which commit was it so I didn't include it in the patch
description.  This is certainly not the commit above (if you're making such,
changes please make sure that you actually understand the code -- you have
it easy now as it is orders of magnitude simpler than it was few years ago).

Looking a bit more in depth it could be that it was never a regression
and I'm no longer sure that the change is correct (sorry for that, I was
blinded by code in pata_cs5520.c).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
