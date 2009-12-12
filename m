Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbZLLBwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbZLLBwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 20:52:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbZLLBv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 20:51:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbZLLBv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 20:51:59 -0500
Date: Fri, 11 Dec 2009 17:51:56 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Heinz Diehl <htd@fancy-poultry.org>, LKML <linux-kernel@vger.kernel.org>,
       martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
 mapper warnings
In-Reply-To: <20091209220749.GD8742@kernel.dk>
Message-ID: <alpine.DEB.2.01.0912111748003.2915@bogon.housecafe.de>
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209212516.GA6206@fancy-poultry.org> <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/5n+AEGFxUBV3SXFU5W233mtvQ3OnAuqjA6fQ
 lDP8eDJU1V7P+HKsef8KGzZBLMSuvAN2fSK1xqZsloJZPdH8UO
 /EtpkcKC5zvIkTrY9yZWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009 at 23:07, Jens Axboe wrote:
> Does this work?

Although not using LVM, these messages were popping up here too. Your 
patch made these go away with no ill effects so far.
Dmesg and .config: http://nerdbynature.de/bits/2.6.33-git/dm/

Thanks,
Christian.

> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index dd1f1e0..0116d29 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -554,11 +554,13 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  		ret = -1;
>  	}
>  
> +#if 0
>  	if (offset &&
>  	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
>  		t->discard_misaligned = 1;
>  		ret = -1;
>  	}
> +#endif
>  
>  	/* If top has no alignment offset, inherit from bottom */
>  	if (!t->alignment_offset)

-- 
BOFH excuse #254:

Interference from lunar radiation
