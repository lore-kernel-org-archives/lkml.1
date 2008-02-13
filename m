Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbYBMTMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbYBMTMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYBMTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:12:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:53755 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYBMTMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:12:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sWQpt4FxkfSA1VyZfZCxaJdNIhjAbSM/zkI4LHxj2EQ+4PXODqyyZb6Byz9g21u3/U5qX151RNdk8UY2eKi/9ueJEAAey1XiAViEEdQoHJpWFtcEihfOKn7WrvyTn6tlVWK9Ry5FD9K5ZmNkKn6fPYw6RTK409FX3YDXxVMphDA=
Message-ID: <e9c3a7c20802131111l86bf853y9173e23526aeb84c@mail.gmail.com>
Date: Wed, 13 Feb 2008 12:11:58 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 5/5] Atmel MCI: Driver for Atmel on-chip MMC controllers
Cc: linux-kernel@vger.kernel.org, "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>
In-Reply-To: <1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	 <1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 20ad3d668dc381d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 11:10 AM, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
[..]
> +/*
> + * Returns a mask of flags to be set in the command register when the
> + * command to start the transfer is to be sent.
> + */
> +static u32 atmci_prepare_data(struct mmc_host *mmc, struct mmc_data *data)
[..]
> +       for_each_sg(data->sg, sg, sg_len, i) {
> +               if (i == sg_len - 1)
> +                       dma_flags = DMA_PREP_INTERRUPT;
> +
> +               dev_vdbg(&mmc->class_dev, "  addr %08x len %u\n",
> +                               sg_dma_address(sg), sg_dma_len(sg));
> +
> +               desc = chan->device->device_prep_slave(chan,
> +                               sg_dma_address(sg), direction,
> +                               DMA_SLAVE_WIDTH_32BIT,
> +                               sg_dma_len(sg), dma_flags);
> +               desc->txd.callback = NULL;
> +               list_add_tail(&desc->client_node,
> +                               &host->dma.data_descs);
> +       }

Need to handle device_prep_slave returning NULL?
