Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbYA2DV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbYA2DV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYA2DVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:21:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbYA2DVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:21:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=H+L1Kf8BFALcmYt+i5DMNT3Ub3HcOJ8xFdLGnu5aMJwWat7xglljIpAd7n9NpPV92
	zwzX+OGU1ykts57pDOHTw==
Message-ID: <da824cf30801281921n603458c4wc8caf34791401514@mail.gmail.com>
Date: Tue, 29 Jan 2008 14:21:39 +1100
From: "Grant Grundler" <grundler@google.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: DMA mapping on SCSI device?
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <479E6E8C.2090501@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479E6E8C.2090501@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 11:08 AM, Robert Hancock <hancockr@shaw.ca> wrote:
...
> The last solution I tried was to set the DMA mask on both ports to
> 32-bit on slave_configure when an ATAPI device is connected. However,
> this runs into complications as well. This is run on initialization and
> when trying to set the other port into 32-bit DMA, it may not be
> initialized yet. Plus, it forces the port with a hard drive on it into
> 32-bit DMA needlessly.

Have you measured the impact of setting the PCI dma mask to 32-bit?

Last time Alex Williamson (HP) measured this on IA64, we deliberately
forced pci_map_sg() to use the IOMMU even for devices that were 64-bit
capable. We got 3-5% better throughput since the device had fewer
entries to retrieve and the devices (at the time) weren't that good at
processing SG lists.

>
> The ideal solution would be to do mapping against a different struct
> device for each port, so that we could maintain the proper DMA mask for
> each of them at all times. However I'm not sure if that's possible. The
> thought of using the SCSI struct device for DMA mapping was brought up
> at one point.. any thoughts on that?

I'm pretty sure that's not possible (using two PCI dev structs). I'm
skeptical it's worth converting DMA services to use SCSI devs since
that's an extremely invasive change for a marginal benefit.

hth,
grant

> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
