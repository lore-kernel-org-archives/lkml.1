Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYHPGmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYHPGmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 02:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYHPGm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 02:42:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:19703 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYHPGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 02:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iQZ5MazjvgGGPtpaA5x97hEfV9pbeS9Osaw4RYIo94FHqE1YsxOAhuU2ci6Ntz//2n
         RyehMWJTSRfyvB5hAx/zRWNTXfpJBNpCtxZi04uRK3REvocDiYu5Z28aNc2ixwUPJ/iq
         az4ES/FvFaGUZnQ8d8qkXTJEHMRmA1AVCuBgQ=
Message-ID: <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
Date: Fri, 15 Aug 2008 23:42:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>
In-Reply-To: <200808160326.m7G3QR1G012726@terminus.zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 8:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The 28 bits aren't enough, are they: we need domain as well (and surely we can have more than 16 domains?)

current code
static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
{
        unsigned int irq;

        irq = dev->bus->number;
        irq <<= 8;
        irq |= dev->devfn;
        irq <<= 12;

        return irq;
}

int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
{
        unsigned int irq;
        int ret;
        unsigned int irq_want;

        irq_want = build_irq_for_pci_dev(dev) + 0x100;

        irq = create_irq(irq_want);

domain is not used yet.

need to make vecter_irq to vector_domain_irq

irq_desc(irq) change to domain_irq_desc(domain, irq)

...

YH

YH
