Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbXJNF71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbXJNF71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXJNF7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:59:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:28573 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXJNF7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bRSCYwDSUm9242GZlHSYZx7MZ8GD31TuJLJ5V8q1LmqxGKfCVOPQrvgcPYvr/zoWPxLFDHdaXJMGso8crhtTWNm79TFOxmX8VJVApOZbNjeNyUovE/m097yZbuRX9hQQJvG2LOK5yDTT8aa/TxlEarRs0PnHZ5resqL+pls9wFE=
Message-ID: <86802c440710132259o6e82f6s4bed7b25bd5636e9@mail.gmail.com>
Date: Sat, 13 Oct 2007 22:59:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Manfred Spraul" <manfred@colorfullife.com>
Subject: Re: MSI interrupts and disable_irq
Cc: "Jeff Garzik" <jgarzik@pobox.com>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       nedev <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4710901F.8010206@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FC15A9.1070803@nvidia.com> <46FDBCB4.9090802@pobox.com>
	 <4710901F.8010206@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Manfred Spraul <manfred@colorfullife.com> wrote:
> Jeff Garzik wrote:
> >
> > I think the scenario you outline is an illustration of the approach's
> > fragility:  disable_irq() is a heavy hammer that originated with INTx,
> > and it relies on a chip-specific disable method (kernel/irq/manage.c)
> > that practically guarantees behavior will vary across MSI/INTx/etc.
> >
> I checked the code: IRQ_DISABLE is implemented in software, i.e.
> handle_level_irq() only calls handle_IRQ_event() [and then the nic irq
> handler] if IRQ_DISABLE is not set.
> OTHO: The last trace looks as if nv_do_nic_poll() is interrupted by an irq.
>
> Perhaps something corrupts dev->irq? The irq is requested with
>     request_irq(np->pci_dev->irq, handler, IRQF_SHARED, dev->name, dev)
> and disabled with
>     disable_irq_lockdep(dev->irq);
>
> Someone around with a MSI capable board? The forcedeth driver does
>     dev->irq = pci_dev->irq
> in nv_probe(), especially before pci_enable_msi().
> Does pci_enable_msi() change pci_dev->irq? Then we would disable the
> wrong interrupt....

the request_irq==>setup_irq will make dev->irq = pci_dev->irq.

YH
