Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZFWBAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZFWBAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZFWBAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:00:08 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:39966 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZFWBAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=X1iH0mRLjdClzMUqSXhihM1zmgggVeVBxb84vFB9zVl+pHGCuLrozkE8LXS8NXYoAv
         nefqhvMRmaVd4btjYJWjKZpUgN/Gd+/o2D3UwMHLrcrRdRt30ohEMRKiWNdTLmgKAmZj
         Q0H2wGexSchGfJctkKKJwbsbG23T2T5EPGdPA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
Date: Tue, 23 Jun 2009 03:05:55 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906221348.02632.bzolnier@gmail.com> <20090622.163136.246300819.davem@davemloft.net> <200906230230.14074.bzolnier@gmail.com>
In-Reply-To: <200906230230.14074.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906230305.55283.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009 02:30:11 Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 23 June 2009 01:31:36 David Miller wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date: Mon, 22 Jun 2009 13:48:02 +0200
> > 
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] cs5520: add missing IRQ setup for the second port
> > > 
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > ---
> > > This is obviously correct regression fix.  The only problem is that
> > > it cannot be applied under the new rigid policy before somebody with
> > > the hardware verifies it.  This will only result in a needless delay
> > > in this case (IMHO a common sense works better than rigid policies).
> > 
> > Such hard rules don't apply to regression fixes.  Patch
> > applied, thanks.
> > 
> > But I certainly would have required some positive testing for the
> > commit which introduced this problem!
> 
> You can from now on.
> 
> > I've added some verbosity to the commit message, so that people can
> > track where the problem was introduced, and exactly how this problem
> > arose, like so:
> > 
> > cs5520: add missing IRQ setup for the second port
> 
> > This fixes a regression introduced by commit
> > 86ccf37c6acd74cf7e4b7751ee045de19943c5a0 ("ide: remove pciirq argument
> > from ide_pci_setup_ports()")
> > 
> > ide_pci_setup_ports() would loop over the available ports, one
> > by one, recording IRQ numbers increasingly from the one passed
> > in as "pciirq".  The conversion only assigned the initial port's
> > IRQ, 14, but left the second one not setup.
> > 
> > [ Make commit message more verbose -DaveM ]
> 
> I didn't remember which commit was it so I didn't include it in the patch
> description.  This is certainly not the commit above (if you're making such,
> changes please make sure that you actually understand the code -- you have
> it easy now as it is orders of magnitude simpler than it was few years ago).
> 
> Looking a bit more in depth it could be that it was never a regression
> and I'm no longer sure that the change is correct (sorry for that, I was
> blinded by code in pata_cs5520.c).
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>

Please give people some time (few days) to review and comment patches before
applying them.  I don't trust my own patches too much so I'm always looking
for some peer review (usually all host driver patches go through Sergei, in
this case Frans would have probably shot the patch down)..
