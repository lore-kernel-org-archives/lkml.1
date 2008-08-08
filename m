Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYHHU0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYHHU0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760171AbYHHU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:26:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759945AbYHHU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:26:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=brH8PYfsypUlQ7murspS2DJ4ocPKhxiwlNlJEC5fUIqniAZchpdjUCCgP2LFgMkUZ
	FcGH2PqoiOWu0Kc9uLucw==
Message-ID: <da824cf30808081325n416ec436y94eebe494d789207@mail.gmail.com>
Date: Fri, 8 Aug 2008 13:25:59 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Scatter-gather segment merges by IOMMU?
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <489CA21F.1030604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <489CA21F.1030604@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 12:44 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Hi all,
>
> the block layer usually tries to merge s/g segments if consecutive segments
> combined fit into the queue's max_segment_size.  When such a scatter gather
> list is DMA-mapped, can it happen that an IOMMU collapses the elements even
> further, so that sg_dma_len() of a DMA-mapped s/g segment exceeds
> max_segment_size?

I don't see how. The IOMMU code only collapses the "physical" mappings and
does not add new elements to the SG list. ergo sg_dma_len() shouldn't change.

grant

>
> As I understood some discussions in the past, this could indeed happen,
> which is a nuisance.  But I may have misunderstood something, or something
> may have changed in the meantime...
> --
> Stefan Richter
> -=====-==--- =--- -=---
> http://arcgraph.de/sr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
