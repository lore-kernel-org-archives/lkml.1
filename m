Return-Path: <linux-kernel-owner+w=401wt.eu-S967597AbXEHNo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967597AbXEHNo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967562AbXEHNoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:44:55 -0400
Received: from rtr.ca ([64.26.128.89]:3889 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967505AbXEHNoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:44:54 -0400
Message-ID: <46407ED4.9090301@rtr.ca>
Date: Tue, 08 May 2007 09:44:52 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Kyle McMartin <kyle@ubuntu.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Cleanup libata HPA support
References: <1178621978.6962.75.camel@cunning>
In-Reply-To: <1178621978.6962.75.camel@cunning>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins wrote:
..
>  static u64 ata_tf_to_lba48(struct ata_taskfile *tf)
>  {
> -	u64 sectors = 0;
> +	u64 sectors;
> +	u32 high, low;
>  
> -	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
> -	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
> -	sectors |= (tf->hob_lbal & 0xff) << 24;
> -	sectors |= (tf->lbah & 0xff) << 16;
> -	sectors |= (tf->lbam & 0xff) << 8;
> -	sectors |= (tf->lbal & 0xff);
> +	high = (tf->hob_lbah << 16) |
> +	       (tf->hob_lbam <<  8) |
> +		tf->hob_lbal;
> +	low  = (tf->lbah << 16) |
> +	       (tf->lbam <<  8) |
> +		tf->lbal;
>  
> -	return ++sectors;
> +	sectors = ((u64)high << 24) | low;
> +
> +	return sectors + 1;
>  }

Ben, I very much prefer the fixed version of this function
as implemented by the patch above.

But.. is the original code actually broken, or just messy?

Cheers

