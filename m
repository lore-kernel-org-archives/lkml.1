Return-Path: <linux-kernel-owner+w=401wt.eu-S1764230AbXJNXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764230AbXJNXP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbXJNXPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:15:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:14400 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbXJNXPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bmYSL0YAnivcki1802RPpyqiM0D/dAquZ4mHYexF5xxUrmO6pNv29K7mhd46x5MGE1L/hC36KrhGoxmOK5neLlYUbOh7ptPJw2jMlROVDpnWpTQeICphKBQZ57eXVFOfGDNQPloVHVIr5XtDaTgGq48mCdbFclxZrkbxoZ+GMM4=
Message-ID: <86802c440710141615g60fb9775oba590deb1a9fabde@mail.gmail.com>
Date: Sun, 14 Oct 2007 16:15:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: MSI interrupts and disable_irq
Cc: "Manfred Spraul" <manfred@colorfullife.com>,
       "Jeff Garzik" <jgarzik@pobox.com>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       nedev <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1192398473.6188.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FC15A9.1070803@nvidia.com> <46FDBCB4.9090802@pobox.com>
	 <4710901F.8010206@colorfullife.com>
	 <86802c440710132259o6e82f6s4bed7b25bd5636e9@mail.gmail.com>
	 <4711C217.2010605@colorfullife.com> <1192398473.6188.10.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
> On Sun, 2007-10-14 at 09:15 +0200, Manfred Spraul wrote:
> > Yinghai Lu wrote:
> > > On 10/13/07, Manfred Spraul <manfred@colorfullife.com> wrote:
> > >
> > >> Someone around with a MSI capable board? The forcedeth driver does
> > >>     dev->irq = pci_dev->irq
> > >> in nv_probe(), especially before pci_enable_msi().
> > >> Does pci_enable_msi() change pci_dev->irq? Then we would disable the
> > >> wrong interrupt....
> > >>
> > >
> > > the request_irq==>setup_irq will make dev->irq = pci_dev->irq.
> > >
> > >
> > Where is that?
> > Otherwise I would propose the attached patch. My board is not
> > MSI-capable, thus I can't test it myself.
>
> Why not just copy pcidev->irq to dev->irq once ?

it seems e1000 is using np->pci_dev->irq directly too.

YH
