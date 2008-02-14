Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbYBNHEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbYBNHEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYBNHEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:04:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBNHEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:04:38 -0500
Date: Thu, 14 Feb 2008 02:04:37 -0500
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sysv: [bl]e*_add_cpu conversion
Message-ID: <20080214070437.GA15395@infradead.org>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-17-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202857582-15450-17-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:06:21AM +0100, marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> big/little_endian_variable = cpu_to_[bl]eX([bl]eX_to_cpu(big/little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	[bl]eX_add_cpu(&big/little_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch

The patch looks correct to me, so ACK.

> diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
> index 42d51d1..38ebe3f 100644
> --- a/fs/sysv/sysv.h
> +++ b/fs/sysv/sysv.h
> @@ -217,9 +217,9 @@ static inline __fs32 fs32_add(struct sysv_sb_info *sbi, __fs32 *n, int d)
>  	if (sbi->s_bytesex == BYTESEX_PDP)
>  		*(__u32*)n = PDP_swab(PDP_swab(*(__u32*)n)+d);
>  	else if (sbi->s_bytesex == BYTESEX_LE)
> -		*(__le32*)n = cpu_to_le32(le32_to_cpu(*(__le32*)n)+d);
> +		le32_add_cpu((__le32 *)n, d);
>  	else
> -		*(__be32*)n = cpu_to_be32(be32_to_cpu(*(__be32*)n)+d);
> +		be32_add_cpu((__be32 *)n, d);
>  	return *n;

but now that you've named the be and le primitives *_add_cpu it would
be nice if you could submit a second patch to sysv to rename fs*_add
to fs*_add_cpu aswell.
