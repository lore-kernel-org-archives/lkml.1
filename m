Return-Path: <linux-kernel-owner+w=401wt.eu-S1423280AbXBHTif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423280AbXBHTif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423282AbXBHTif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:38:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423280AbXBHTie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:38:34 -0500
Date: Thu, 8 Feb 2007 19:38:27 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumant Patro <sumantp@lsil.com>, James.Bottomley@SteelEye.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl processing
Message-ID: <20070208193827.GA2354@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumant Patro <sumantp@lsil.com>, James.Bottomley@SteelEye.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com
References: <1170800394.10482.41.camel@dumbo> <20070207133020.4c58e271.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207133020.4c58e271.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 01:30:20PM -0800, Andrew Morton wrote:
> On Tue, 06 Feb 2007 14:19:54 -0800
> Sumant Patro <sumantp@lsil.com> wrote:
> 
> > Preallocate memory for ioctl processing. This is to avoid situations 
> > where ioctl fails for lack of memory (when system under heavy stress).
> > The memory pool will have 8*4K, 4*8K and 1*64K memory chunks
> 
> mutter.
> 
> I suspect all this horror is due to stupidity in the DMA API.
> 
> pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
> the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
> to use GFP_KERNEL.
> 
> I bet this fixes it:

but it's ugly as hell, why there is a much more trivial fix for it:
simply use dma_alloc_coherent.

