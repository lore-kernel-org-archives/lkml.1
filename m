Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXJ2P0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXJ2P0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXJ2PZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:25:59 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:42264 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbXJ2PZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:subject:date:to:x-mailer:from;
        b=FH3uJ938dkW3M/FfKGcJxQmmXR5SjMS7icUJ3rF0sKk2sdU/NCpfqUI6FRwkiOKxaWhGtG7pY9/zvb+cJ2n8Ql6jw0YidNdAE9Nc+qLhaJZl4ESRtne/MdTDJv5DUgGx3FpEeJE2+zFFgxhLsUegD81hTt8ulwXdjF5XWcJbUr8=
In-Reply-To: <20071029045116.GB8181@ftp.linux.org.uk>
References: <20071029045116.GB8181@ftp.linux.org.uk>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8B618420-85D9-415C-8FE5-38D32235A623@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] intel-iommu fixes
Date: Mon, 29 Oct 2007 10:25:54 -0500
To: Al Viro <viro@ftp.linux.org.uk>
X-Mailer: Apple Mail (2.752.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 28, 2007, at 11:51 PM, Al Viro wrote:

> 	* off by one in dmar_get_fault_reason() (maximal index in
> array is ARRAY_SIZE()-1, not ARRAY_SIZE())
> 	* NULL noise removal
> 	* __iomem annotation fix
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 0c4ab3b..9b35259 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -745,7 +745,7 @@ static char *fault_reason_strings[] =
>  	"non-zero reserved fields in PTE",
>  	"Unknown"
>  };
> -#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings)
> +#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1

This define now should really have ()'s around its value now that it  
is an expression to avoid potential problems at its reference sites.

<snip>

-- 
Mark Rustad, MRustad@gmail.com


