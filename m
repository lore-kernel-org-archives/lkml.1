Return-Path: <linux-kernel-owner+w=401wt.eu-S1030760AbXDXMHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760AbXDXMHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXDXMHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:07:08 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:38027 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030760AbXDXMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:07:06 -0400
In-Reply-To: <ada7is27vdv.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>
MIME-Version: 1.0
Subject: Re: [PATCH] ib_core: Add missing device link to class device
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF8C8AA8EC.A66DAC49-ONC12572C7.00416B4B-C12572C7.00428AF7@de.ibm.com>
Date: Tue, 24 Apr 2007 14:06:59 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 24/04/2007 14:07:01,
	Serialize complete at 24/04/2007 14:07:01
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 23.04.2007 21:17:48:

> Hmm, I have links like this on my system already:
> 
> the patch actually looks sane but I don't understand why it's needed.
> Could you explain?

I had a look at the kernel code -- currently, all device drivers except
ehca do this by themselves:

cxgb3:
1110         dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
1111         dev->ibdev.class_dev.dev = &(dev->rdev.rnic_info.pdev->dev);

amso1100:
798         dev->ibdev.dma_device = &dev->pcidev->dev;
799         dev->ibdev.class_dev.dev = &dev->pcidev->dev;

ipath:
1559         dev->dma_device = &dd->pcidev->dev;
1560         dev->class_dev.dev = dev->dma_device;

mthca:
1295         dev->ib_dev.dma_device           = &dev->pdev->dev;
1296         dev->ib_dev.class_dev.dev        = &dev->pdev->dev;

So I think it makes a lot of sense to put the class_dev.dev assignment
into generic ib_core code instead of repeating it in all the drivers.
The respective lines could move out of the drivers in the future but
won't hurt anyone until then.

What's your take on this?

Cheers,
  Joachim

---
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 
