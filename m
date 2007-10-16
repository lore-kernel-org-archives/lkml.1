Return-Path: <linux-kernel-owner+w=401wt.eu-S934755AbXJPSAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934755AbXJPSAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbXJPR7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:59:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:40525 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252AbXJPR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pMuKQYwHPLL6QjGetXGMbQ1i6q2pCCwxOVxEJLU/Pf0tG8+ji62Bduzo1eUFOUoXOF3Fx9gTfwQaGPm00i4OBew+q9ccWG1zwbgFkVlmldjdk6jnjCQiFxb4iom9rqdC/1bGEIJVWxHirxZYaWBHJwAA1TgcluNYJpw864OjdeI=
Message-ID: <86802c440710161059x17fdb4f2sb1b9582d64a883f9@mail.gmail.com>
Date: Tue, 16 Oct 2007 10:59:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: MSI interrupts and disable_irq
Cc: "Manfred Spraul" <manfred@colorfullife.com>,
       "Ayaz Abdulla" <aabdulla@nvidia.com>, nedev <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4714F736.5000302@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FC15A9.1070803@nvidia.com> <46FDBCB4.9090802@pobox.com>
	 <4710901F.8010206@colorfullife.com> <4713E713.9060702@pobox.com>
	 <86802c440710161023p3fbd6832gdb6d10a1b5e9d932@mail.gmail.com>
	 <4714F736.5000302@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Jeff Garzik <jgarzik@pobox.com> wrote:
> Yinghai Lu wrote:
> > On 10/15/07, Jeff Garzik <jgarzik@pobox.com> wrote:
> >> Manfred Spraul wrote:
> >>> Jeff Garzik wrote:
> >>>> I think the scenario you outline is an illustration of the approach's
> >>>> fragility:  disable_irq() is a heavy hammer that originated with INTx,
> >>>> and it relies on a chip-specific disable method (kernel/irq/manage.c)
> >>>> that practically guarantees behavior will vary across MSI/INTx/etc.
> >>>>
> >>> I checked the code: IRQ_DISABLE is implemented in software, i.e.
> >>> handle_level_irq() only calls handle_IRQ_event() [and then the nic irq
> >>> handler] if IRQ_DISABLE is not set.
> >>> OTHO: The last trace looks as if nv_do_nic_poll() is interrupted by an irq.
> >>>
> >>> Perhaps something corrupts dev->irq? The irq is requested with
> >>>    request_irq(np->pci_dev->irq, handler, IRQF_SHARED, dev->name, dev)
> >>> and disabled with
> >>>    disable_irq_lockdep(dev->irq);
> >>>
> >>> Someone around with a MSI capable board? The forcedeth driver does
> >>>    dev->irq = pci_dev->irq
> >>> in nv_probe(), especially before pci_enable_msi().
> >>> Does pci_enable_msi() change pci_dev->irq? Then we would disable the
> >>> wrong interrupt....
> >> Remember, fundamentally MSI-X is a one-to-many relationship, when you
> >> consider a single PCI device might have multiple vectors.
> >
> > msi-x is using other entry
> >
> >                if (np->msi_flags & NV_MSI_X_ENABLED)
> >
> > enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
>
> Correct, but the overall point was that MSI-X conceptually conflicts
> with the existing "lockless" disable_irq() schedule, which was written
> when there was a one-one relationship between irq, PCI device, and work
> to be done.

Can I use your new driver with RHEL 5 or RHEL 5.1?

YH
