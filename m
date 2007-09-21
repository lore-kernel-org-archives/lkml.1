Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbXIUUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbXIUUMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760968AbXIUUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:12:03 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:8735 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXIUUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R8xeItm6PpOhpe/TQ+uygKYoYtk3ZZa/5Pga9NOZRIMDO+U1j1oP2Aa+9muZG3NbfKoEWhQA6C/EgiLJ2SnYoKZpYd210UcbyZpKk3Z/XdEiBqEDNQcc+yKvdkyTf190P1atq9Xj85xukzG2xknlMUYs3pXvnS0vHk8ufOXV/R0=
Message-ID: <f870da180709211311j4f8599afy4003bfdafb1200d1@mail.gmail.com>
Date: Fri, 21 Sep 2007 22:11:59 +0200
From: "Mike Rapoport" <mike.rapoport@gmail.com>
Subject: Re: [PATCH 02/03] CM-x270: ITE 8152 PCI bridge support
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070921130119.GB20538@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F29A0A.4000407@compulab.co.il>
	 <Pine.LNX.4.63.0709211240570.9343@pcgl.dsa-ac.de>
	 <20070921130119.GB20538@flint.arm.linux.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Fri, Sep 21, 2007 at 12:42:55PM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 20 Sep 2007, Mike Rapoport wrote:
> >
> > > This patch provides driver for ITE 8152 PCI bridge.
> > >
> > > Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> > >
> > >  arch/arm/common/Makefile          |    1 +
> > >  arch/arm/common/it8152.c          |  387 +++++++++++++++++++++++++++++++++++++
> >
> > Shouldn't it go to drivers/pci and define a platform driver? it8152 is not
> > an ARM specific controller.
>
> drivers/pci is currently only used for the PCI bus infrastructure.  The
> setup of host bridges is very platform dependent.
>
> Also note that you should *avoid* DMA bounce wherever possible.
> The code is broken as designed.  Ensure that the DMA mask is set
> appropriately, and then moan elsewhere if things don't work.

That's more or less what I'm trying to do. ITE chip allows to address
up to 64Mbyte, so I have to ensure that *no* PCI device will ever try
to DMA above that limit.
I don't see other way to ensure it.


> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>


-- 
	Sincerely Yours,
		Mike.
