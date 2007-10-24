Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXJXLdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXJXLdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXJXLdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:33:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60484 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXJXLdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:33:11 -0400
Message-ID: <471F2D72.1060501@garzik.org>
Date: Wed, 24 Oct 2007 07:33:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       jens.axboe@oracle.com, greg@kroah.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 01/11] add device_dma_parameters structure
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024174021G.tomof@acm.org>
In-Reply-To: <20071024174021G.tomof@acm.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> iommu code merges scatter/gather segments without considering a low
> level driver's restrictions. The problem is that iommu code can't
> access to the limitations because they are in request_queue.
> 
> This patch adds a new structure, device_dma_parameters, including dma
> information. A pointer to device_dma_parameters is added to struct
> device.
> 
> - there are only max_segment_size and segment_boundary_mask there but
> we'll move more dma stuff in struct device (like dma_mask) to struct
> device_dma_parameters later. segment_boundary_mask is not supported
> yet.
> 
> - new accessors for the dma parameters are added. So we can easily
> change where to place struct device_dma_parameters in the future.
> 
> - dma_get_max_seg_size returns 64K if dma_parms in struct device isn't
> set up properly. 64K is the default max_segment_size in the block
> layer.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/linux/device.h      |   11 +++++++++++
>  include/linux/dma-mapping.h |   15 +++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)

ACK


