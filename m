Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZEZFSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZEZFSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 01:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZEZFSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 01:18:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:50592 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZEZFSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 01:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GtvXiYyjuLf299ykSD+h3PB4SuLymYPF1OtWGcIne1HDr0PWfTkNiXe3pQFBWZ5WiZ
         mhzFdBrp459hFWYOZKPXIhtpjULRAvX7vmiO6Hgtp/EjloNgvkg/xa+1NW9SOIMsTDBN
         P1Mz90QAD/zqyvDhyXiiWdYapz7VZqN3zIJmU=
Subject: Re: [PATCH v2] MFD: PCAP core driver.
From: Daniel Ribeiro <drwyrm@gmail.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       David Brownell <david-b@pacbell.net>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <74d0deb30905251255o2d0fb0edr4b2f52aa6a696d7c@mail.gmail.com>
References: <1242740566.6142.54.camel@brutus>
	 <1242928320.22873.18.camel@brutus>
	 <74d0deb30905251255o2d0fb0edr4b2f52aa6a696d7c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 May 2009 02:10:35 -0300
Message-Id: <1243314635.10927.30.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp, Thanks for the review! :)

Em Seg, 2009-05-25 às 21:55 +0200, pHilipp Zabel escreveu:
> > +static int pcap_add_subdev(struct spi_device *spi, struct pcap_subdev *subdev)
> > +{
> > +       struct platform_device *pdev;
> > +
> > +       pdev = platform_device_alloc(subdev->name, subdev->id);
> > +       pdev->dev.parent = &spi->dev;
> > +       pdev->dev.platform_data = subdev->platform_data;
> > +
> > +       return platform_device_add(pdev);
> > +}
> 
> This pcap_subdev, pcap_remove/add_subdev business looks a bit like
> you're duplicating the MFD core just because it doesn't handle
> resource-less mfd_cells. I wonder whether it'd be better to fix that
> and then use
> mfd_cell, mfd_add/remove_devices instead?

Due to the lack of comments on this driver, i started grepping LKML for
previous MFD reviews. Now the driver allows multiple instances and no
longer keeps pcap_chip as a global(as per Samuel comments on U300/AB3100
driver), result is that resource-less mfd_cells are no longer the only
issue so I can use the mfd_ API: Now I also need a way to pass a
pcap_chip pointer to the subdevs.

> > +       set_irq_type(pdata->irq, IRQ_TYPE_EDGE_RISING);
> > +       set_irq_chained_handler(pdata->irq, pcap_irq_handler);
> > +       set_irq_wake(pdata->irq, 1);
> 
> Looking at the other MFD drivers that register a chained handler,
> providing this IRQ via a resource seems to be the default.

Ok, will do.


I will send a new version of the patch tomorrow, after i finish
converting all the subdevices to the new code.

Thanks!

-- 
Daniel Ribeiro

