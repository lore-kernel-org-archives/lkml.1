Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZIFFdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZIFFdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZIFFdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:33:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51460 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZIFFdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:33:41 -0400
Date: Sun, 6 Sep 2009 07:33:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH 10/18] ioat3: xor support
Message-ID: <20090906053336.GA1431@ucw.cz>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com> <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static struct dma_async_tx_descriptor *
> +__ioat3_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
> +		      dma_addr_t dest, dma_addr_t *src, unsigned int src_cnt,
> +		      size_t len, unsigned long flags)
> +{
> +	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
> +	struct ioat_ring_ent *compl_desc;
> +	struct ioat_ring_ent *desc;
> +	struct ioat_ring_ent *ext;
> +	size_t total_len = len;
> +	struct ioat_xor_descriptor *xor;
> +	struct ioat_xor_ext_descriptor *xor_ex = NULL;
> +	struct ioat_dma_descriptor *hw;
> +	u32 offset = 0;
> +	int num_descs;
> +	int with_ext;
> +	int i;
> +	u16 idx;
> +	u8 op = result ? IOAT_OP_XOR_VAL : IOAT_OP_XOR;

Coalesce more variables on one line, so that declaration is shorter?

> --- a/drivers/dma/ioat/registers.h
> +++ b/drivers/dma/ioat/registers.h
> @@ -243,6 +243,8 @@
>  #define IOAT_CHANERR_XOR_Q_ERR			0x20000
>  #define IOAT_CHANERR_DESCRIPTOR_COUNT_ERR	0x40000
>  
> +#define IOAT_CHANERR_HANDLE_MASK (IOAT_CHANERR_XOR_P_OR_CRC_ERR | IOAT_CHANERR_XOR_Q_ERR)
> +
>  #define IOAT_CHANERR_MASK_OFFSET		0x2C	/* 32-bit Channel Error Register */
>  

80 columns?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
